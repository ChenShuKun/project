//
//  MessageModel.m
//  LearnDemo
//
//  Created by alsrobot on 2020/1/7.
//  Copyright © 2020 Chenshukun. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel


+ (NSArray *)data {
    return @[
             @{@"icon":@"",@"title":@"V1.0.0上线啦",@"time":@"2019-07-12 10:24:18",@"content":@"新版本上线啦"},
            
             @{@"icon":@"",@"title":@"修复了bug",@"time":@"2019-07-12 20:34:18",@"content":@"修改了bug"},
             ];
}

/*
 https://v-cdn.zjol.com.cn/276992.mp4
 https://v-cdn.zjol.com.cn/276993.mp4
 https://v-cdn.zjol.com.cn/276994.mp4
 */

+ (NSMutableArray *)getDataModel {
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in [self data]) {
        
        MessageModel *mode = [[MessageModel alloc]init];
        mode.icon = dic[@"icon"];
        mode.title = dic[@"title"];
        mode.time = dic[@"time"];
        mode.content = dic[@"content"];
        [array addObject:mode];
    }
    return array;
}

@end
