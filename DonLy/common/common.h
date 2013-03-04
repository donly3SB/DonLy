//
//  common.h
//  360Tools
//
//  Created by dianbo chen on 12-5-13.
//  Copyright aaa 2012年. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "build.h"
#import "log.h"
#import <UIKit/UIKit.h>
#import <Foundation/NSArray.h>

typedef enum {
    EViewIdMain = 0x100,
    EViewIdImage = 0x101
} UIViewId;

#define ccUiColor(r,g,b,a) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:a]

//define navi title size and font size
#define KNaviTextFontSize   20
#define KNaviLabelWidth     100
#define KNaviLabelHeight    40