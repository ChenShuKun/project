//
//  LoginViewController.h
//  LearnDemo
//
//  Created by alsrobot on 2020/1/6.
//  Copyright © 2020 Chenshukun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LoginVCBlock)(NSString *str);

@interface LoginViewController : UIViewController

@property (nonatomic ,copy) LoginVCBlock block;

@end

NS_ASSUME_NONNULL_END
