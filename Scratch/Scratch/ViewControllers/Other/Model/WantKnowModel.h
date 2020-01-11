//
//  WantKnowModel.h
//  LearnDemo
//
//  Created by alsrobot on 2020/1/6.
//  Copyright © 2020 Chenshukun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WantKnowModel : NSObject

@property (nonatomic ,copy) NSString *icon;
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *content;
@property (nonatomic ,copy) NSString *time;
@property (nonatomic ,assign) NSInteger isZan; //是否赞过
@property (nonatomic ,assign) NSInteger isCollect; //是否收藏过
@property (nonatomic ,copy) NSString *playUrl;

+ (NSMutableArray *)getDataModel;

@end

NS_ASSUME_NONNULL_END
