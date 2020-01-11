//
//  SKProgressHUD.h
//  Alsrobot
//
//  Created by alsrobot on 2019/6/27.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface SKProgressHUD : NSObject

+ (void)showLoading;
+ (void)dismissLoading;

+ (void)showWithDelay:(NSTimeInterval)dealy;
+ (void)showWithStatus:(NSString *)status;
+ (void)showWithStatus:(NSString *)status andDealy:(NSTimeInterval)dealy ;


+ (void)showErrorWithStatus:(NSString*)status ;
+ (void)showSuccessWithStatus:(NSString*)status ;
+ (void)dismissWithDelay:(NSTimeInterval)delay completion:(SVProgressHUDDismissCompletion)completion;

@end

NS_ASSUME_NONNULL_END
