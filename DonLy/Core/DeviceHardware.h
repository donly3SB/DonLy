//
//  DeviceHardware.h
//  360Tools
//
//  Created by chendianbo on 13-1-9.
//  Copyright (c) 2013年 chendianbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDeviceHardware : NSObject


- (NSString *) imei;
- (NSString *) serialnumber;
- (NSString *) backlightlevel;
- (NSString *) macaddress;

- (NSString *) platform;
- (NSString *) platformString;
- (NSString *) systemName;
- (NSString *) systemVersion;
- (NSString *) localWiFiIPAddress;

@end
