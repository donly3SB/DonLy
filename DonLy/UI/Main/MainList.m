//
//  RecordContainer.m
//  360Tools
//
//  Created by chendianbo on 12-12-21.
//  Copyright (c) 2012年 aaa. All rights reserved.
//

#import "MainList.h"
#import "UserInfoCell.h"
//#import "RecordDataMgr.h"
//#import "DrawUtil.h"

#define KEageOffsetX            10
#define KEageOffsetY            2

#pragma -------Function--------
@interface UIMainListContainer (private)

- (void) createList:(CGRect)rect;

- (void) initTouchEnv;
- (void) handleDoubleTapFrom;
- (void) handleSwipeTapFrom:(UISwipeGestureRecognizer *)recognizer;

- (UIImage*) createImage:(int) type;
- (void) createImageControl:(UITableViewCell*)cell t:(int)tag img:(UIImage*) image;
- (void) createLabel:(UITableViewCell*)cell a:(NSTextAlignment)align t:(int)tag f:(float)fontSize;
//- (void) setRecordData:(UITableViewCell*) cell d:(TRecordItem*) data;
- (void) layoutControls:(UIUserInfoCell*) cell s:(int)scores ps:(int)preScores ns:(int)nextScores;

- (void) refreshList;

@end

@implementation UIMainListContainer

@synthesize iRecordList;
@synthesize iLargeModel;
//@synthesize switchDelegate = _switchDelegate;

#pragma -------Function--------
//-(id) initWithRecord:(CCArray*) recordList view:(UIView*)masterView r:(CGRect)rect
//{
//    if (self = [super init]) {
//        iLargeModel = YES;
//        iView = masterView;
//        iRecordList = recordList;
//
//        [self createList:rect];
//        [self initTouchEnv];
//    }
//    return self;
//}

- (void) createList:(CGRect)rect
{
    if (nil == iListControl) {
        iListControl = [[UITableView alloc] initWithFrame:rect];
        iListControl.delegate = self;
        iListControl.dataSource = self;
        iListControl.opaque = YES;
        
        iListControl.backgroundColor = [UIColor blackColor];
        iListControl.separatorStyle = UITableViewCellSeparatorStyleNone;

        [self.view addSubview:iListControl];
        [iView addSubview:self.view];
    }
}

- (void) initTouchEnv
{
    //滑动
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeTapFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    [recognizer release];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeTapFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizer];
    [recognizer release];
    
    // 双击的 Recognizer
    UITapGestureRecognizer* doubleRecognizer =
            [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapFrom)];
    doubleRecognizer.numberOfTapsRequired = 2; // 双击
    [self.view addGestureRecognizer:doubleRecognizer];
}

- (void) dealloc
{
    if (iListControl) {
        [iListControl removeFromSuperview];
        [iListControl release]; iListControl = nil;
    }
    [super dealloc];
}

- (void) handleDoubleTapFrom
{
    iLargeModel = iLargeModel ? NO : YES;
//    if (_switchDelegate) {
//        [_switchDelegate handleDoubleTapEvent:iLargeModel];
//    }
    [self performSelector:@selector(refreshList) withObject:nil afterDelay:0.01];
}

- (void) handleSwipeTapFrom:(UISwipeGestureRecognizer *)recognizer
{
//    if (nil == _switchDelegate) return;
//    
//    BOOL reload = [_switchDelegate handleSwichTapEvent:recognizer.direction];
//    if (reload) {
//        [self performSelector:@selector(refreshList) withObject:nil afterDelay:0.01];
//    }
}

- (void) refreshList
{
    if (iListControl) {
        [iListControl reloadData];
    }
}

#pragma ---From dalegate---


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    CCLOG(@"Record count:%d", [iRecordList count]);
//    if (_maxRecordCnt <= 0) _maxRecordCnt = [iRecordList count];
//    return [iRecordList count];
    return 1;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return [DrawUtil listHeightByModel:iLargeModel];
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    const int index = indexPath.row;
    if (index < 0 || [iRecordList count] <= index) return nil;
//    TRecordItem* data = [iRecordList objectAtIndex:index];

    NSString* cellId = @"tblRecordCell";
    UIUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[UIUserInfoCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellId] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImage* image = [self createImage:0];
        [self createImageControl:cell t:KImageTagOfScores img:image];
        [self createLabel:cell a:NSTextAlignmentLeft t:KLabelTagOfTime f:12];
        [self createLabel:cell a:NSTextAlignmentRight t:KLabelTagOfScores f:14];
    } else {
        UIImageView* imageCtl = (UIImageView*)[cell viewWithTag:KImageTagOfScores];
        if (imageCtl) {
            imageCtl.image = [self createImage:0];
        }
    }
//    cell.iCurrType = data.type;
//    cell.iIsTotal = _maxRecordCnt == [iRecordList count];
//    [cell updateModel:iLargeModel];
    
    if (iLargeModel) {
//        [self setRecordData:cell d:data];
    }
    
    int preScores = 0;
    int nextScores = 0;
//    if (0 < index) {//if have the pre item
//        TRecordItem* preData = [iRecordList objectAtIndex:index-1];
//        preScores = preData.scores;
//    }
//    if (index + 1 < [iRecordList count]) {//if have next item
//        TRecordItem* nextData = [iRecordList objectAtIndex:index+1];
//        nextScores = nextData.scores;
//        cell.iNextType = nextData.type;
//    }
//    [self layoutControls:cell s:data.scores ps:preScores ns:nextScores];

    [cell setNeedsDisplay];
    return cell;
}

#pragma -------- For cell ----------
- (void) createLabel:(UITableViewCell*)cell a:(NSTextAlignment)align t:(int)tag f:(float)fontSize
{
    if (nil == cell) return ;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    
    label.tag = tag;
    label.textAlignment = align;
//    label.lineBreakMode = UILineBreakModeWordWrap;//auto \r\n
//    label.minimumScaleFactor = 14;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = [UIColor blackColor];
//    label.highlightedTextColor = [UIColor whiteColor];
//    label.numberOfLines = 0;
    label.opaque = YES; // 选中Opaque表示视图后面的任何内容都不应该绘制
    label.backgroundColor = [UIColor clearColor];
    
    [cell addSubview:label];
    [label release];
}

- (UIImage*) createImage:(int) type
{
    NSString* fileName = @"rd_number.png";
//    if (ERecordFollow == type) fileName = @"rd_follow.png";
//    else if (ERecordMatch == type) fileName = @"rd_match.png";
    
//    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"png"]];
    UIImage* image = [UIImage imageNamed:fileName];
    int w = 40;//[DrawUtil listScoreImageByModel:iLargeModel];

    CGRect thumbRect = CGRectMake(0, 0, w, w);
    UIGraphicsBeginImageContext(thumbRect.size);
    [image drawInRect:thumbRect];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (void) createImageControl:(UITableViewCell*)cell t:(int)tag img:(UIImage*) image
{
    if (nil == cell || nil == image) return ;
    
    UIImageView* imageCtl = [[UIImageView alloc] initWithImage:image];

    //Set
    imageCtl.tag = tag;
    imageCtl.opaque = YES;
    
    [cell addSubview:imageCtl];
    [imageCtl release];
}

//
//- (void) setRecordData:(UITableViewCell*) cell d:(TRecordItem*) data
//{
//    if (nil == cell || nil == data) return ;
//    UILabel* label = (UILabel*)[cell viewWithTag:KLabelTagOfTime];
//    if (label) {
//        label.text = [data FormatTime2String];
//        [label sizeToFit];
//    }
//    label = (UILabel*)[cell viewWithTag:KLabelTagOfScores];
//    if (label) {
//        label.text = [NSString stringWithFormat:@"%d", data.scores];
//        [label sizeToFit];
//    }
//}
//

- (void) layoutControls:(UIUserInfoCell*) cell s:(int)scores ps:(int)preScores ns:(int)nextScores
{
    if (nil == cell) return ;

    CGRect rect;// = CGRectMake(0, 0, iListControl.frame.size.width, [DrawUtil listHeightByModel:iLargeModel]);
    rect = CGRectInset(rect, KEageOffsetX, KEageOffsetY);
    
    UILabel* label = (UILabel*)[cell viewWithTag:KLabelTagOfTime];
    if (label && !label.hidden) {
        CGSize fitSize = label.frame.size;
        label.frame = CGRectMake(rect.origin.x, rect.origin.y + (rect.size.height - fitSize.height)/2,
                                 fitSize.width, fitSize.height
                                 );
    }

    UIImageView* imageCtl = (UIImageView*)[cell viewWithTag:KImageTagOfScores];
    if (imageCtl) {
        int x = rect.origin.x + rect.size.width * scores / 100;
        if (!iLargeModel) x -= rect.size.width / 3;

        imageCtl.center = CGPointMake(x, rect.origin.y + rect.size.height/2);
        CGSize imgSize = imageCtl.image.size;
        imageCtl.frame = CGRectMake(imageCtl.center.x - imgSize.width/2,
                                    imageCtl.center.y - imgSize.height/2,
                                    imgSize.width, imgSize.height
                                    );
        if (iLargeModel) {
            label = (UILabel*)[cell viewWithTag:KLabelTagOfScores];
            if (label && !label.hidden) {
                label.center = imageCtl.center;
            }
        }
    }
    
//    if (0 < preScores) {
//        int x = rect.origin.x + rect.size.width * preScores / 100;;
//        if (!iLargeModel) x -= rect.size.width / 3;
//        cell.iPrePosX = x;
//    } else {
//        cell.iPrePosX = 0;
//    }
//    if (0 < nextScores) {
//        int x = rect.origin.x + rect.size.width * nextScores / 100;;
//        if (!iLargeModel) x -= rect.size.width / 3;
//        cell.iNextPosX = x;
//    } else {
//        cell.iNextPosX = 0;
//    }
}

@end
