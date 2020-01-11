//
//  AlertPromptView.m
//  LearnDemo
//
//  Created by alsrobot on 2020/1/6.
//  Copyright © 2020 Chenshukun. All rights reserved.
//

#import "AlertPromptView.h"
#import "Masonry.h"

@interface AlertPromptView()

@property (nonatomic ,weak) UIImageView *iconImageView;
@property (nonatomic ,weak) UILabel *titleLabel;
@property (nonatomic ,weak) UITextField *contentTF;
@property (nonatomic ,weak) UIButton *cancelBtn;
@property (nonatomic ,weak) UIButton *confirmBtn;

@property (nonatomic ,weak) UIView *bgView222;

@end
@implementation AlertPromptView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    self.layer.borderWidth = 9;
    self.layer.borderColor = [UIColor alertBorderColor].CGColor;

    
    UIImageView *bg = [[UIImageView alloc]init];
//    bg.image = [UIImage imageNamed:@"alertBackground"];
    bg.backgroundColor = [UIColor mainColor];
    [self addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    CGFloat tops_ = 40;
    /*
    UIImageView *icon = [[UIImageView alloc]init];
    icon.image = [UIImage imageNamed:@"alertLogo"];
    [self addSubview:icon];
    //271 × 179
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(tops_/2);
        make.width.mas_equalTo(108);
        make.height.mas_equalTo(71.6);
        make.centerY.equalTo(self);
    }];
    */
    //标题
    UILabel *title = [[UILabel alloc]init];
    title.textColor = [UIColor whiteColor];
    title.numberOfLines = 0;
    title.font = [UIFont systemFontOfSize: 20];
    [self addSubview:title];
    self.titleLabel = title;
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bg.mas_left).offset(20);
        make.right.equalTo(bg.mas_right).offset(-20);
        make.height.mas_greaterThanOrEqualTo(21);
        make.top.mas_equalTo(bg.mas_top).offset(40);
//        make.centerY.equalTo(self);
    }];
    
    //取消 图片 icon
    UIButton *cancleIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleIcon setBackgroundImage:[UIImage imageNamed:@"alertDelete"] forState:UIControlStateNormal];
    [cancleIcon addTarget:self action:@selector(cancelBtnActions:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancleIcon];
    [cancleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(tops_);
        make.top.equalTo(self.mas_top).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
    }];
    
    //确认按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize: 16];
//    [button setBackgroundImage:[UIImage imageNamed:@"icon_buttonBg_normal"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor alertBorderColor];
    [button addTarget:self action:@selector(confirmBtnActions:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    self.confirmBtn = button;
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(tops_);
        make.width.mas_equalTo(tops_*3);
        make.bottom.equalTo(self.mas_bottom).offset(-tops_/2);
        make.right.equalTo(self.mas_right).offset(-tops_);
    }];
    
    //取消按钮
    UIButton *cancle = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancle setTitle:@"取消" forState:UIControlStateNormal];
    cancle.titleLabel.font =[UIFont systemFontOfSize: 16];
    //    [cancle setBackgroundImage:[UIImage imageNamed:@"icon_buttonBg_disEnable"] forState:UIControlStateNormal];
    [cancle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancle.backgroundColor = [UIColor alertBorderColor];
    [cancle addTarget:self action:@selector(cancelBtnActions:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancle];
    self.cancelBtn = cancle;
    [cancle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(tops_);
        make.width.mas_equalTo(tops_*3);
        make.bottom.equalTo(button.mas_bottom);
        make.right.equalTo(button.mas_left).offset(-20);
    }];
    

   
    
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.confirmBtn.layer.cornerRadius = self.confirmBtn.frame.size.height /2;
    self.cancelBtn.layer.cornerRadius = self.cancelBtn.frame.size.height /2;
    
}

- (void)reSetTitle:(NSString *)title {
    self.titleLabel.text = title;
}


- (void)setType:(AlertPromptViewType)type {
    _type = type;
   
    
}


#pragma mark:-- acitons
- (void)cancelBtnActions:(UIButton *)btn {
    
    NSLog(@" 取消 按钮");
    [self alertDismiss];
    if (self.cancleBlock) {
        self.cancleBlock(btn);
    }
}

- (void)confirmBtnActions:(UIButton *)btn {
    NSLog(@" 确认 按钮");
    [self alertDismiss];
    if (self.confirmDeleteBlock) {
        self.confirmDeleteBlock(btn);
    }
}

- (void)alertShow {
    
    if (self.bgView222 == nil) {

        
//        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];

        
        UIView *bgView11 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, window.frame.size.width, window.frame.size.height)];
        bgView11.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [window addSubview:bgView11];
        self.bgView222 = bgView11;
        
        
        [bgView11 addSubview:self];
        [bgView11 bringSubviewToFront:self];
        
        CGFloat left_x = 200;
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView11.mas_left).offset(left_x);
            make.right.equalTo(bgView11.mas_right).offset(-left_x);
            make.top.equalTo(bgView11.mas_top).offset(left_x*1.2);
            make.bottom.equalTo(bgView11.mas_bottom).offset(-left_x*1.7);
        }];
    }
    
}

- (void)alertDismiss {
    
    [self.bgView222 removeFromSuperview];
    self.bgView222 = nil;
    
    [self removeFromSuperview];
    
    
}


@end
