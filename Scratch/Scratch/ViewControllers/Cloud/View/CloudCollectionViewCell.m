//
//  CloudCollectionViewCell.m
//  Scratch
//
//  Created by ChenShuKun on 2020/1/7.
//  Copyright © 2020 ChenShuKun. All rights reserved.
//

#import "CloudCollectionViewCell.h"
#import "CloudModel.h"

@interface CloudCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;


@end
@implementation CloudCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.borderColor = [UIColor lightTextColor].CGColor;
    self.layer.borderWidth = 2;
}


-(void)setModel:(CloudModel *)model {
    _model = model;
    //    self.iconImageView.image = [UIImage imageNamed:localModel.iconUrl];
    
    self.nameLabel.text = model.titleStr;
    
    self.timeLabel.text = model.timeStr;
    
}
- (IBAction)buttonActions:(UIButton *)sender {
    
    if (self.buttonActions) {
        self.buttonActions(sender,self.model);
    }
}

@end
