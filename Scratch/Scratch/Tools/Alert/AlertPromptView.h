//
//  AlertPromptView.h
//  LearnDemo
//
//  Created by alsrobot on 2020/1/6.
//  Copyright © 2020 Chenshukun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AlertPromptViewType) {
    AlertPromptViewType_DEFAULT = 0,
    
};

typedef void(^ALSAlertViewCancleBlock)(UIButton *cancleBtn);
typedef void(^ALSAlertViewConfirmBlock)(UIButton *confirmBtn);

@interface AlertPromptView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic ,copy) ALSAlertViewCancleBlock cancleBlock;
@property (nonatomic ,copy) ALSAlertViewConfirmBlock confirmDeleteBlock;
@property (nonatomic ,assign) AlertPromptViewType type;

- (void)reSetTitle:(NSString *)title;
- (void)alertShow;
- (void)alertDismiss;


@end

NS_ASSUME_NONNULL_END
