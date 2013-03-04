//
//  log.h
//  360Tools
//
//  Created by dianbo chen on 12-5-13.
//  Copyright aaa 2012年. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "common.h"

// logger function
#ifdef __ENABLE_LOG__

@interface Logger : NSObject

+ (void)initLog;
+ (void)LogString:(NSString*)logStr;
+ (void)LogChar:(const char*)chStr;


//For private methods
+ (FILE*) open:(bool)append;

@end

@interface TempMember :  NSObject 
@end

//--------------------------------------------------------------

#define __InitLogger            [Logger initLog];
#define __Logger(string)        [Logger LogString:string];
#define __LoggerC(charArr)      [Logger LogChar:charArr];
#define __LoggerFunc            [Logger LogString:[NSString stringWithFormat:@"%@: %@", NSStringFromSelector(_cmd), self]];
#define __LoggerTmp             [[[TempMember alloc] init] autorelease];
#define __Print(args...)        NSLog(args);
#define __PrintErr(desc, error) NSLog(@"%@: %@, err:%d", desc, [error domain], error.code);
#define __PrintFmt(args...)     NSLog([NSString stringWithFormat:args]);

#else

#define __InitLogger
#define __Logger(string)
#define __LoggerC(charArr)
#define __LoggerFunc
#define __LoggerTmp
#define __Print(args...)
#define __PrintErr(desc, error)
#define __PrintFmt(args...)

#endif


