//
//  LocalCollectionViewCell.h
//  LearnDemo
//
//  Created by alsrobot on 2020/1/6.
//  Copyright © 2020 Chenshukun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LocalModel;
typedef void(^UpLoadBtnBlock)(UIButton *button,LocalModel *model);//上传按钮 block
typedef void(^DeleteBtnBlock)(UIButton *button,LocalModel *model);//上传按钮 block

@interface LocalCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (nonatomic ,strong) LocalModel *localModel;

@property (nonatomic,copy) UpLoadBtnBlock upLoadBlock;
@property (nonatomic,copy) DeleteBtnBlock deleteBlock;
@end

NS_ASSUME_NONNULL_END
