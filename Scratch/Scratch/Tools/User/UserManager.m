//
//  UserInfor.m
//  ALSScratch3
//
//  Created by alsrobot on 2019/11/11.
//  Copyright © 2019 Chenshukun. All rights reserved.
//

#import "UserManager.h"

@implementation UserInfor


- (NSString *)userid {
    if (_userid == nil) {
        return @"";
    }
    return _userid;
}

- (NSString *)user_remark {
    if (_user_remark == nil) {
        return @"";
    }
    return _user_remark;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if ([dictionary isKindOfClass:[NSDictionary class]])
    {
        if (self = [super init])
        {
            [self setValuesForKeysWithDictionary:dictionary];
        }
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([value isKindOfClass:[NSNull class]]) {
        if ([[self integerKeyArray] containsObject:key]) {
            value = 0;
        }else {
            value = @"";
        }
    }
    [super setValue:value forKey:key];
}
- (NSArray *)integerKeyArray {
    return @[@"register_time",@"role_id",@"sex",@"school_id",@"class_id"];
}

#pragma mark ————————— 对未定义key的处理方法 —————————————
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // id 变量名现在可以直接使用，比如你要将服务器的 id 转成 userid
    if([key isEqualToString:@"id"]) {
        self.userid = value;
        //          return;
    }
    
}

@end

@implementation UserManager



+ (BOOL)saveUserInfo:(NSDictionary *)dic {
    if (dic == nil || dic.allKeys.count <= 0) {
        return NO;
    }
    return [NSKeyedArchiver archiveRootObject:dic toFile:[self path]];
}

+ (BOOL)saveUserSigleInfo:(NSString *)key andValue:(NSString *)value {
    NSDictionary *data = [NSKeyedUnarchiver unarchiveObjectWithFile:[self path]];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:data];
    dict[key] = value;
    return [self saveUserInfo:dict];
}

+ (UserInfor *)userInfo
{
    id  data = [NSKeyedUnarchiver unarchiveObjectWithFile:[self path]];
    UserInfor *model = [[UserInfor alloc]initWithDictionary:data];
    return model;
}

//是否登录
+ (BOOL)userIsLogin {
    
    NSInteger user_id = [[self userInfo].userid integerValue];
    if (user_id > 0) {
        return YES;
    }
    return NO;
}

+ (BOOL)clearUserInfo
{
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:[self path]])
    {
        //删除归档文件
        return [defaultManager removeItemAtPath:[self path] error:nil];
    }
    else
    {
        return NO;
    }
}


/**
 Documents/ 保存应用程序的重要数据文件和用户数据文件等。用户数据基本上都放在这个位置(例如从网上下载的图片或音乐文件)，该文件夹在应用程序更新时会自动备份，在连接iTunes时也可以自动同步备份其中的数据。
 
 Library：这个目录下有两个子目录,可创建子文件夹。可以用来放置您希望被备份但不希望被用户看到的数据。该路径下的文件夹，除Caches以外，都会被iTunes备份.
 
 Library/Caches: 保存应用程序使用时产生的支持文件和缓存文件(保存应用程序再次启动过程中需要的信息)，还有日志文件最好也放在这个目录。iTunes 同步时不会备份该目录并且可能被其他工具清理掉其中的数据。
 Library/Preferences: 保存应用程序的偏好设置文件。NSUserDefaults类创建的数据和plist文件都放在这里。会被iTunes备份。
 
 @return nil
 */
+ (NSString *)path {
    /*
    // 获取沙盒根目录路径
    NSString *homeDir   = NSHomeDirectory();
    // 获取Documents目录路径
    NSString *docDir    = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    //获取Library的目录路径
    NSString *libDir    = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) lastObject];
    // 获取cache目录路径
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) firstObject];
    // 获取tmp目录路径
    NSString *tmpDir = NSTemporaryDirectory();
    // 获取应用程序程序包中资源文件路径的方法：
    NSString *bundle = [[NSBundle mainBundle] bundlePath];
    
    NSString *name = @"userinfo";
    NSString *type = @"sql";
    NSString *allName = [NSString stringWithFormat:@"%@.%@",name,type];

    return [tmpDir stringByAppendingPathComponent:allName];
     */
  
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [NSString stringWithFormat:@"%@/%@",documentPath,@"userinfo.sql"];
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if (![defaultManager fileExistsAtPath:path]) {
        
        BOOL isCreat = [defaultManager createFileAtPath:path contents:nil attributes:nil];
        NSLog(@"是否创建成功 :%@", @(isCreat));
    }
    
    return path;
}


@end
