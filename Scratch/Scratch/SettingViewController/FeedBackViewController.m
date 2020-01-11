//
//  FeedBackViewController.m
//  Scratch
//
//  Created by ChenShuKun on 2020/1/7.
//  Copyright © 2020 ChenShuKun. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController ()
@property (weak, nonatomic) IBOutlet UILabel *feedBackTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *feedBackTextView;
@property (weak, nonatomic) IBOutlet UIButton *feedBackBtn;

@end

@implementation FeedBackViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)feedBackButtonActions:(UIButton *)sender {
    
    NSLog(@" 提交 ");
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
