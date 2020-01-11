//
//  WebViewController.h
//  WebViewDemo
//
//  Created by alsrobot on 2019/6/27.
//  Copyright © 2019 alsrobot. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^h5ActionsBlock)(NSDictionary *dict);
typedef NS_ENUM(NSUInteger, WebViewType) {
    WebViewTypeDefalut=0,
    WebViewTypeUserAgreement, //用户协议
    
};

@interface WebViewController : BaseViewController

/** 类方法 创建 webViewController **/
- (instancetype)initWithURLString:(NSString *)urlStr andTitle:(NSString *)title;

/** 类方法 创建 post webViewController **/
- (instancetype)initWithPostURLString:(NSString *)urlStr andBody:(NSString *)body andTitle:(NSString *)title;

@property (nonatomic ,assign) WebViewType webType;

- (void)reSetWebViewFrame:(CGRect)newFrame;
- (void)reLoadURL:(NSString *)urlString;
- (void)loadWebViewDidFinish;

#pragma mark:-- 和H5交互注册方法
- (void)registerIDWithID:(NSArray *)registerIDArray andCompleteBlock:(h5ActionsBlock)block;
- (void)removeAllScriptMsgHandle;
//和JS 交互
- (void)evaluateJavaScriptWithStr:(NSString *)str completionHandler:(void (^ _Nullable)(_Nullable id result, NSError * _Nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END
