//
//  FileManger.m
//  ALSScratch3
//
//  Created by alsrobot on 2019/11/20.
//  Copyright © 2019 Chenshukun. All rights reserved.
//

#import "FileManger.h"
#import "FileTools.h"

@implementation FileManger

//增加
- (BOOL)fileManger_add {

    if (![FileTools isExistAtPath:self.fileName]) {
        NSString *path = [FileManger filePathWithFileName:self.fileName];
        [FileTools createFileWithPath:path];
    }
    NSString *filePath = [FileManger fullPathWithFileName:self.fileName];
    return [FileTools writeContent:self.fileContent toFile:filePath];
}

//删除
- (BOOL)fileManger_remove {
    
    return [FileManger fileManger_remove_FileName:self.fileName];
}

+ (BOOL)fileManger_remove_FileName:(NSString *)fileName {
    
    NSString *path = [FileManger filePathWithFileName:fileName];
    return [FileTools deleteFilewthPath:path];

}
// 修改 (内容)
- (BOOL)fileManger_updateContent {
 
    NSString *filePath = [FileManger fullPathWithFileName:self.fileName];
    return [FileTools writeContent:self.fileContent toFile:filePath];
    
}

// 修改 (名字)
+ (BOOL)fileManger_updateFileNameWithNewName:(NSString *)newNames andOldName:(NSString *)oldName {
   
    if (![FileTools isExistAtPath:newNames]) {
        
        NSString *path = [FileManger filePathWithFileName:newNames];
        [FileTools createFileWithPath:path];
        
        NSString *oldPath = [FileManger fullPathWithFileName:oldName];
        NSString *newPath = [FileManger fullPathWithFileName:newNames];

        BOOL isSuccess = [FileTools moveItemAtPathFrom:oldPath toPath:newPath];
        if (isSuccess) {
            NSString *oldPath = [FileManger filePathWithFileName:oldName];
            [FileTools deleteFilewthPath:oldPath];
        }
        return isSuccess;
    }
    
    return NO;
}


//查找
- (NSString *)fileManger_find {
    return [FileManger fileManger_find_FileName:self.fileName];
}

+ (NSString *)fileManger_find_FileName:(NSString *)fileName {
    
    NSString *filePath = [FileManger fullPathWithFileName:fileName];
    return [FileTools readFileContentWithPath:filePath];
}

#pragma mark:-- 公共方法
+ (BOOL)isExistAtFileName:(NSString *)fileName {
    NSString *filePath = [self fullPathWithFileName:fileName];
    return [FileTools isExistAtPath:filePath];
}

+ (NSArray *)getAllLocalFiles {
    
    NSString *path  = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *userPath = [NSString stringWithFormat:@"%@/SCRATCH/%@",path,[self getUserId]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *tempArray = [fileManager contentsOfDirectoryAtPath:userPath error:nil];
    return tempArray;
}

+ (NSString *)getUserId {
    return @"0";//[UserManager userInfo].userid;
}

+ (BOOL)createFileWithFilePath:(NSString *)filePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isSuccess = [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    if (isSuccess) {
        NSLog(@"create success");
    } else {
        NSLog(@" create fail");
    }
    return isSuccess;
}


//测试数据
+ (NSString *)fullPathWithFileName:(NSString *)fileName {
    
    NSString *documentsPath = [self filePathWithFileName:fileName];
    NSString *fullPath = [documentsPath stringByAppendingPathComponent:@"file.txt"];
//    NSString *fullPath = [documentsPath stringByAppendingPathComponent:@"file.sb3"];
    return fullPath;
}

+ (NSString *)filePathWithFileName:(NSString *)fileName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath =  [NSString stringWithFormat:@"%@/SCRATCH/%@/%@",path,[self getUserId],fileName];
    return filePath;
}

+ (NSString *)tempContentPathWithFileName:(NSString *)fileName {
    NSString *filePath = [FileManger fullPathWithFileName:fileName];
    return filePath;
}



// 写入临时文件
+ (BOOL)writeTempContent:(NSData *)decodeData {
    if (decodeData.length <= 0) {
        decodeData = [NSData data];
    }
    return [FileTools writeTempContent:decodeData withFileName:@"temp.sb3"];
}

+ (NSString *)tempContentPath {
    return [FileTools tempContentPathWithFileName:@"temp.sb3"];
}


+ (BOOL)removeTempContent {
    return [FileTools removeTempContentWithFileName:@"temp.sb3"];
}

//新 add
+ (BOOL)saveSaveTimekey:(NSString *)key {
    
    NSString *time = [self getCurrentTimes];
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:key];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getSaveTimeWithkey:(NSString *)key {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}


+ (NSString*)getCurrentTimes {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString =  %@",currentTimeString);
    return currentTimeString;
}

@end
