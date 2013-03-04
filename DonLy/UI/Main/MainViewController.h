//
//  ViewController.h
//  360Tools
//
//  Created by chendianbo on 13-1-9.
//  Copyright (c) 2013年 chendianbo. All rights reserved.
//

#import "common.h"
#import <UIKit/UITableView.h>

@class UserInfoMgr;
@interface UIMainViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
@private
    float defaultCellHeight;
    UserInfoMgr* _userInfoMgr;
}
@property (strong, nonatomic) UILabel* naviLabel;
@property (strong, nonatomic) UITableView* tableList;

- (void) refreshData;

@end
