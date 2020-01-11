//
//  FileManger.h
//  ALSScratch3
//
//  Created by alsrobot on 2019/11/20.
//  Copyright © 2019 Chenshukun. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FileManger : BaseModel

@property (nonatomic, assign) NSInteger fileId;
@property (nonatomic, copy  ) NSString* fileName;
@property (nonatomic, copy  ) NSString* fileContent;

// YES 存在， NO 不存在
+ (BOOL)isExistAtFileName:(NSString *)fileName;
+ (NSArray *)getAllLocalFiles;


//增删改查
- (BOOL)fileManger_add;
- (BOOL)fileManger_remove;
+ (BOOL)fileManger_remove_FileName:(NSString *)fileName;
- (NSString *)fileManger_find;
+ (NSString *)fileManger_find_FileName:(NSString *)fileName;

- (BOOL)fileManger_updateContent;
// 修改 (名字)
+ (BOOL)fileManger_updateFileNameWithNewName:(NSString *)newNames andOldName:(NSString *)oldName;



//+ (NSString *)tempContentPathWithFileName:(NSString *)fileName;

// 写入临时文件
+ (BOOL)writeTempContent:(NSData *)decodeData;
+ (NSString *)tempContentPath;
+ (BOOL)removeTempContent;


//新 add
+ (BOOL)saveSaveTimekey:(NSString *)key;
+ (NSString *)getSaveTimeWithkey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
