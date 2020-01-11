//
//  CloudCollectionViewCell.h
//  Scratch
//
//  Created by ChenShuKun on 2020/1/7.
//  Copyright © 2020 ChenShuKun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class CloudModel;

typedef void(^UpLoadBtnBlock)(UIButton *button,CloudModel *model);//上传按钮 block

@interface CloudCollectionViewCell : UICollectionViewCell

@property (nonatomic ,strong) CloudModel *model;

@property (nonatomic,copy) UpLoadBtnBlock buttonActions;

@end

NS_ASSUME_NONNULL_END
