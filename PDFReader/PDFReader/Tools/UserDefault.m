//
//  UserDefault.m
//  PDFReader
//
//  Created by ChenShuKun on 2019/8/21.
//  Copyright © 2019 ChenShukun. All rights reserved.
//

#import "UserDefault.h"

@implementation UserDefault

+ (BOOL)isLogIn {
    
//    NSString *token =  [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
//    if (token== nil || token.length == 0) {
//        return NO;
//    }
    return YES;
}

+ (void)saveToken:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getToken {
    
    return @"92d64aa2d83b237aae8eb3a49f4df030";
    if (![self isLogIn]) {
        return @"";
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
}

+ (void)removeToken {
    if ([self isLogIn]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else {
        NSLog(@" 没有登录 ");
    }
}


@end
