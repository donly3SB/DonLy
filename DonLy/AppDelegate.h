//
//  AppDelegate.h
//  DonLy
//
//  Created by chen dianbo on 13-1-31.
//  Copyright (c) 2013年 chen dianbo. All rights reserved.
//

#import "common.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//Export
- (UIViewController*) viewById:(UIViewId) viewId;

- (void) switchBackView;
- (void) switchToView:(UIViewId) viewId;

@end
