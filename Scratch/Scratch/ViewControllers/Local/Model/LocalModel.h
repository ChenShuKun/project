//
//  LocalModel.h
//  LearnDemo
//
//  Created by alsrobot on 2020/1/6.
//  Copyright © 2020 Chenshukun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocalModel : NSObject

@property (nonatomic ,copy) NSString *iconUrl;
@property (nonatomic ,copy) NSString *titleStr;
@property (nonatomic ,copy) NSString *timeStr;



+ (NSMutableArray *)getLocalModelArray;

+ (NSMutableArray *)getLocalData ;


@property (nonatomic ,copy) NSString *localTitle;
@property (nonatomic ,copy) NSString *localContent;


@end

NS_ASSUME_NONNULL_END
