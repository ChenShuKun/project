//
//  MainLeftModel.m
//  Scratch
//
//  Created by ChenShuKun on 2020/1/4.
//  Copyright © 2020 ChenShuKun. All rights reserved.
//

#import "MainLeftModel.h"

@implementation MainLeftModel

+ (NSArray *)dataArray {
    
    return @[
        @{
            @"title":@"本地存储",
            @"leftIcon":@"mainView_leftIcon_local",
            @"rightIcon":@"mainView_leftIcon_right",
            @"isSelected":@1,
        },
        @{
            @"title":@"云端存储",
            @"leftIcon":@"mainView_leftIcon_cloud",
            @"rightIcon":@"mainView_leftIcon_right",
            @"isSelected":@0,
        },
        @{
            @"title":@"想知道",
            @"leftIcon":@"mainView_leftIcon_wantknow",
            @"rightIcon":@"mainView_leftIcon_right",
            @"isSelected":@0,
        },
        @{
            @"title":@"消息中心",
            @"leftIcon":@"mainView_leftIcon_message",
            @"rightIcon":@"mainView_leftIcon_right",
            @"isSelected":@0,
        },
    ];
}


+ (NSMutableArray *)getModelArray {
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *dict in [self  dataArray]) {
        
        MainLeftModel *model = [[MainLeftModel alloc]init];
        model.title = dict[@"title"];
        model.leftIconStr = dict[@"leftIcon"];
        model.rightIconStr = dict[@"rightIcon"];
        model.isSelected = [dict[@"isSelected"] integerValue];
        [array addObject:model];
    }
    return array;
}


@end
