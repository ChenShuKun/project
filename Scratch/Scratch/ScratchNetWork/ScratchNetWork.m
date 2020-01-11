//
//  ScratchNetWork.m
//  Scratch
//
//  Created by alsrobot on 2020/1/9.
//  Copyright © 2020 ChenShuKun. All rights reserved.
//

#import "ScratchNetWork.h"


@implementation ScratchNetWork

#pragma mark:-- 判断网络 状态
+ (void)startCheckNewWork {
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变时调用
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"手机自带网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                break;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:REACHABILITYSTATUS_NOTIFICATION object:@{kcode:@(status)}];
        
    }];
    
    // 开始监控
    [manager startMonitoring];
}

+ (BOOL)isNetworkAvailable {
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    if (AFNetworkReachabilityStatusReachableViaWWAN ==  manager.networkReachabilityStatus) {
        return YES;
    }
    if (AFNetworkReachabilityStatusReachableViaWiFi ==  manager.networkReachabilityStatus) {
        return YES;
    }
    return NO;
}


#pragma mark:-- 网络统一方法 ，请求服务器
+ (nullable NSURLSessionDataTask *)NetworkPOSTURL:(NSString *)URLString
                                       parameters:(nullable id)parameters
                                          success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                          failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure {
    return [self BaseNetworkPOSTURL:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task_, id  _Nullable responseObject_) {
        if (success) {
            success(task_ ,responseObject_);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task_, NSError * _Nonnull error_) {
        
        NSLog(@" 失败了  = %@ \n URL =%@ ",error_.description,URLString);
        [SKProgressHUD dismissLoading];
        [SKProgressHUD showErrorWithStatus:@"网络错误，请稍后再试"];
        if (failure) {
            failure(task_,error_);
        }
    }];
}

+ (NSURLSessionDataTask *)NetworkPOST:(NSString *)URLString
                           parameters:(id)parameters
            constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                             progress:(nullable void (^)(NSProgress * _Nonnull uploadProgress))uploadProgress
                              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    return [manager POST:URLString parameters:parameters constructingBodyWithBlock:block progress:uploadProgress success:success failure:failure];
}


+ (nullable NSURLSessionDataTask *)BaseNetworkPOSTURL:(NSString *)URLString
                                           parameters:(nullable id)parameters
                                             progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                              success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                              failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    NSLog(@"网络统一方法--%@",URLString);
    if (![self isNetworkAvailable]) {
        
        [SKProgressHUD showErrorWithStatus:NO_NETWORK_MESSAGE];
        if (failure) {
            NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:4 userInfo:@{NSLocalizedDescriptionKey:NO_NETWORK_MESSAGE}];
            failure(nil,error);
        }
    }
    
    NSMutableDictionary *dicts = [self getBaseApiParams:parameters];
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 12;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSLog(@" 统一 参数 打印---%@",dicts);
    return [manager POST:URLString parameters:dicts progress:uploadProgress success:success failure:failure];
}





+ (NSMutableDictionary *)getBaseApiParams:(NSDictionary *)parameters {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:parameters];
 
    [params setObject:@"Scratch" forKey:@"app_name"];
    NSString *apiVersion = [self apiAppVersion];
    if (apiVersion) {
        [params setObject:apiVersion forKey:@"app_version"];
    }
    NSString *apiBuild = [self apiAppBuild];
    if (apiBuild) {
        [params setObject:apiBuild forKey:@"build_number"];
    }
    NSString *os_version = [UIDevice currentDevice].systemVersion;
    if (os_version) {
        [params setObject: os_version forKey:@"os_version"];
    }
    NSString *device_platform = [UIDevice currentDevice].model;
    if (device_platform) {
        [params setObject: device_platform forKey:@"device_platform"];
    }
    if (device_platform) {
        [params setObject: device_platform forKey:@"device_platform"];
    }
    // app 语言
    NSString *device_language = @"zh-Hans";
    [params setObject: device_language forKey:@"language"];
    [params setObject: @"iOS" forKey:@"os"];
    return params;
}

+ (NSString *)apiAppVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];//获取app版本信息
    return  [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)apiAppBuild {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleVersion"];
}

//是否 是合法的响应
+ (BOOL)isValidResponse:(NSDictionary *)result {
    
    if (result == nil) {
        return NO;
    }
    if (![result isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    if ([result[kcode] integerValue] == 1) {
        return  YES;
    }
    return  NO;
}

+ (NSString *)getToastMsg:(NSDictionary *)result {
    
    if (result == nil) {
        return @"";
    }
    if (![result isKindOfClass:[NSDictionary class]]) {
        return @"";
    }
    
    return result[kmessage];
}



@end
