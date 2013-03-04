//
//  UIUserInfoCell.m
//  360Tools
//
//  Created by chendianbo on 12-12-21.
//  Copyright (c) 2012年 aaa. All rights reserved.
//

#import "UserInfoCell.h"

#define KLabelTitleFontHeight       18
#define KEditorFontHeight           16

@interface UIUserInfoCell (private)

- (UILabel*) createLabel:(NSString*) title a:(NSTextAlignment)align f:(UIFont*)font;

@end

@implementation UIUserInfoCell

#pragma -----------------------------------------------------------------
- (void) createControls
{
    if (_labelTel) return ;
    
    UIFont* font = [UIFont boldSystemFontOfSize:KLabelTitleFontHeight];
    _labelTel = [self createLabel:@"手机：" a:NSTextAlignmentLeft f:font];
    _labelTel.textColor = [UIColor blackColor];
    _labelMail = [self createLabel:@"邮箱：" a:NSTextAlignmentLeft f:font];
    _labelMail.textColor = [UIColor blackColor];

    font = [UIFont systemFontOfSize:KEditorFontHeight];
    _labelValueTel = [self createLabel:@"输入手机号码" a:NSTextAlignmentLeft f:font];
    _labelValueTel.textColor = [UIColor darkGrayColor];
    _labelValueMail = [self createLabel:@"输入邮箱地址" a:NSTextAlignmentLeft f:font];
    _labelValueMail.textColor = [UIColor darkGrayColor];
}

- (void) dealloc
{
    [_labelTel release];
    [_labelMail release];
    [_labelValueTel release];
    [_labelValueMail release];
    
    [super dealloc];
}

#pragma ----Private function----
- (UILabel*) createLabel:(NSString*) title a:(NSTextAlignment)align f:(UIFont*)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    
    label.textAlignment = align;
    label.text = title;
    //    label.lineBreakMode = UILineBreakModeWordWrap;//auto \r\n
    //    label.minimumScaleFactor = 14;
    label.font = font;
    label.textColor = [UIColor blackColor];
    //    label.highlightedTextColor = [UIColor whiteColor];
    //    label.numberOfLines = 0;
    label.opaque = YES; // 选中Opaque表示视图后面的任何内容都不应该绘制
    label.backgroundColor = [UIColor clearColor];
    
    [label sizeToFit];
    [self addSubview:label];
    return label;
}

- (void) setUserInfo:(NSString*) tel email:(NSString*) email
{
    if (nil == tel || tel.length <= 0) tel = @"输入手机号码";
    _labelValueTel.text = tel;
    [_labelValueTel sizeToFit];

    if (nil == email || email.length <= 0) email = @"输入邮箱地址";
    _labelValueMail.text = email;
    [_labelValueMail sizeToFit];
}

- (void) layoutControls:(CGSize) maxSize
{
    CGRect rect = CGRectMake(0, 0, maxSize.width, maxSize.height);
    rect = CGRectInset(rect, 10, 0);

    CGPoint pos = rect.origin;
    float labelW = _labelTel.frame.size.width;
    float labelH = _labelTel.frame.size.height;
    if (labelW < _labelMail.frame.size.width) labelW = _labelMail.frame.size.width;
    
    int h = (rect.size.height - labelH - labelH) / 3;
    
    pos.x += 10; pos.y += h;
    _labelTel.frame = CGRectMake(pos.x, pos.y, labelW, labelH);
    _labelMail.frame = CGRectMake(pos.x, pos.y + labelH + h, labelW, labelH);

    pos.x += labelW;
    labelW = _labelValueTel.frame.size.width;
    labelH = _labelValueTel.frame.size.height;
    if (labelW < _labelValueMail.frame.size.width) labelW = _labelValueMail.frame.size.width;
    
    h = (rect.size.height - labelH - labelH) / 3;
    pos.y = rect.origin.y + h;
    _labelValueTel.frame = CGRectMake(pos.x, pos.y, labelW, labelH);
    _labelValueMail.frame = CGRectMake(pos.x, pos.y + labelH + h, labelW, labelH);
}

@end
