//
//  MainLeftTableViewCell.h
//  Scratch
//
//  Created by ChenShuKun on 2020/1/4.
//  Copyright © 2020 ChenShuKun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MainLeftModel;
@interface MainLeftTableViewCell : UITableViewCell

@property (nonatomic ,strong) MainLeftModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *leftIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightIcon;

@end

NS_ASSUME_NONNULL_END
