//
//  LocalCollectionViewCell.m
//  LearnDemo
//
//  Created by alsrobot on 2020/1/6.
//  Copyright © 2020 Chenshukun. All rights reserved.
//

#import "LocalCollectionViewCell.h"
#import "LocalModel.h"

@implementation LocalCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.borderColor = [UIColor lightTextColor].CGColor;
    self.layer.borderWidth = 2;
}

// 308 200
- (void)setLocalModel:(LocalModel *)localModel {
    _localModel = localModel;

//    self.iconImageView.image = [UIImage imageNamed:localModel.iconUrl];
    
    self.titleLabel.text = localModel.titleStr;
//    NSString *time = [FileManger getSaveTimeWithkey:localModel.titleStr];
    self.timeLabel.text = localModel.timeStr;
    
    if ([localModel.type integerValue] == 1) {
       
        self.timeLabel.hidden = YES;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.uploadButton.hidden = YES;
        self.deleteBtn.hidden = YES;
    }else {
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.uploadButton.hidden = NO;
        self.timeLabel.hidden = NO;
        self.deleteBtn.hidden = NO;
    }
}

- (IBAction)upLoadButtonActions:(UIButton *)sender {
    
    
    if (self.upLoadBlock) {
        self.upLoadBlock(sender,self.localModel);
    }
    
}
- (IBAction)deletButton:(UIButton *)sender {
    
    
    if (self.deleteBlock) {
        self.deleteBlock(sender, self.localModel);
    }
    
}



@end
