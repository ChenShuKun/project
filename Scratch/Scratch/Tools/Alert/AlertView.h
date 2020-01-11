//
//  AlertView.h
//  LearnDemo
//
//  Created by alsrobot on 2020/1/6.
//  Copyright © 2020 Chenshukun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AlertViewCancleBlock)(UIButton *cancleBtn);
typedef void(^AlertViewsUpdateBlock)(UIButton *updateBtn);

@interface AlertView : UIView

@property (nonatomic ,copy) AlertViewCancleBlock cancleBlock;
@property (nonatomic ,copy) AlertViewsUpdateBlock updateBlock;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)reSetTitle:(NSString *)title;
- (void)reSetContentText:(NSString *)text;
- (void)alertShow;
- (void)alertDismiss;

@end

NS_ASSUME_NONNULL_END
