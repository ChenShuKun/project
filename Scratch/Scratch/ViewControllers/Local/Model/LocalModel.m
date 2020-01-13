//
//  LocalModel.m
//  LearnDemo
//
//  Created by alsrobot on 2020/1/6.
//  Copyright © 2020 Chenshukun. All rights reserved.
//

#import "LocalModel.h"

@implementation LocalModel


+ (NSMutableArray *)getLocalModelArray {
    
    NSMutableArray *data = [NSMutableArray array];
    NSArray *localArr = [FileManger getAllLocalFiles];
    if (localArr) {
        for (NSString *name in localArr) {
            
            LocalModel *model = [[LocalModel alloc]init];
            model.titleStr = name;
            model.timeStr = @"";
            model.iconUrl = @"";
            [data addObject:model];
        }
    }
    [data insertObject:[self creatModle] atIndex:0];
    return data;
}


+ (LocalModel *)creatModle {
    LocalModel *local = [[LocalModel alloc]init];
    local.iconUrl = @"";
    local.titleStr = @"本地作品";
    local.type = @"1";
    return local;
}

+ (NSArray *)data {
    return @[
             @{@"iconUrl":@"",@"titleStr":@"本地作品01",@"timeStr":@"2019-12-21 12:11:43"},
             @{@"iconUrl":@"",@"titleStr":@"本地作品02",@"timeStr":@"2019-05-21 12:14:43"},
             @{@"iconUrl":@"",@"titleStr":@"本地作品03",@"timeStr":@"2019-04-21 12:08:03"},
             @{@"iconUrl":@"",@"titleStr":@"本地作品04",@"timeStr":@"2019-12-21 12:08:03"},
             @{@"iconUrl":@"",@"titleStr":@"本地作品05",@"timeStr":@"2019-05-21 12:08:03"},
             
             
             @{@"iconUrl":@"",@"titleStr":@"本地作品04",@"timeStr":@"2019-12-21 12:08:03"},
             @{@"iconUrl":@"",@"titleStr":@"本地作品05",@"timeStr":@"2019-05-21 12:08:03"},
             @{@"iconUrl":@"",@"titleStr":@"本地作品04",@"timeStr":@"2019-12-21 12:08:03"},
             @{@"iconUrl":@"",@"titleStr":@"本地作品05",@"timeStr":@"2019-05-21 12:08:03"},
             @{@"iconUrl":@"",@"titleStr":@"本地作品04",@"timeStr":@"2019-12-21 12:08:03"},
             @{@"iconUrl":@"",@"titleStr":@"本地作品05",@"timeStr":@"2019-05-21 12:08:03"},
             @{@"iconUrl":@"",@"titleStr":@"本地作品04",@"timeStr":@"2019-12-21 12:08:03"},
             @{@"iconUrl":@"",@"titleStr":@"本地作品05",@"timeStr":@"2019-05-21 12:08:03"},
  ];
    
}

+ (NSMutableArray *)getLocalData  {
    
    NSArray *data = [self data];
    NSMutableArray *array = [LocalModel mj_objectArrayWithKeyValuesArray:data];
    [array insertObject:[self creatModle] atIndex:0];
    return array;
}


@end
