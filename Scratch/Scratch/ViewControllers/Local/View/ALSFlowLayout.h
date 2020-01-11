//
//  ALSFlowLayout.h
//  ALSScratch3
//
//  Created by alsrobot on 2019/10/10.
//  Copyright © 2019 Chenshukun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,AlignType){
    AlignWithLeft,
    AlignWithCenter,
    AlignWithRight
};

@interface ALSFlowLayout : UICollectionViewFlowLayout

//两个Cell之间的距离
@property (nonatomic,assign) CGFloat betweenOfCell;
//cell对齐方式
@property (nonatomic,assign) AlignType cellType;

-(instancetype)initWthType:(AlignType)cellType;
@end

NS_ASSUME_NONNULL_END
