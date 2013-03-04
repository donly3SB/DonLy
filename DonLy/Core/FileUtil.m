//
//  FileUtil.m
//  PandaBaby
//
//  Created by chen dianbo on 13-1-22.
//
//

#import "FileUtil.h"

@implementation FileUtil


+ (NSString*) rootPath
{
    return NSHomeDirectory();
}

+ (NSString*) documentsPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

+ (NSString*) subDocumentsPath:(NSString*) docDirName
{
    return [[FileUtil documentsPath] stringByAppendingPathComponent:docDirName];
}

+ (NSString*) cachePath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"cache"];
}

+ (NSString*) subCachePath:(NSString*) cacheDirName
{
    return [[FileUtil cachePath] stringByAppendingPathComponent:cacheDirName];
}

+ (NSString*) imagePathInCache:(NSString*) dirName name:(NSString*) imageName
{
    return [FileUtil subCachePath:[NSString stringWithFormat:@"%@/images/%@", dirName, imageName]];
}

+ (BOOL) fileExisted:(NSString*) fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:fileName];
}

+ (void) ensurePathExists:(NSString*) pathName
{
//    NSString* path = [fullName stringByDeletingLastPathComponent];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:pathName withIntermediateDirectories:YES attributes:nil error:nil];
}

@end
