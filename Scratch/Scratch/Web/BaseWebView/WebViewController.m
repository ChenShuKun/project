//
//  WebViewController.m
//  WebViewDemo
//
//  Created by alsrobot on 2019/6/27.
//  Copyright © 2019 alsrobot. All rights reserved.
//

#import "WebViewController.h"
#import "webViewHeader.h"

@interface WebViewController ()<WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *baseWKWeb;
@property (nonatomic, strong) UIProgressView * ProgressView; //加载的进度条
@property (nonatomic, copy )  NSString *publicWebViewTitle; //需要设置的标题
@property (nonatomic, copy )  NSString *publicWebViewURLString;
@property (nonatomic, copy )  NSString *postBody;
@property (nonatomic,strong)  NSMutableArray *scriptMessageHandlerArr;
@property (nonatomic, copy)   h5ActionsBlock h5Block;
@end

@implementation WebViewController

- (instancetype)initWithURLString:(NSString *)urlStr andTitle:(NSString *)title {
    if (self = [super init ] ) {
        self.publicWebViewTitle = title;
        self.publicWebViewURLString = urlStr;
    }
    return self;
}
/** 类方法 创建 post webViewController **/
- (instancetype)initWithPostURLString:(NSString *)urlStr andBody:(NSString *)body andTitle:(NSString *)title {
    
    if (self = [super init] ) {
        self.publicWebViewTitle = title;
        self.publicWebViewURLString = urlStr;
        self.postBody = body;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.publicWebViewTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initConfigh];
    [self initProgressView];
    [self initLeftBakButton];
    
    // KVO 开始监听
    [self webViewAttributeKeyObserve];
    
    
    if (self.webType == WebViewTypeUserAgreement) {
        [self.navigationController.navigationBar setHidden:NO];
    }
}

#pragma mark:-- 初始化数据
- (void)initConfigh {
    
    NSString *jScript = @"";
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
 
    
    CGRect frame = CGRectMake(0, 1, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    self.baseWKWeb = [[WKWebView alloc] initWithFrame:frame configuration:wkWebConfig];
    

    self.baseWKWeb.navigationDelegate = self;
    self.baseWKWeb.allowsBackForwardNavigationGestures = YES;
    [self.view addSubview:self.baseWKWeb];
    
    
    self.publicWebViewURLString = [self.publicWebViewURLString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    //通过不同的方式去加载 URL
    if (self.postBody != nil && self.postBody.length > 0) {
        
        NSURL *url = [NSURL URLWithString:self.publicWebViewURLString];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
        [request setHTTPMethod: @"POST"];
        [request setHTTPBody: [self.postBody dataUsingEncoding: NSUTF8StringEncoding]];
        [self.baseWKWeb loadRequest: request];
        
    }else {
        
        NSURL *url = [NSURL URLWithString:self.publicWebViewURLString];
        [self.baseWKWeb loadRequest:[NSURLRequest requestWithURL:url]];
    
    }
    
    
//    [self addAllScriptMsgHandle];
    _baseWKWeb.scrollView.scrollsToTop = YES;
}


- (void)reLoadURL:(NSString *)urlString {

    self.publicWebViewURLString = urlString ;
    NSURL *url = [NSURL URLWithString:self.publicWebViewURLString];
    [self.baseWKWeb loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)initProgressView {
    //获取状态栏的rect
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    //获取导航栏的rect
//    CGRect navRect = self.navigationController.navigationBar.frame;
//    那么导航栏+状态栏的高度
//    CGFloat top = statusRect.size.height + navRect.size.height;
    CGFloat top = statusRect.size.height;
    
    self.ProgressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.ProgressView.frame = CGRectMake(0,top, self.view.bounds.size.width,1);
    // 设置进度条的色彩
    [self.ProgressView setTrackTintColor:[UIColor clearColor]];
    self.ProgressView.progressTintColor = [UIColor redColor];
    [self.view addSubview:self.ProgressView];
    
}

- (void)initLeftBakButton {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setFrame:CGRectMake(0, 0, 30, 30)];
    [button setBackgroundImage:ImageNamed(@"back_Noraml_black") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftBtnBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
//    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backNoraml"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnBtnAction)];
    self.navigationItem.leftBarButtonItem = leftBtn;
}


#pragma mark:-- 和H5交互注册方法
- (void)registerIDWithID:(NSArray *)registerIDArray andCompleteBlock:(h5ActionsBlock)block {
    
    if (registerIDArray.count == 0 || registerIDArray ==nil) {
        return;
    }
    self.h5Block = block;
    self.scriptMessageHandlerArr = [NSMutableArray arrayWithArray:registerIDArray];
    for (NSString * registerID in registerIDArray) {
        WKUserContentController *wkUserController = self.baseWKWeb.configuration.userContentController;
        [wkUserController addScriptMessageHandler:self name:registerID];
    }
}

//和JS 交互
- (void)evaluateJavaScriptWithStr:(NSString *)str completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler {
 
    [self.baseWKWeb evaluateJavaScript:str completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
        //此处可以打印error.
        if (completionHandler) {
            completionHandler(result,error);
        }
    }];
}
- (void)reSetWebViewFrame:(CGRect)newFrame {
    
    self.baseWKWeb.frame = newFrame;
}

#pragma mark:-- 添加监听 和 移除监听
- (void)addAllScriptMsgHandle {
    
//    WKUserContentController *wkUserController = self.baseWKWeb.configuration.userContentController;
//    [wkUserController addScriptMessageHandler:self name:KObserverKey];
 
}
/**
 清理缓存
 */
- (void)clearWbCache {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
}
- (void)removeAllScriptMsgHandle {
    
    WKUserContentController *wkUserController = self.baseWKWeb.configuration.userContentController;
  
    for (NSString *messageKey in self.scriptMessageHandlerArr) {
        [wkUserController removeScriptMessageHandlerForName:messageKey];
    }
}

#pragma mark:-- KVO 开始监听
- (void)webViewAttributeKeyObserve {
    
    [self.baseWKWeb addObserver:self forKeyPath:kEstimatedProgress options:NSKeyValueObservingOptionNew context:nil];

}
#pragma mark:-- actions --- 操作
- (void)leftBtnBtnAction {
    
     if ([self.baseWKWeb canGoBack]) {
        [self.baseWKWeb goBack];
    }else {
        if (self.presentingViewController){
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


#pragma mark:--KVO 监听 回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:kEstimatedProgress]) {
        if (object == self.baseWKWeb) {
            if (self.baseWKWeb.estimatedProgress == 1.0) {
                self.ProgressView.hidden = YES;
            }else{
                NSLog(@"--%f",self.baseWKWeb.estimatedProgress);
                self.ProgressView.progress =  self.baseWKWeb.estimatedProgress;
            }
        }
    }
}

#pragma mark; -- WKNavigation Delegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {

    self.ProgressView.hidden = NO;
    [self.ProgressView setProgress:0.5];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //    NSString *urlStr = navigationAction.request.URL.absoluteString;
    // 外链的超链接点击响应
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    NSLog(@"  didFailProvisionalNavigation = error= %@",error);
 
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    NSLog(@"didFailNavigation = %@",error);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {

    [self loadWebViewDidFinish];
    
   
    
}

#pragma mark:--加载完成
- (void)loadWebViewDidFinish {
    
    NSLog(@"loadWebViewDidFinish  = ");
    
}
#pragma mark : -- 监听 js 的方法回调
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSDictionary *dict =  message.body;
    if (self.h5Block) {
        self.h5Block(dict);
    }
    
    [self detailWithDict:dict];
}

#pragma mark:--- 处理 H5 的回调 需要子类去实现
- (void)detailWithDict:(NSDictionary *)dict {
    
    NSString *name = dict[@"name"];
    if (name == nil) {
        NSLog(@" 数据错误 ");
        return;
    }
    [self detailWitDictWithName:name andWithData:dict];
}

//处理 不同的 H5回到的 aciton
- (void)detailWitDictWithName:(NSString *)name andWithData:(NSDictionary *)dict {
    
    NSLog(@"name = %@ ++++++ %@",name,dict[@"body"]);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    
     [_baseWKWeb removeObserver:self forKeyPath:kEstimatedProgress];
    _baseWKWeb = nil;
}

@end
