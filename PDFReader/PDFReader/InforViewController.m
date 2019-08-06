//
//  InforViewController.m
//  PDFReader
//
//  Created by ChenShuKun on 2019/8/2.
//  Copyright © 2019 ChenShukun. All rights reserved.
//

#import "InforViewController.h"

@interface InforViewController ()


@end

@implementation InforViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.headImg.image = [UIImage imageNamed:self.inforDict[@"head"]];
    self.nickNameLabel.text = [NSString stringWithFormat:@"昵称: %@",self.inforDict[@"name"]];
    self.sexLabel.text = [NSString stringWithFormat:@"性别: %@",self.inforDict[@"sex"]];
    self.desTextView.text = [NSString stringWithFormat:@" %@",self.inforDict[@"des"]];
    
    
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
