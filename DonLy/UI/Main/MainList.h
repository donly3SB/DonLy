//
//  MainList.h
//  360Tools
//
//  Created by chendianbo on 12-12-21.
//  Copyright (c) 2012年 aaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"
#import <UIKit/UITableView.h>

@interface UIMainListContainer : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UIView*     iView;
    NSArray*    iRecordList;
    UITableView* iListControl;
    
@private
    int _maxRecordCnt;
//    id<ListSwitchDelegate> _switchDelegate;
}
@property(nonatomic, assign) NSArray* iRecordList;
@property(nonatomic, readonly) BOOL iLargeModel;
//@property(nonatomic, assign) id<ListSwitchDelegate> switchDelegate;

//-(id) initWithRecord:(CCArray*) recordList view:(UIView*)masterView r:(CGRect)rect;

@end