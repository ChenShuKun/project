//
//  NewsTableViewCell.h
//  PDFReader
//
//  Created by ChenShuKun on 2019/8/17.
//  Copyright © 2019 ChenShukun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsTableViewCell : UITableViewCell

@property (nonatomic ,copy) NSDictionary *dict;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

NS_ASSUME_NONNULL_END
