//
//  MessageTableViewCell.m
//  LearnDemo
//
//  Created by alsrobot on 2020/1/7.
//  Copyright © 2020 Chenshukun. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "MessageModel.h"

@interface MessageTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end
@implementation MessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(MessageModel *)model {
    _model = model;
 
    if (model.icon.length > 0) {
        self.iconImageView.image = [UIImage imageNamed:model.icon];
    }
    self.titleLabel.text = model.title;
    self.timeLabel.text = model.time;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
