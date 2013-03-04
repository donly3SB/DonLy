//
//  PageNet.m
//  DonLy
//
//  Created by chen dianbo on 13-3-1.
//  Copyright (c) 2013年 chen dianbo. All rights reserved.
//

#import "PageNet.h"
#import "ASIHTTPRequest.h"

@interface PageNet()

- (ASIHTTPRequest*) requestWithAsync:(NSString*) urlStr;

@property(nonatomic, assign) NSOperationQueue* _netQueue;
@property(nonatomic, assign) ASIHTTPRequest* _request;
@end

@implementation PageNet
@synthesize _netQueue;
@synthesize _request;
@synthesize delegate;


#pragma ---- function methods ----
- (id) init
{
    if (self = [super init]) {
        _netQueue = [[NSOperationQueue alloc] init];
    }
    return  self;
}

- (void) dealloc
{
    if (_netQueue) {
        [_netQueue cancelAllOperations];
        [_netQueue release]; _netQueue = nil;
    }
    [super dealloc];
}

- (void) requestWXH:(NSString*) itemId
{
    
}

#pragma ---- network ----
- (ASIHTTPRequest*) requestWithAsync:(NSString*) urlStr
{
    if (nil == urlStr) return nil;
    
    __Print(urlStr)
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setDelegate:self];
    
    [_netQueue addOperation:request];
    
    return request;
}

#pragma ---- 

@end
