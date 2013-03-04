//
//  RecordListCell.h
//  360Tools
//
//  Created by chendianbo on 12-12-21.
//  Copyright (c) 2012年 aaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"

#define KLabelTagOfTime      1
#define KLabelTagOfScores    2
#define KImageTagOfScores    3

@interface UIUserInfoCell : UITableViewCell
{
@private
    UILabel* _labelTel;
    UILabel* _labelMail;
    UILabel* _labelValueTel;
    UILabel* _labelValueMail;
}

- (void) createControls;
- (void) setUserInfo:(NSString*) tel email:(NSString*) email;
- (void) layoutControls:(CGSize) maxSize;

@end
