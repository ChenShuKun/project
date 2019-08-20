//
//  SettingViewController.m
//  BluetoothHelper
//
//  Created by ChenShuKun on 2019/8/17.
//  Copyright © 2019 ChenShuKun. All rights reserved.
//

#import "SettingViewController.h"

#define APP_ID @"1476918754"
// iOS 11 以下的评价跳转
#define APP_OPEN_EVALUATE [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", APP_ID]
// iOS 11 的评价跳转
#define APP_OPEN_EVALUATE_AFTER_IOS11 [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8&action=write-review", APP_ID]

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *FeekBakBtn;
@property (weak, nonatomic) IBOutlet UIButton *CommentBtn;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//意见反馈
- (IBAction)FeekBackActions:(id)sender {
    // 初始化对话框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"蓝牙助手-用户反馈" message:@"请将您的宝贵意见发用到邮箱244410894@qq.com" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@" 确定并复制邮箱" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      
        NSLog(@"=====");
        [self copySucceed];
        [SVProgressHUD showSuccessWithStatus:@"复制成功"];
    }];
    [alert addAction:sure];
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];
}

//给我评价
- (IBAction)CommentActions:(id)sender {
   
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_OPEN_EVALUATE_AFTER_IOS11]];
#else
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_OPEN_EVALUATE]];
#endif
   
}

- (void)copySucceed {
    
    //系统级别
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"244410894@qq.com";
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
