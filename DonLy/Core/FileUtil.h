//
//  FileUtil.h
//  PandaBaby
//
//  Created by chen dianbo on 13-1-22.
//
//

#import <Foundation/Foundation.h>

@interface FileUtil : NSObject

+ (NSString*) rootPath;
+ (NSString*) documentsPath;
+ (NSString*) subDocumentsPath:(NSString*) docDirName;
+ (NSString*) cachePath;
+ (NSString*) subCachePath:(NSString*) cacheDirName;
+ (NSString*) imagePathInCache:(NSString*) dirName name:(NSString*) imageName;
+ (BOOL) fileExisted:(NSString*) fileName;

+ (void) ensurePathExists:(NSString*) pathName;//Such as: "root/images/"

@end
