//
//  PageNet.h
//  DonLy
//
//  Created by chen dianbo on 13-3-1.
//  Copyright (c) 2013年 chen dianbo. All rights reserved.
//

#import "common.h"
#import "ASIHTTPRequestDelegate.h"

@protocol PageNetDelegate;
@interface PageNet : NSObject<ASIHTTPRequestDelegate>
{
    
}
@property(nonatomic, assign) id<PageNetDelegate> delegate;


- (void) requestWXH:(NSString*) itemId;

@end

@protocol PageNetDelegate <NSObject>

- (void) handlePageNetEvent;

@end
