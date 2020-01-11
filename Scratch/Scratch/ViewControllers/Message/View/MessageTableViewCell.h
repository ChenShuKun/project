//
//  MessageTableViewCell.h
//  LearnDemo
//
//  Created by alsrobot on 2020/1/7.
//  Copyright © 2020 Chenshukun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MessageModel;

@interface MessageTableViewCell : UITableViewCell

@property (nonatomic ,strong) MessageModel *model;



@end

NS_ASSUME_NONNULL_END
