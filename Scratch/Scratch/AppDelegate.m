//
//  AppDelegate.m
//  Scratch
//
//  Created by ChenShuKun on 2019/12/30.
//  Copyright © 2019 ChenShuKun. All rights reserved.
//

#import "AppDelegate.h"
#import <HTTPServer.h>//本地服务器
#import "HTTPFileResponse+SVG.h"

@interface AppDelegate ()
/**本地服务器*/
@property (strong, nonatomic) HTTPServer *httpServer;
/**是否启动了本地服务器*/
@property(nonatomic,assign) BOOL startServer;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
 
    
    [self openServer];
    [ScratchNetWork startCheckNewWork];

    return YES;
}

//开启本地服务器
- (void)openServer {
    
    if (self.httpServer ==nil) {
        self.httpServer = [[HTTPServer alloc]init];
    }
    
    [self.httpServer setType:@"_http._tcp."];
    [self.httpServer setPort:6080];
    
    NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"build"];
    [self.httpServer setDocumentRoot:webPath];
    NSLog(@"服务器路径：%@", webPath);
    _startServer = [self startServerAction];
}

- (BOOL)startServerAction {//启动服务
    BOOL ret = NO;
    NSError *error = nil;
    if( [self.httpServer start:&error]){
        NSLog(@"HTTP服务器启动成功端口号为： %hu", [_httpServer listeningPort]);
        ret = YES;
    }else{
        NSLog(@"启动HTTP服务器出错: %@", error);
    }
    return ret;
}

- (void)stopServer {//停止服务
    if (self.httpServer != nil){
        [self.httpServer stop];
        _startServer = NO;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if (_startServer){//停止本地服务器
        [self stopServer];
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    if (!_startServer){
        _startServer = [self startServerAction];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

/*
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
*/
