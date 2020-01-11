//
//  FileTools.h
//  ALSScratch3
//
//  Created by alsrobot on 2019/11/21.
//  Copyright © 2019 Chenshukun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileTools : NSObject

+ (BOOL)isExistAtPath:(NSString *)filePath;


//eg : /Documents/SCRATCH/2/项目01
+ (BOOL)createFileWithPath:(NSString *)path;
//eg :/Documents/SCRATCH/2/项目01
+ (BOOL)deleteFilewthPath:(NSString *)path;

//eg : /Documents/SCRATCH/2/项目01/file.txt
+ (BOOL)writeContent:(NSString *)content toFile:(NSString *)path;
//eg :/Documents/SCRATCH/2/项目01/file.txt
+ (NSString *)readFileContentWithPath:(NSString *)path;
// 移动
+ (BOOL)moveItemAtPathFrom:(NSString *)fromPath toPath:(NSString *)toPath;


//// 写入临时文件
+ (BOOL)writeTempContent:(NSData *)decodeData withFileName:(NSString *)fileName;
+ (NSString *)tempContentPathWithFileName:(NSString *)fileName;
+ (BOOL)removeTempContentWithFileName:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
