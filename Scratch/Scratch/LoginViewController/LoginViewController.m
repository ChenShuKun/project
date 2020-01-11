//
//  LoginViewController.m
//  LearnDemo
//
//  Created by alsrobot on 2020/1/6.
//  Copyright © 2020 Chenshukun. All rights reserved.
//

#import "LoginViewController.h"
/** 获取屏幕尺寸 */
#define KScreen_width  [UIScreen mainScreen].bounds.size.width
#define KScreen_Height  [UIScreen mainScreen].bounds.size.height

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *logoIcon;
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextView *textViews;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self configTextView:self.textViews];
    
    
    UIImageView *image = [[UIImageView alloc]init];
    image.frame = CGRectMake(0, 0, KScreen_width, KScreen_Height);
    image.image= [UIImage imageNamed:@"Login_bg"];
    [self.view addSubview:image];
    [self.view insertSubview:image atIndex:0];
    
}

- (void)configTextView:(UITextView *)aaaLabel {
    
    NSString *text1 = @"登录及同意";
    NSString *aLink = @"《用户协议》";
    NSString *and = @"和";
    NSString *bLink = @"《隐私条款》";
    NSString *link = [NSString stringWithFormat:@"%@%@%@%@",text1,aLink,and,bLink];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:link];
    
    //用户协议
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"https://baidu.com"
                             range:[[attributedString string] rangeOfString:aLink]];
    //用户隐私
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"https://jianshu.com"
                             range:[[attributedString string] rangeOfString:bLink]];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:14]
                             range:[[attributedString string] rangeOfString:link]];
    [attributedString addAttribute:NSForegroundColorAttributeName
    value:[UIColor whiteColor]
    range:[[attributedString string] rangeOfString:link]];
    //设置链接样式
    aaaLabel.linkTextAttributes = @{
                                    NSForegroundColorAttributeName: [UIColor orangeColor],
                                    NSUnderlineColorAttributeName: [UIColor whiteColor],
                                    NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)
                                    };
    
    aaaLabel.attributedText = attributedString;
    aaaLabel.editable = NO;
    aaaLabel.scrollEnabled = NO;
    aaaLabel.textAlignment = NSTextAlignmentCenter;
    
}

#pragma mark:-- actions
- (IBAction)swiperGestureActions:(UISwipeGestureRecognizer *)sender {
    [self backAction];
}

- (IBAction)backButtonActions:(UIButton *)sender {
    [self backAction];
}
- (IBAction)viewTapActions:(UITapGestureRecognizer *)sender {
    
    [self.view endEditing:YES];
}

//返回
- (void)backAction {
    
    CGFloat login_W =  KScreen_width/3 + 100;
    CGFloat login_h =  KScreen_Height;
    self.view.frame = CGRectMake(KScreen_width/3 * 2 - 100, 0, login_W, login_h);
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.frame = CGRectMake(KScreen_width/3 * 2 , 0, login_W, login_h);
        [UIView animateWithDuration:0.3 animations:^{
            
            self.view.frame = CGRectMake(KScreen_width, 0, login_W, login_h);
            [self removeViewFromMainView];
        } completion:^(BOOL finished) {
            [self willMoveToParentViewController:nil]; //1
            [self.view removeFromSuperview]; //2
            [self removeFromParentViewController]; //3
        }];
    }];
    
}

- (void)removeViewFromMainView {
    
    if (self.block) {
        self.block(@"1");
    }
}

//登录按钮
- (IBAction)loginButtonActions:(UIButton *)sender {
    
    NSLog(@"---登录按钮  ");
    
    if (self.accountTF.text.length <= 0) {
        [SKProgressHUD showErrorWithStatus:@"账号不能为空"];
        return;
    }
    if (self.passwordTF.text.length <= 0) {
        [SKProgressHUD showErrorWithStatus:@"密码不能为空"];
        return;
    }
    
    [self loginActionsAPI];
    
}

- (void)loginActionsAPI {
    
    
    [self.view endEditing:YES];

    [SKProgressHUD showLoading];
    NSString *url = [NSString stringWithFormat:@"%@mobile_student/login",BASEURL];
    NSDictionary *params = @{@"username":self.accountTF.text,
                             @"password":self.passwordTF.text};
    __WeakSelf(self);
    [ScratchNetWork NetworkPOSTURL:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        NSLog(@" 成功 返回数据 = %@",responseObject);
        if ([ScratchNetWork isValidResponse:responseObject]) {
            
            [weakself loginSucceed:responseObject];
        }else {
            [SKProgressHUD showErrorWithStatus:[ScratchNetWork getToastMsg:responseObject]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SKProgressHUD showErrorWithStatus:@"网络错误,请稍后再试"];
    }];
}

- (void)loginSucceed:(NSDictionary *)result {

    [SKProgressHUD showSuccessWithStatus:[ScratchNetWork getToastMsg:result] ];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RELOADLOCALDATA_NOTIFICATION object:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self backAction];
    });
    
}


@end
