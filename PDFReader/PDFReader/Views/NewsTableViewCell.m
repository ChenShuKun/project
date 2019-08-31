//
//  NewsTableViewCell.m
//  PDFReader
//
//  Created by ChenShuKun on 2019/8/17.
//  Copyright © 2019 ChenShukun. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "UIImageView+AFNetworking.h"
@implementation NewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
/*
 id = 10;
 img = "http://n.sinaimg.cn/book/275/w165h110/20190709/83e7-hzrevpz0734813.jpg";
 time = "7\U67089\U65e5 14:42";
 title = "\U7ed9\U5b69\U5b50\U7684\U8bd7\U300b\U51fa\U7248\U4e94\U5468\U5e74\U8bd7\U6b4c\U6717\U8bf5\U4f1a\Uff1a\U5317\U5c9b\U3001\U98df\U6307\U540c\U53f0\U9886\U8bf5";
 url = "http://book.sina.com.cn/news/whxw/2019-07-09/doc-ihytcitm0751186.shtml";
 */
-(void)setDict:(NSDictionary *)dict {
    _dict = dict;
    
    self.contentTextView.userInteractionEnabled = NO;
    
    NSURL *imgURL =  [NSURL URLWithString:dict[@"img"]];
    [self.image setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"books"]];
   
    self.contentTextView.text = dict[@"title"];
    self.timeLabel.text = dict[@"time"];
}

@end
