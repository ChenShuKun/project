//
//  WantKnowModel.m
//  LearnDemo
//
//  Created by alsrobot on 2020/1/6.
//  Copyright © 2020 Chenshukun. All rights reserved.
//

#import "WantKnowModel.h"

@implementation WantKnowModel

+ (NSArray *)data {
    return @[
        @{@"icon":@"local_defalut.png",@"title":@"我是标题啊",@"content":@"我是呢哦让拉开发了多少放假啊时代峰峻",@"time":@"2018-01-12 09:19:22",@"isZan":@1,@"isCollect":@0,@"playUrl":@"https://v-cdn.zjol.com.cn/280443.mp4"},
        @{@"icon":@"local_defalut.png",@"title":@"我是标题222",@"content":@"我是 暗示法拉水电费; 看阿斯顿发地方",@"time":@"2018-01-12 09:19:22",@"isZan":@0,@"isCollect":@0,@"playUrl":@"https://v-cdn.zjol.com.cn/276990.mp4"},
        
        @{@"icon":@"local_defalut.png",@"title":@"我是标题33",@"content":@"我是 暗示法拉水电费; 看阿斯顿发地方",@"time":@"2018-01-12 09:19:22",@"isZan":@1,@"isCollect":@1,@"playUrl":@"https://v-cdn.zjol.com.cn/276991.mp4"},
             ];
}


/*
https://v-cdn.zjol.com.cn/276992.mp4
https://v-cdn.zjol.com.cn/276993.mp4
https://v-cdn.zjol.com.cn/276994.mp4
*/

+ (NSMutableArray *)getDataModel {
    
    NSArray *data = [self data];
    if (data.count <= 0) {
        return @[].mutableCopy;
    }
    NSMutableArray *array = [WantKnowModel mj_objectArrayWithKeyValuesArray:data];
    return array;
}


@end
