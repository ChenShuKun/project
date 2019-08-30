//
//  LoginViewController.m
//  PDFReader
//
//  Created by ChenShuKun on 2019/8/2.
//  Copyright © 2019 ChenShukun. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *passworldTF;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}
- (IBAction)backActions:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginBtn:(UIButton *)sender {
    
    if (self.nameTF.text.length == 0 || self.passworldTF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的用户名或密码"];
        return;
    }
    
    NSString *name = self.nameTF.text;

    //http://127.0.0.1:8888/user/login?account=abc&password=123

    
    [SVProgressHUD show];
    NSDictionary *params = @{@"account":self.nameTF.text,
                             @"password":self.passworldTF.text
                             };
    [AFNetworkingManager requestGetUrlString:@"user/login" parameters:params successBlock:^(id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        if ([responseObject[@"code"] integerValue] == 0) {
            
            NSString *token = responseObject[@"data"][@"token"];
            if (token) {
                [UserDefault saveToken:token];
            }

            [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadTableViewNSNotification" object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
        NSLog(@"error  = %@",[error description]);
        
    }];

}

//[[NSUserDefaults standardUserDefaults] setObject:@"244410894@qq.com1" forKey:@"userName"];
//[[NSUserDefaults standardUserDefaults] synchronize];
//

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
