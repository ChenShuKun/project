//
//  ScratchNetWork.h
//  Scratch
//
//  Created by alsrobot on 2020/1/9.
//  Copyright © 2020 ChenShuKun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"


NS_ASSUME_NONNULL_BEGIN

@interface ScratchNetWork : NSObject


+ (void)startCheckNewWork;
+ (BOOL)isNetworkAvailable;
/* 方法的替换，仅仅是 把旧项目的网络方式替换为 统一的 ，方便以后管理 */
+ (nullable NSURLSessionDataTask *)NetworkPOSTURL:(NSString *)URLString
                                       parameters:(nullable id)parameters
                                          success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                          failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

+ (NSURLSessionDataTask *)NetworkPOST:(NSString *)URLString
                           parameters:(id)parameters
            constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                             progress:(nullable void (^)(NSProgress * _Nonnull uploadProgress))uploadProgress
                              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


+ (NSMutableDictionary *)getBaseApiParams:(NSDictionary *)parameters;
//是否 是合法的响应
+ (BOOL)isValidResponse:(NSDictionary *)result;
+ (NSString *)getToastMsg:(NSDictionary *)result;

+ (NSString *)apiAppVersion;

@end

NS_ASSUME_NONNULL_END
