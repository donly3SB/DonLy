//
//  ParserWXH.h
//  DonLy
//
//  Created by chen dianbo on 13-2-28.
//  Copyright (c) 2013年 chen dianbo. All rights reserved.
//

#import "common.h"

@interface ItemWXH : NSObject

@property(nonatomic, retain) NSString* itemId;
@property(nonatomic, retain) NSString* title;
@property(nonatomic, assign) NSMutableArray* textList;
@property(nonatomic, assign) NSMutableArray* imgUrlList;

- (bool) isValid;
- (void) addText:(NSString*) text;

@end

@interface ParserWXH : NSObject

+ (void) parseWithFile:(NSString*) fileName items:(NSMutableArray*) itemList/*OUT*/;
+ (void) parseWithContent:(NSString*) content items:(NSMutableArray*) itemList/*OUT*/;

@end
