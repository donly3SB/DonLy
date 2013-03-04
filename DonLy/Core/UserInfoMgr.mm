//
//  UserInfoMgr.m
//  360Tools
//
//  Created by chendianbo on 13-1-9.
//  Copyright (c) 2013年 chendianbo. All rights reserved.
//

#import "UserInfoMgr.h"
#include "StreamUtil.h"

#define KUserInfoDataFileName   @"userinfo.dat"

using namespace Tools_v1;

@interface UserInfoMgr()

- (void) initFile;

@end

@implementation UserInfoMgr
@synthesize userEmail = _userEmail;
@synthesize userPhone = _userPhone;
@synthesize toolsTime = _toolsTime;

//---------------------------------------------------------
- (id) init
{
    if (self = [super init]) {
        [self initFile];
        [self load];
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (NSString*) dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:KUserInfoDataFileName];
}

- (void) initFile
{
#if (0)
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // 传递 0 代表是找在Documents 目录下的文件。
    NSString *docDir = [dirPaths objectAtIndex:0];
    // DBNAME 是要查找的文件名字，文件全名
    NSString* filePath = [docDir stringByAppendingPathComponent:KUserInfoDataFileName];
#else
    NSString* filePath = [self dataFilePath];
#endif
    
    // 用这个方法来判断当前的文件是否存在，如果不存在，就创建一个文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    printf("%s\n", [filePath UTF8String]);
}

- (void) load
{
#if 0
    NSString* filePath = [self dataFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) return ;

    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    
    _userEmail = [dict objectForKey:@"email"];
    _userPhone = [dict objectForKey:@"phone"];
    _toolsTime = [dict objectForKey:@"time"];
    
    [dict release];
#else
    NSString* filePath = [self dataFilePath];
    StreamFileReader* reader = new StreamFileReader();
    int err = reader->open([filePath UTF8String]);
    if (0 == err) {
        //email
        char* strVal = reader->readString(nil);
        if (strVal) {
            self.userEmail = [NSString stringWithUTF8String:strVal];
            free(strVal);
        }
        
        //phone
        strVal = reader->readString(nil);
        if (strVal) {
            self.userPhone = [NSString stringWithUTF8String:strVal];
            free(strVal);
        }
        
        //last time
        strVal = reader->readString(nil);
        if (strVal) {
            self.toolsTime = [NSString stringWithUTF8String:strVal];
            free(strVal);
        }
        
        printf("StreamFileReader err:%d\n", reader->errCode());
        reader->close();
    }
    printf("Load user info err:%d\n", err);
    delete reader;
#endif
}

- (void) save
{
#if 0
    NSString* filePath = [self filePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithCapacity:4];
    
    if (_userEmail) [dict setObject:@"email" forKey:@"_userEmail"];
    if (_userPhone) [dict setObject:@"phone" forKey:@"_userPhone"];
    if (_toolsTime) [dict setObject:@"time"  forKey:_toolsTime];
    
    [dict writeToFile:filePath atomically:NO];
    [dict release];
#else
    NSString* filePath = [self dataFilePath];
    StreamFileWriter* writer = new StreamFileWriter();
    int err = writer->open([filePath UTF8String], 0);
    if (0 == err) {
        //email
        const char* strVal = [_userEmail UTF8String];
        writer->writeString(strVal, _userEmail.length);
        
        //phone
        strVal = [_userPhone UTF8String];
        writer->writeString(strVal, _userPhone.length);
        
        //last time
        strVal = [_toolsTime UTF8String];
        writer->writeString(strVal, _toolsTime.length);

        printf("StreamFileWriter err:%d\n", writer->errCode());
        
        writer->close();
    }
    printf("Save user info err:%d\n", err);
    delete writer;
#endif
}

- (void) updateToolsTime
{
    NSDate* now = [NSDate date];
    NSInteger unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|
    NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* comps = [calendar components:unitFlags fromDate:now];
    
    _toolsTime = [NSString stringWithFormat:@"%4d/%2d/%2d %.2d:%.2d:%.2d",
                                            [comps year],
                                            [comps month],
                                            [comps day],
                                            [comps hour],
                                            [comps minute],
                                            [comps second]
                                            ];
    
    [calendar release];
}

@end
