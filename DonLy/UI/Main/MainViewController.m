//
//  MainViewController.m
//  360Tools
//
//  Created by chendianbo on 13-1-9.
//  Copyright (c) 2013年 chendianbo. All rights reserved.
//

#import "MainViewController.h"
#import "ToolCell.h"
#import "UserInfoCell.h"
#import "AppDelegate.h"
#import "UserInfoMgr.h"

#define KTextFieldPhone     100
#define KTextFieldEmail     101

@interface UIMainViewController (private)
{
}
- (void) createControls;
- (void) createNaviControls;
- (UITextField*) createTextField:(int) tag text:(NSString*) text holdTxt:(NSString*) holdTxt;

- (UITableViewCell *) toolCell:(UITableView *)tableView row:(int) row;
- (UITableViewCell *) userInfoCell:(UITableView *)tableView row:(int) row;

@end

@implementation UIMainViewController
@synthesize naviLabel = _naviLabel;
@synthesize tableList = _tableList;

- (void) createNaviControls
{
    _naviLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,KNaviLabelWidth,KNaviLabelWidth)];
    _naviLabel.backgroundColor = [UIColor clearColor];
    _naviLabel.font = [UIFont boldSystemFontOfSize:KNaviTextFontSize];
    _naviLabel.textColor = [UIColor blackColor];
//    _naviLabel.textAlignment = UITextAlignmentCenter;
    _naviLabel.text = @"360工具库";
    self.navigationItem.titleView = self.naviLabel;
}

- (void) createControls
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    _tableList = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    
    _tableList.delegate = self;
    _tableList.dataSource = self;
    _tableList.allowsSelection = YES;
    
    [self.view addSubview:_tableList];
}

- (void) dealloc
{
    [_tableList release];
    [_naviLabel release];
    [_userInfoMgr release];
    
    [super dealloc];
}

#pragma --------from super -----------
- (id) init
{
    if (self == [super init]) {
        _userInfoMgr = [[UserInfoMgr alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self createNaviControls];
    [self createControls];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma ---------dalegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;//Tools and user info
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) return 1;
    if (1 == section) return 1;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [self toolCell:tableView row:indexPath.row];
    }
    if (indexPath.section == 1) {
        return [self userInfoCell:tableView row:indexPath.row];
    }
    return nil;
}

#pragma for group
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (defaultCellHeight < 1.0f) {
        UITableViewCell*cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        defaultCellHeight = cell.frame.size.height;
    }
    if (indexPath.section == 1) return defaultCellHeight*2;
    return defaultCellHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) return @"工具";
    if (section == 1) return @"用户信息";
    return nil;
}

#pragma do action
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableList deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        if (0 == indexPath.row) {
            [app switchToView:EViewIdImage];
        }
    } else
    if (indexPath.section == 1) {
        if (0 == indexPath.row) {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"持有者信息"
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定",
                                                                    nil];
            [alertView show];
            [alertView autorelease];
        }
    }
}

#pragma -- private function
- (UITableViewCell *) toolCell:(UITableView *)tableView row:(int) row
{
    static NSString* cellId = @"toolCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell.
    cell.textLabel.text=@"设备统计";
    if (nil == _userInfoMgr.toolsTime || _userInfoMgr.toolsTime.length <= 0) {
        cell.detailTextLabel.text = @"从未统计";
    } else {
        cell.detailTextLabel.text = _userInfoMgr.toolsTime;
    }
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    cell.imageView.image = [UIImage imageNamed:@"OwnerShip.png"];
    
    return cell;
}

- (UITableViewCell *) userInfoCell:(UITableView *)tableView row:(int) row
{
    static NSString* cellId = @"userInfoCell";
    UIUserInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UIUserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [cell createControls];
    }
    
//    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;

//    NSString* phone = _userInfoMgr.userPhone;
//    NSString* email = _userInfoMgr.userEmail;
    [cell setUserInfo:_userInfoMgr.userPhone email:_userInfoMgr.userEmail];
    
    CGSize cellSize = CGSizeMake(_tableList.frame.size.width, defaultCellHeight*2);
    [cell layoutControls:cellSize];
    return cell;
}

- (UITextField*) createTextField:(int) tag text:(NSString*) text holdTxt:(NSString*) holdTxt
{
    UITextField* textField = [[UITextField alloc] initWithFrame:CGRectZero];
    
    textField.tag = tag;
    textField.backgroundColor = [UIColor clearColor];
    textField.borderStyle = UITextBorderStyleBezel;
    textField.textColor = [UIColor whiteColor];
//    textField.textAlignment = UITextAlignmentCenter;
    textField.text = text;
    textField.placeholder = holdTxt;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeUnlessEditing;
    
//    [textField setKeyboardType:UIKeyboardTypeNumberPad];
//    [textField setSecureTextEntry:YES];
    [textField autorelease];
    return textField;
}

- (void) willPresentAlertView:(UIAlertView *)alertView
{
    CGRect frame = alertView.frame;
    frame.origin.y -= 35;
    frame.size.height += 80;
    alertView.frame = frame;
    for ( UIView * view in alertView.subviews ) {
        if ( ![view isKindOfClass:[UILabel class]] ) {
            CGRect btnFrame = view.frame;
            if (1.0f < btnFrame.origin.y) {
                btnFrame.origin.y += 70;
                view.frame = btnFrame;
            }
        }
    }
    
    UITextField* phone = [self createTextField:KTextFieldPhone text:_userInfoMgr.userPhone holdTxt:@"您的手机号码"];
    phone.keyboardType = UIKeyboardTypeNumberPad;
    
    UITextField* email = [self createTextField:KTextFieldEmail text:_userInfoMgr.userEmail holdTxt:@"您的公司邮箱"];
    
    int gap = frame.size.width / 20;
    phone.frame = CGRectMake( gap, 40, frame.size.width - gap - gap, 30 );
    email.frame = CGRectMake( gap, 80, frame.size.width - gap - gap, 30 );

    [alertView addSubview:phone];
    [alertView addSubview:email];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex) {
        UITextField* textField = (UITextField*)[alertView viewWithTag:KTextFieldPhone];
        NSString* text = textField.text;
        if (text) {
            _userInfoMgr.userPhone = text;
        }
        textField = (UITextField*)[alertView viewWithTag:KTextFieldEmail];
        text = textField.text;
        if (text) {
            NSRange rang = [text rangeOfString:@"@360.cn"];
            if (text.length <= 0 || 0 == rang.location || (0 < rang.location && 0 < rang.length)) {
                _userInfoMgr.userEmail = text;
            } else {
                _userInfoMgr.userEmail = [NSString stringWithFormat:@"%@%@", text, @"@360.cn"];
            }
        }
        [_userInfoMgr save];
        [_tableList reloadData];
    }
}

- (void) refreshData
{
    [_userInfoMgr load];
    [_tableList reloadData];
}

@end
