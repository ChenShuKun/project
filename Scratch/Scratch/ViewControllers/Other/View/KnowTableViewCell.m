//
//  KnowTableViewCell.m
//  LearnDemo
//
//  Created by alsrobot on 2020/1/6.
//  Copyright © 2020 Chenshukun. All rights reserved.
//

#import "KnowTableViewCell.h"
#import "WantKnowModel.h"


@interface KnowTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *zanButton;
@property (weak, nonatomic) IBOutlet UIButton *collecteionButton;


@end
@implementation KnowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.zanButton setImage:[UIImage imageNamed:@"wantKnow_zan_normal"] forState:UIControlStateNormal];
    [self.zanButton setImage:[UIImage imageNamed:@"wantKnow_zan_slected"] forState:UIControlStateSelected];
    [self.collecteionButton setImage:[UIImage imageNamed:@"wantKnow_collection_normal"] forState:UIControlStateNormal];
     [self.collecteionButton setImage:[UIImage imageNamed:@"wantKnow_collection_slected"] forState:UIControlStateSelected];
     
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WantKnowModel *)model {
    _model = model;
    
    if (model.icon.length > 0) {
        self.coverImageView.image = [UIImage imageNamed:model.icon];
    }
    
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    self.timeLabel.text = model.time;
    
    
    if (model.isZan == 0) {
        self.zanButton.selected = NO;
    }else {
        self.zanButton.selected = YES;
    }
    
    if (model.isCollect == 0) {
        self.collecteionButton.selected = NO;
    }else {
        self.collecteionButton.selected = YES;
    }
}

- (IBAction)zanButtonActions:(UIButton *)sender {
    NSLog(@"赞 button");
    if (self.zanBlock) {
        self.zanBlock(sender, self.model);
    }
}
- (IBAction)collectionButton:(UIButton *)sender {
    
    NSLog(@"收藏 button");
    if (self.collectionBlock) {
        self.collectionBlock(sender, self.model);
    }
}



@end
