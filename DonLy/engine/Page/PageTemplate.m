//
//  PageTemplate.m
//  DonLy
//
//  Created by chen dianbo on 13-3-1.
//  Copyright (c) 2013年 chen dianbo. All rights reserved.
//

#import "PageTemplate.h"
#import "TemplateWXH.h"
#import "ParserEngine.h"

@implementation PageTemplate

+ (NSString*) htmlWXH:(ItemWXH*) item
{
    NSString* html = kRsc_WXH_Head;
    html = [html stringByAppendingFormat:kRsc_WXH_Title, item.title];
    NSArray* textList = item.textList;
    for (NSString* txt in textList) {
        html = [html stringByAppendingFormat:kRsc_WXH_Content, txt];
    }
    textList = item.imgUrlList;
    for (NSString* txt in textList) {
        html = [html stringByAppendingFormat:kRsc_WXH_Image, txt];
    }
    html = [html stringByAppendingString:kRsc_WXH_End];
    return html;
}

@end
