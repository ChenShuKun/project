//
//  SKProgressHUD.m
//  Alsrobot
//
//  Created by alsrobot on 2019/6/27.
//  Copyright © 2019 apple. All rights reserved.
//

#import "SKProgressHUD.h"

@implementation SKProgressHUD

+ (void)showLoading {
    [SVProgressHUD show];
    [SVProgressHUD setMinimumDismissTimeInterval:3];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

+ (void)dismissLoading {
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
}

+ (void)showWithDelay:(NSTimeInterval)dealy {
    [SVProgressHUD show];
    [SVProgressHUD setMinimumDismissTimeInterval:3];
    [SVProgressHUD dismissWithDelay:dealy];
}

+ (void)showWithStatus:(NSString *)status andDealy:(NSTimeInterval)dealy {
    [SVProgressHUD showWithStatus:status];
    [SVProgressHUD dismissWithDelay:dealy];
}

+ (void)showWithStatus:(NSString *)status {
    [SVProgressHUD showWithStatus:status];
}

+ (void)showErrorWithStatus:(NSString*)status {
    [SVProgressHUD setMinimumDismissTimeInterval:3];
    [SVProgressHUD showErrorWithStatus:status];
}
+ (void)showSuccessWithStatus:(NSString*)status {
    [SVProgressHUD setMinimumDismissTimeInterval:3];
    [SVProgressHUD showSuccessWithStatus:status];
}
+ (void)dismissWithDelay:(NSTimeInterval)delay completion:(SVProgressHUDDismissCompletion)completion {
    [SVProgressHUD dismissWithDelay:delay completion:completion];
}

@end
