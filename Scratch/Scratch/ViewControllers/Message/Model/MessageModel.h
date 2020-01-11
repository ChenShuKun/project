//
//  MessageModel.h
//  LearnDemo
//
//  Created by alsrobot on 2020/1/7.
//  Copyright © 2020 Chenshukun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageModel : NSObject

@property (nonatomic ,copy) NSString *icon;
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *time;
@property (nonatomic ,copy) NSString *content;

+ (NSMutableArray *)getDataModel;

@end

NS_ASSUME_NONNULL_END
