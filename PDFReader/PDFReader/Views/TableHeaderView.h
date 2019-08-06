//
//  TableHeaderView.h
//  PDFReader
//
//  Created by ChenShuKun on 2019/8/2.
//  Copyright © 2019 ChenShukun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TableHeaderViewBlock)(NSDictionary *dict,BOOL isLogIn);

@interface TableHeaderView : UIView

@property (nonatomic, copy) TableHeaderViewBlock block;
- (instancetype)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
