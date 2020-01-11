//
//  AlertView.m
//  LearnDemo
//
//  Created by alsrobot on 2020/1/6.
//  Copyright © 2020 Chenshukun. All rights reserved.
//

#import "AlertView.h"
#import "Masonry.h"

@interface AlertView()

@property (nonatomic ,weak) UILabel *titleLabel;
@property (nonatomic ,weak) UITextView *contentView;
@property (nonatomic ,weak) UIButton *cancelBtn;
@property (nonatomic ,weak) UIButton *updataBtn; //更新按钮

@property (nonatomic ,weak) UIView *bgView222;
@end

@implementation AlertView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    UIColor *mainColor = [UIColor mainColor];
    UIColor *color = [UIColor alertBorderColor];
    
    self.layer.borderWidth = 9;
    self.layer.borderColor = color.CGColor;
    
    
    CGFloat tops_ = 30;
    
    UIView *titleView = [[UIView alloc]init];
    titleView.tag = 300;
    titleView.backgroundColor = mainColor;
    [self addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(100);
    }];
    
    //标题
    UILabel *title = [[UILabel alloc]init];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:20];
    [titleView addSubview:title];
    self.titleLabel = title;
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView.mas_left).offset(tops_);
        make.right.equalTo(titleView.mas_right).offset(-tops_*2);
        make.top.bottom.equalTo(titleView);
    }];
    
    //取消 按钮
    UIButton *cacel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cacel setTitle:@"关闭" forState:UIControlStateNormal];
    //    [cacel setImage:[UIImage imageNamed:@"alertEditorCancle"] forState:UIControlStateNormal];
    [cacel addTarget:self action:@selector(cancelBtnActions:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:cacel];
    self.cancelBtn = cacel;
    [cacel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(40);
        make.centerY.equalTo(titleView);
        make.right.equalTo(titleView).offset(-30);
    }];
    
    
    //内容背景
    UIView *textViewBg = [[UIView alloc]init];
    textViewBg.backgroundColor = [UIColor whiteColor];
    [self addSubview:textViewBg];
    [textViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self);
        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(titleView.mas_bottom);
    }];
    
    //内容
    UITextView *textView = [[UITextView alloc]init];
    textView.backgroundColor = [UIColor clearColor];
    textView.font = [UIFont systemFontOfSize:20];
    textView.textColor = [UIColor blackColor];
    textView.editable= NO;
    [self addSubview:textView];
    self.contentView = textView;
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(tops_);
        make.right.equalTo(self.mas_right).offset(-tops_);
        make.top.equalTo(titleView.mas_bottom).offset(tops_);
        make.bottom.equalTo(self.mas_bottom).offset(-tops_);
    }];
    
    //更新 按钮
    UIButton *update = [UIButton buttonWithType:UIButtonTypeCustom];
    [update setTitle:@"立即更新" forState:UIControlStateNormal];
    update.titleLabel.font = [UIFont systemFontOfSize:16];
    [update setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [update setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    update.backgroundColor = [UIColor orangeColor];
    [update addTarget:self action:@selector(updateBtnActions:) forControlEvents:UIControlEventTouchUpInside];
    update.hidden = YES;
    [textViewBg addSubview:update];
    self.updataBtn = update;
    [update mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(36);
        make.centerX.equalTo(textViewBg);
        make.bottom.equalTo(textViewBg).offset(-20);
    }];
    self.updataBtn.layer.cornerRadius = 36 / 2;
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    //    UIView *views = (UIView *)[self viewWithTag:300];
    //    [views cornerRadius:16 corner:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    //
    
}

- (void)reSetTitle:(NSString *)title {
    self.titleLabel.text = title;
}
- (void)reSetContentText:(NSString *)text {
    self.contentView.text = text;
}


#pragma mark:-- acitons
- (void)cancelBtnActions:(UIButton *)btn {
    
    NSLog(@" 取消 按钮");
    [self alertDismiss];
    if (self.cancleBlock) {
        self.cancleBlock(btn);
    }
}

- (void)updateBtnActions:(UIButton *)btn {
    NSLog(@" 立即更新 按钮");
    [self alertDismiss];
    if (self.updateBlock) {
        self.updateBlock(btn);
    }
}

- (void)alertShow {
    
    if (self.bgView222 == nil) {
        
        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];

//        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        
        UIView *bgView11 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, window.frame.size.width, window.frame.size.height)];
        bgView11.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [window addSubview:bgView11];
        self.bgView222 = bgView11;
        
        
        [bgView11 addSubview:self];
        [bgView11 bringSubviewToFront:self];
        
        CGFloat left_x = 100;
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView11.mas_left).offset(left_x);
            make.right.equalTo(bgView11.mas_right).offset(-left_x);
            make.top.equalTo(bgView11.mas_top).offset(left_x*1.2);
            make.bottom.equalTo(bgView11.mas_bottom).offset(-left_x*1.5);
        }];
    }
    
}

- (void)alertDismiss {
    
    [self.bgView222 removeFromSuperview];
    self.bgView222 = nil;
    
    [self removeFromSuperview];
    
    
}



@end
