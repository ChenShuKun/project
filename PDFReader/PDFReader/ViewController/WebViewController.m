//
//  WebViewController.m
//  PDFReader
//
//  Created by ChenShuKun on 2019/8/14.
//  Copyright © 2019 ChenShukun. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()

@property (weak, nonatomic) WKWebView *webView;
@property (nonatomic,strong) CALayer *progresslayer;

@end

@implementation WebViewController {
    CGFloat navigationBarBottom ;
    CGFloat k_width;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hidesBottomBarWhenPushed = YES;

    WKWebView *webView = [[WKWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.webView = webView;
    
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
   
    //进度条
    k_width = self.view.frame.size.width;
    navigationBarBottom = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;

    self.progresslayer = [[CALayer alloc]init];
    self.progresslayer.frame = CGRectMake(0, navigationBarBottom, k_width*0.1, 2);
    self.progresslayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:self.progresslayer];

    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

}
//WkWebView的 回调
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
            self.title = self.webView.title;
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        self.progresslayer.opacity = 1;
        float floatNum = [[change objectForKey:@"new"] floatValue];
    
        self.progresslayer.frame = CGRectMake(0, navigationBarBottom, k_width*floatNum, 2);
        if (floatNum == 1) {
            
            __weak __typeof(self)weakSelf = self;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                weakSelf.progresslayer.opacity = 0;
                
            });
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                weakSelf.progresslayer.frame = CGRectMake(0, 0, 0, 3);
            });
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        
    }
    
}

- (void)dealloc{
    
    [_webView removeObserver:self forKeyPath:@"title"];
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];

}



@end
