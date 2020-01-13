//
//  CloudModel.m
//  Scratch
//
//  Created by ChenShuKun on 2020/1/7.
//  Copyright © 2020 ChenShuKun. All rights reserved.
//

#import "CloudModel.h"

@implementation CloudModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"kid":@"id",
             @"iconUrl":@"bq",
             @"titleStr":@"work_name"
             };
}

- (void)setEtime:(NSString *)etime {
    _etime = etime;
    
    
    NSDate * myDate = [NSDate dateWithTimeIntervalSince1970: [etime doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
    NSString *dateString = [formatter stringFromDate: myDate];
    self.timeStr = dateString;
}
 
- (void)asdfa {
    
}
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
