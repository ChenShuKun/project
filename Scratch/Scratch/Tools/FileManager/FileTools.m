//
//  FileTools.m
//  ALSScratch3
//
//  Created by alsrobot on 2019/11/21.
//  Copyright © 2019 Chenshukun. All rights reserved.
//

#import "FileTools.h"

@implementation FileTools

+ (BOOL)isExistAtPath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:filePath];
    return isExist;
}
//创建
//eg : /Documents/SCRATCH/2/项目01
+ (BOOL)createFileWithPath:(NSString *)path {
    
    if ([self isExistAtPath:path]) {
        NSLog(@" 已经存在了 ");
        return YES;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL isSuccess = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    if (isSuccess) {
        NSLog(@" create success");
    } else {
        NSLog(@"create fail = %@",error.description);
    }
    return isSuccess;
}

//删除
//eg :/Documents/SCRATCH/2/项目01
+ (BOOL)deleteFilewthPath:(NSString *)path {
    
    if (![self isExistAtPath:path]) {
        NSLog(@" 路径 不存在 ");
        return NO;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL isSuccess = [fileManager removeItemAtPath:path error:&error];
    if (isSuccess) {
        NSLog(@"delete success");
    }else{
        NSLog(@"delete fail = %@",error.description);
    }
    return isSuccess;
}


//eg : /Documents/SCRATCH/2/项目01/file.txt
+ (BOOL)writeContent:(NSString *)content toFile:(NSString *)path {
    
//    if (![self isExistAtPath:path]) {
//        NSLog(@" 路径 不存在 ");
//        return NO;
//    }
    NSError *error ;
    BOOL isSuccess = [content writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (isSuccess) {
        NSLog(@"write success");
    } else {
        NSLog(@"write fail = %@",error.description);
    }
    return isSuccess;
}

//eg : /Documents/SCRATCH/2/项目01/file.txt
+ (NSString *)readFileContentWithPath:(NSString *)path {
    
//    if (![self isExistAtPath:path]) {
//        NSLog(@" 路径 不存在 ");
//        return @"";
//    }
    NSError *error ;
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"read error: %@",error.description);
        return @"";
    }
    NSLog(@"read success: %@",content);
    return content;
}


// 移动 
+ (BOOL)moveItemAtPathFrom:(NSString *)fromPath toPath:(NSString *)toPath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL isSuccess = [fileManager moveItemAtPath:fromPath toPath:toPath error:&error];
    if (error) {
        NSLog(@"error = %@",error.description);
    }
    return isSuccess;
}


// 写入临时文件
+ (BOOL)writeTempContent:(NSData *)decodeData withFileName:(NSString *)fileName {
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@",path,fileName];
    
    BOOL writeSucceed = [decodeData writeToFile:fullPath atomically:YES];
    return writeSucceed;
}

+ (NSString *)tempContentPathWithFileName:(NSString *)fileName {
 
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@",path,fileName];
    return fullPath;
}

+ (BOOL)removeTempContentWithFileName:(NSString *)fileName {
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@",path,fileName];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:fullPath]) {
        return NO;
    }
    NSError *error;
    BOOL delete = [manager removeItemAtPath:fullPath error:&error];
    if (delete == NO) {
        NSLog(@"error = %@",error.description);
    }
    return delete;
}
 
@end
