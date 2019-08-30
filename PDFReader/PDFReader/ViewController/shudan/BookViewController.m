//
//  BookViewController.m
//  PDFReader
//
//  Created by ChenShuKun on 2019/8/17.
//  Copyright © 2019 ChenShukun. All rights reserved.
//

#import "BookViewController.h"

@interface BookViewController ()

@end

@implementation BookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)goToOtherBooks:(id)sender {
    
    
    WebViewController *webView = [[WebViewController alloc]init];
    webView.hidesBottomBarWhenPushed = YES;
    webView.urlString = @"https://www.douban.com/note/681081818/";
    [self.navigationController pushViewController:webView animated:YES];
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
