//
//  ParserWXH.m
//  DonLy
//
//  Created by chen dianbo on 13-2-28.
//  Copyright (c) 2013年 chen dianbo. All rights reserved.
//

#import "ParserWXH.h"
#import "JSON.h"

#pragma ---- WXH ----
@implementation ItemWXH
@synthesize itemId;
@synthesize title;
@synthesize textList;
@synthesize imgUrlList;

- (id) init
{
    if (self = [super init]) {
        textList = [[NSMutableArray alloc] initWithCapacity:1];
        imgUrlList = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

- (void) dealloc
{
    [itemId release];
    [title release];
    if (textList) {
        [textList removeAllObjects];
        [textList release];
    }
    if (imgUrlList) {
        [imgUrlList removeAllObjects];
        [imgUrlList release];
    }
    
    [super dealloc];
}

- (bool) isValid
{
    if (nil == itemId || nil == title) return false;
    if (0 == [textList count] && 0 == [imgUrlList count]) return false;
    return true;
}

- (void) addText:(NSString*) text
{
    if (nil == text) return;
    if (nil == itemId) { self.itemId = text; return ; }
    if (nil == title)  { self.title = text;  return ; }
    if (15 < [text length] &&
        NSOrderedSame == [[text substringToIndex:5] compare:@"http:"]) {//image url
        [imgUrlList addObject:text];
    } else {//text content
        [textList addObject:text];
    }
}

@end


#pragma ---- ParserWXH ----
@interface ParserWXH ()

+ (NSString*) findJsonBody:(NSString*) content;

@end

@implementation ParserWXH

+ (void) parseWithFile:(NSString*) fileName items:(NSMutableArray*) itemList/*OUT*/
{
    NSError* err = nil;
    NSString* pageData = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:&err];
    if (nil == err) {
        [ParserWXH parseWithContent:pageData items:itemList];
    } else {
        __Print(@"parseWithFile", err)
    }
}

+ (void) parseWithContent:(NSString*) content items:(NSMutableArray*) itemList/*OUT*/
{
    NSString* jsonData = [self findJsonBody:content];
    if (jsonData) {
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        id obj = [jsonParser objectWithString:jsonData];
        if ([obj isKindOfClass:[NSArray class]]) {
            ItemWXH* item = nil;
            NSArray* objArr = obj;
            for (id objSub in objArr) {
                if ([objSub isKindOfClass:[NSArray class]]) {
                    NSArray* objArrSub = objSub;
                    item = [[ItemWXH alloc] init];
                    for (id objSub1 in objArrSub) {
                        if ([objSub1 isKindOfClass:[NSString class]]) {
                            [item addText:objSub1];
                        }
                    }
                    if ([item isValid]) {
                        [itemList addObject:item];
                    }
                    [item release];
                }
            }
        }
        [jsonParser release];
    }
}

#pragma -- private method --
+ (NSString*) findJsonBody:(NSString*) content
{
    NSString* jsonData = nil;
    NSRange range = [content rangeOfString:@"[["];
    if (0 < range.location && 0 < range.length) {
        NSString* tmp = [content substringFromIndex:range.location];
        range = [tmp rangeOfString:@";"];
        if (0 < range.location && 0 < range.length) {
            jsonData = [tmp substringToIndex:range.location];
        }
    }
    return jsonData;
}

@end
