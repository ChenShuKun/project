//
//  WriteDataViewController.m
//  BluetoothHelper
//
//  Created by a on 2019/12/31.
//  Copyright © 2019 ChenShuKun. All rights reserved.
//

#import "WriteDataViewController.h"

@interface WriteDataViewController ()

@property (nonatomic ,weak) UITextField *textField;
@end

@implementation WriteDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title =  @"编辑";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemDone) target:self action:@selector(rightBarButtonItemActions:)];

 
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height /2)];
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.placeholder = @"请输入文字...";
    [self.view addSubview:textField];
    self.textField = textField;
    
}


- (void)rightBarButtonItemActions:(UIBarButtonItem *)right {
    
    
    NSLog(@"rightBarButtonItemActions ---");
    NSString *str = self.textField.text;
    if (self.block) {
        self.block(str);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
