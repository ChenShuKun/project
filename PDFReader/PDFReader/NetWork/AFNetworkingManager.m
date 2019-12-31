//
//  AFNetworkingManager.m
//  PDFReader
//
//  Created by ChenShuKun on 2019/8/12.
//  Copyright © 2019 ChenShukun. All rights reserved.
//

#import "AFNetworkingManager.h"
#import "AFHTTPSessionManager.h"

#define BASEURL  @"http://49.234.218.186"

NSInteger const kAFNetworkingTimeoutInterval = 10;


@implementation AFNetworkingManager

static AFHTTPSessionManager *aManager;
+ (AFHTTPSessionManager *)sharedAFManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        aManager = [AFHTTPSessionManager manager];
        //以下三项manager的属性根据需要进行配置
        aManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/json",@"text/plain",@"text/JavaScript",@"application/json",@"image/jpeg",@"image/png",@"application/octet-stream",nil];
        
        aManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        // 设置超时时间
        aManager.requestSerializer.timeoutInterval = kAFNetworkingTimeoutInterval;
    });
    return aManager;
}

+ (void)requestGetUrlString:(NSString *)urlString
                 parameters:(NSDictionary *)parameters
               successBlock:(SkyHTTPRequestSuccessBlock)successBlock
               failureBlock:(SkyHTTPRequestFailedBlock)failureBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",BASEURL,urlString];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [params setObject:[UserDefault getToken] forKey:@"token"];
    
    return [self requestWithType:SkyHttpRequestTypeGet urlString:url parameters:params successBlock:^(id  _Nonnull responseObject) {
       NSLog(@"---responseObject = %@",responseObject);
       if (successBlock) {
           successBlock(responseObject);
       }
    } failureBlock:^(NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"网络不佳,请稍后再试"];
    }];
}

+ (void)requestWithType:(SkyHttpRequestType)type
              urlString:(NSString *)urlString
             parameters:(NSDictionary *)parameters
           successBlock:(SkyHTTPRequestSuccessBlock)successBlock
           failureBlock:(SkyHTTPRequestFailedBlock)failureBlock
{
    if (urlString == nil)
    {
        return;
    }
    
    if (@available(iOS 9.0, *)) {
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }else {
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    
    if (type == SkyHttpRequestTypeGet)
    {
        
        [[self sharedAFManager] GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(    NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (successBlock)
            {
            
                NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                
                id dict =  [self dictionaryWithJsonString:str];
                successBlock(dict);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (error.code !=-999) {
                if (failureBlock)
                {
                    failureBlock(error);
                }
            }
            else{
                NSLog(@"取消队列了");
            }
        }];
        
    }
    
    if (type == SkyHttpRequestTypePost)
    {
        
        [[self sharedAFManager] POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (successBlock)
            {
                successBlock(responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (error.code !=-999) {
                if (failureBlock)
                {
                    failureBlock(error);
                }
            }
            else{
                NSLog(@"取消队列了");
            }
            
        }];
    }
}

+(void)cancelDataTask
{
    NSMutableArray *dataTasks = [NSMutableArray arrayWithArray:[self sharedAFManager].dataTasks];
    for (NSURLSessionDataTask *taskObj in dataTasks) {
        [taskObj cancel];
    }
}



+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return jsonString;
    }
    return dic;
}

@end
