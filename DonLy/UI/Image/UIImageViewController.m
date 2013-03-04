//
//  UIImageViewController.m
//  DonLy
//
//  Created by chen dianbo on 13-1-31.
//  Copyright (c) 2013年 chen dianbo. All rights reserved.
//

#import "UIImageViewController.h"
#import "AppDelegate.h"
#import "FileUtil.h"
#import "ParserEngine.h"

#define kImageDirName @"2013.01.31_19_04"

@interface UIImageViewController ()
@property(strong, nonatomic) UIButton*  backBtn;
@property(strong, nonatomic) UIWebView* webView;

- (void) initEnv;
- (void) createControls;

- (void) buttonClicked:(id) selector;

- (void) setImage:(NSString*) fullName;

@end

@implementation UIImageViewController
@synthesize backBtn;
@synthesize webView;

- (id) init
{
    if (self == [super init]) {
        self.view.backgroundColor = [UIColor grayColor];
        [self initEnv];
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) initEnv
{
    NSString* path = [FileUtil subCachePath:kImageDirName];
    [FileUtil ensurePathExists:path];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
    [self createControls];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createControls
{
    CGRect screenRc = [[UIScreen mainScreen] bounds];
    
    //back button
    backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake(10, 10, 80, 40);
    [backBtn setTitle:@"Back" forState:UIControlStateNormal];

    [backBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:backBtn];
    
    //image with web view
    screenRc = CGRectInset(screenRc, 0, abs(screenRc.size.width - screenRc.size.height)/2);
    webView = [[UIWebView alloc] initWithFrame:screenRc];
    webView.opaque = NO;
    webView.backgroundColor = [UIColor clearColor];
//    webView.scalesPageToFit = YES;
//    webView set
//    [webView setUserInteractionEnabled:NO];
    
    for (UIView *subView in [webView subviews]) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)subView).bounces = NO;//去掉UIWebView的底图
            [(UIScrollView *)subView setShowsHorizontalScrollIndicator:NO];//下侧的滚动条
            for (UIView *scrollview in subView.subviews) {
                if ([scrollview isKindOfClass:[UIImageView class]]) {
                    scrollview.hidden = YES;//上下滚动出边界时的黑色的图片
                }
            }
        }
    }
    
    [self.view addSubview:webView];
    [webView release];
    
    NSString* fileName = [FileUtil imagePathInCache:kImageDirName name:@"page.html"];
//    [self setLocalPage:fileName];

}

- (void) buttonClicked:(id) selector
{
    if (selector == backBtn) {
        AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [app switchBackView];
    }
}

- (void) setLocalPage:(NSString*) pageFileName
{
    if (![FileUtil fileExisted:pageFileName]) return;

    NSURL *htmlUrl = [NSURL fileURLWithPath:pageFileName];
    [webView loadRequest:[NSURLRequest requestWithURL:htmlUrl]];
}

- (void) setImage:(NSString*) fullName
{
    if (![FileUtil fileExisted:fullName]) return;
    
    NSString* ext = [[fullName pathExtension] lowercaseString];
    if (nil == ext) return ;

    NSString* mimeType = @"image/jpeg";
    if (NSOrderedSame == [ext compare:@"gif"]) {
        mimeType = @"image/gif";
    } else if (NSOrderedSame == [ext compare:@"bmp"]) {
        mimeType = @"image/bmp";
    }

    NSString* fmt = @"<html><body><h2>test</h2><center><img src=\".%@\"></center></body></html>";
    NSString* htmlData = [NSString stringWithFormat:fmt, fullName];
//    NSData* imgData = [NSData dataWithContentsOfFile:fullName];
    [webView loadHTMLString:htmlData baseURL:nil];
//    [webView loadData:imgData MIMEType:mimeType textEncodingName:nil baseURL:nil];
}

@end
