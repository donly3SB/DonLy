//
//  PagePool.h
//  DonLy
//
//  Created by chen dianbo on 13-3-1.
//  Copyright (c) 2013年 chen dianbo. All rights reserved.
//

#import "common.h"

typedef enum {
    PT_WXH,
    PT_YY
} PageType;

@interface PagePool : NSObject

- (NSInteger) webPage:(PageType) type f:(NSString*) fileName;
- (NSInteger) webPage:(PageType) type c:(NSString*) content;

- (NSInteger) count:(PageType) type;
- (NSString*) pageByIndex:(PageType) type index:(NSInteger) index;

@end
