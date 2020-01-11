//
//  KnowTableViewCell.h
//  LearnDemo
//
//  Created by alsrobot on 2020/1/6.
//  Copyright © 2020 Chenshukun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class WantKnowModel;
typedef void(^zanBtnBlock)(UIButton *button,WantKnowModel *model);

typedef void(^collectionBtnBlock)(UIButton *button,WantKnowModel *model);

@interface KnowTableViewCell : UITableViewCell

@property (nonatomic, strong )WantKnowModel *model;
@property (nonatomic, copy) zanBtnBlock zanBlock;
@property (nonatomic, copy) collectionBtnBlock collectionBlock;

@end

NS_ASSUME_NONNULL_END
