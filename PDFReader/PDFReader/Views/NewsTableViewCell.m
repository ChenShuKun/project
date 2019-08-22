//
//  NewsTableViewCell.m
//  PDFReader
//
//  Created by ChenShuKun on 2019/8/17.
//  Copyright © 2019 ChenShukun. All rights reserved.
//

#import "NewsTableViewCell.h"

@implementation NewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDict:(NSDictionary *)dict {
    _dict = dict;
    
    self.titleLable.text = dict[@"title"];
    self.contentLabel.text = dict[@"content"];
    self.sourceLabel.text = dict[@"source"];
    
    self.timeLabel.text = dict[@"time"];

    
    NSInteger count = [dict[@"careCount"] integerValue];
    if (count > 0) {
        self.careCountLabel.hidden = NO;
        self.careCountLabel.text = [NSString stringWithFormat:@"%@ 人关心",@(count)];
    }else {
        self.careCountLabel.hidden = YES;
    }
}

@end
