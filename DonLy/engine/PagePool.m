//
//  PagePool.m
//  DonLy
//
//  Created by chen dianbo on 13-3-1.
//  Copyright (c) 2013年 chen dianbo. All rights reserved.
//

#import "PagePool.h"
#import "ParserEngine.h"
#import "PageTemplate.h"

@interface PagePool ()

- (NSInteger) doPageWXH:(NSString*) content;
- (NSInteger) doPageYY:(NSString*) content;

@property(nonatomic, assign) NSMutableArray* wxhItemList;
@end

@implementation PagePool
@synthesize wxhItemList;

- (id) init
{
    if (self = [super init]) {
        wxhItemList = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return self;
}

- (void) dealloc
{
    if (wxhItemList) {
        [wxhItemList removeAllObjects];
        [wxhItemList release];
    }
    [super dealloc];
}

- (NSInteger) webPage:(PageType) type f:(NSString*) fileName
{
    NSError* err = nil;
    NSInteger errCode = 0;
    NSString* pageData = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:&err];
    if (nil == err) {
        errCode = [self webPage:type c:pageData];
    } else {
        errCode = err.code;
        __PrintErr(@"page", err)
    }
    return errCode;
}

- (NSInteger) webPage:(PageType) type c:(NSString*) content
{
    NSInteger errCode = 0;
    switch (type) {
        case PT_WXH:
            errCode = [self doPageWXH:content];
            break;
        
        case PT_YY:
            errCode = [self doPageYY:content];
            break;
            
        default:
            errCode = -1;//not found
            break;
    }
    return errCode;
}

#pragma ---- do WXH ----
- (NSInteger) doPageWXH:(NSString*) content
{
    [wxhItemList removeAllObjects];
    [ParserWXH parseWithContent:content items:wxhItemList];
    
#ifdef __ENABLE_LOG__
    __PrintFmt(@"WXH cnt:%d", [wxhItemList count])
    for (ItemWXH* item in wxhItemList) {
        __Print(item.itemId)
        __Print(item.title)
        NSArray* txtList = item.textList;
        for (NSString* txt in txtList) {
            __Print(txt)
        }
        txtList = item.imgUrlList;
        for (NSString* txt in txtList) {
            __Print(txt)
        }
    }
#endif
    return (0 < [wxhItemList count]?0:-1);
}

- (NSInteger) doPageYY:(NSString*) content
{
    return -1;
}

- (NSInteger) count:(PageType) type
{
    switch (type) {
        case PT_WXH: return [wxhItemList count];
            
        default: break;
    }
    return 0;
}

- (NSString*) pageByIndex:(PageType) type index:(NSInteger) index
{
    NSString* html = nil;
    switch (type) {
        case PT_WXH:
            if (0 <= index && index < [wxhItemList count]) {
                html = [PageTemplate htmlWXH:[wxhItemList objectAtIndex:index]];
            }
            break;
            
        default: break;
    }
    return html;
}

@end
