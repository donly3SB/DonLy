//
//  UserInfoMgr.h
//  360Tools
//
//  Created by chendianbo on 13-1-9.
//  Copyright (c) 2013年 chendianbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoMgr : NSObject
{
}
@property(nonatomic, copy) NSString* userEmail;
@property(nonatomic, copy) NSString* userPhone;
@property(nonatomic, copy) NSString* toolsTime;

- (NSString*) dataFilePath;

- (void) updateToolsTime;

- (void) load;
- (void) save;

@end
