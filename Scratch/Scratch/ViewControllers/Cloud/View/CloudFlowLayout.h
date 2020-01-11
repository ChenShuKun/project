//
//  CloudFlowLayout.h
//  Scratch
//
//  Created by ChenShuKun on 2020/1/7.
//  Copyright © 2020 ChenShuKun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,AlignType){
    AlignWithLeft,
    AlignWithCenter,
    AlignWithRight
};
@interface CloudFlowLayout : UICollectionViewFlowLayout



//两个Cell之间的距离
@property (nonatomic,assign) CGFloat betweenOfCell;
//cell对齐方式
@property (nonatomic,assign) AlignType cellType;

-(instancetype)initWthType:(AlignType)cellType;

@end

NS_ASSUME_NONNULL_END
