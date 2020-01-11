//
//  MainLeftTableViewCell.m
//  Scratch
//
//  Created by ChenShuKun on 2020/1/4.
//  Copyright © 2020 ChenShuKun. All rights reserved.
//

#import "MainLeftTableViewCell.h"
#import "MainLeftModel.h"
@interface MainLeftTableViewCell()
@property (nonatomic ,weak) UIImageView *backGroundViews;
@property (nonatomic ,weak) UIView *shuxianView;
@end
@implementation MainLeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, 9, 4, self.frame.size.height-18)];
    view.backgroundColor = [UIColor orangeColor];
    [self addSubview:view];
    self.shuxianView = view;
    
//    UIImageView *img = [[UIImageView alloc]init];
//    img.image = [UIImage imageNamed:@"mainView_left_selected"];
//    [self.contentView addSubview:img];
//    self.backGroundViews = img;
}


- (void)setModel:(MainLeftModel *)model {
    _model = model;
    
    self.nameLabel.text = model.title;
    UIImageView *right = (UIImageView *)[self.contentView viewWithTag:200];
    UIImageView *left = (UIImageView *)[self.contentView viewWithTag:100];
    right.image = [UIImage imageNamed:model.rightIconStr];
    left.image = [UIImage imageNamed:model.leftIconStr];
    
    if (model.isSelected == 1) {
    
        self.backgroundColor = [UIColor colorWithRed:57/255.0 green:75/255.0 blue:97/255.0 alpha:0.3];
        self.shuxianView.hidden = NO;
        right.hidden = NO   ;
    }else {
        self.backgroundColor = [UIColor clearColor];
        self.shuxianView.hidden = YES;
        right.hidden = YES;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
