//
//  CloudModel.m
//  Scratch
//
//  Created by ChenShuKun on 2020/1/7.
//  Copyright © 2020 ChenShuKun. All rights reserved.
//

#import "CloudModel.h"

@implementation CloudModel
+ (NSArray *)data {
    return @[
             @{@"iconUrl":@"",@"titleStr":@"云端作品01",@"timeStr":@"2018-12-21"},
             @{@"iconUrl":@"",@"titleStr":@"云端作品02",@"timeStr":@"2018-05-21"},
             @{@"iconUrl":@"",@"titleStr":@"云端作品03",@"timeStr":@"2018-04-21"},
  ];
    
}

+ (NSMutableArray *)getCloudData {
    
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in [self data]) {
        
        CloudModel *model = [[CloudModel alloc]init];
        model.iconUrl = dict[@""];
        model.titleStr = dict[@"titleStr"];
        model.timeStr = dict[@"timeStr"];
        [array addObject:model];
    }
    return array;
}

+ (NSMutableArray *)getModelArrayWithDict:(NSDictionary *)data {
    
    if (![data isKindOfClass:[NSDictionary class]]) {
        return @[].mutableCopy;
    }
    if (![data[kdata] isKindOfClass:[NSArray class]]) {
        return @[].mutableCopy;
    }
    // JSON array -> User array
    NSMutableArray *array = [CloudModel mj_objectArrayWithKeyValuesArray:data[kdata]];
    return array;
}
@end
