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
    
    BOOL isSave = [[SKPDFReader sharedSingleton] hasSaveUserName:name];
    if (!isSave) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的用户名或密码"];
        return;
    }
    
    NSDictionary *dict = [[SKPDFReader sharedSingleton] getInforData:name];
    if (![self.passworldTF.text isEqualToString:dict[@"password"]]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的密码"];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [SVProgressHUD show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadTableViewNSNotification" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    });

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
