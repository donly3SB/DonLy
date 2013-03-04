//
//  log.m
//  360Tools
//
//  Created by dianbo chen on 12-5-13.
//  Copyright aaa 2012年. All rights reserved.
//


// Import the interfaces
#import "log.h"

#ifdef __ENABLE_LOG__
// Logger implementation
@implementation Logger


+ (void)initLog
{
    //Do clear content
    FILE* file = [self open:false];
    if (file) {
        fclose(file);
    }
}

+ (FILE*) open:(bool)append
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *tmpFolder = [paths objectAtIndex:0];
    NSString *filename =@"logger.txt";
    NSString *filePath = [tmpFolder stringByAppendingPathComponent:filename];
    if (append) {
        return fopen([filePath UTF8String], "ap");
    }
    return fopen([filePath UTF8String], "wb");
}

+ (void)LogString:(NSString*)logStr
{
    const char* data = [logStr UTF8String];
    [self LogChar:data];
}

+ (void)LogChar:(const char*)chStr
{
    FILE* file = [self open:true];
    if (file) {
        const int dataLen = strlen(chStr);
        fwrite(chStr, 1, dataLen, file);
        fwrite("\r\n", 1, 2, file);
        fclose(file);
    }
}

@end

// TempMember implementation
@implementation TempMember

- (id) init
{
    if (self = [super init]) {
        __LoggerC("{")
    }
    return self;
}

- (void) dealloc
{
    __LoggerC("}")
	[super dealloc];
}

@end
#endif
