//
//  MainLeftModel.h
//  Scratch
//
//  Created by ChenShuKun on 2020/1/4.
//  Copyright © 2020 ChenShuKun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainLeftModel : NSObject

@property (nonatomic ,copy)NSString *leftIconStr;
@property (nonatomic ,copy)NSString *title;
@property (nonatomic ,copy)NSString *rightIconStr;

@property (nonatomic ,assign) NSInteger isSelected;

+ (NSMutableArray *)getModelArray;

@end

NS_ASSUME_NONNULL_END
