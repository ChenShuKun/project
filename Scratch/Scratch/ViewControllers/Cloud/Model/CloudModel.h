//
//  CloudModel.h
//  Scratch
//
//  Created by ChenShuKun on 2020/1/7.
//  Copyright © 2020 ChenShuKun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CloudModel : NSObject

@property (nonatomic ,copy) NSString *iconUrl;
@property (nonatomic ,copy) NSString *titleStr;
@property (nonatomic ,copy) NSString *timeStr;



+ (NSMutableArray *)getCloudData ;


+ (NSMutableArray *)getModelArrayWithDict:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
