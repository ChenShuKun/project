//
//  UserInfor.h
//  ALSScratch3
//
//  Created by alsrobot on 2019/11/11.
//  Copyright © 2019 Chenshukun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfor : NSObject
/*
 avatar = "http://192.168.1.177:9527/als_classroom/public/zh/images/teacher.png";
 birthday = "2011-07-15";
 className = "Scratch3.0";
 "class_id" = 52;
 "logo_editor" = "https://alseduline.oss-cn-shenzhen.aliyuncs.com/ALS1570590243190.png";
 phone = 17600297829;
 "real_name" = "\U674e\U6728\U8001111";
 "register_time" = 1569811598;
 "role_id" = 2;
 "school_id" = 12;
 "school_name" = "\U6cfd\U96f7\U7684\U673a\U6784";
 sex = 1;
 "user_remark" = "";
 userid = 217;
 username = ALS1024828179;
 */

@property (nonatomic,copy)NSString *userid; //用户id
@property (nonatomic,copy)NSString *avatar; //头像
@property (nonatomic,copy)NSString *phone;  //手机号
@property (nonatomic,copy)NSString *birthday;//生日
@property (nonatomic,copy)NSString *username;//用户名 登录的账号
@property (nonatomic,copy)NSString *real_name;//真实姓名 （昵称）
@property (nonatomic,copy)NSString *logo_editor;
@property (nonatomic,copy)NSString *user_remark; //用户备注
@property (nonatomic,assign)NSInteger register_time; //注册时间
@property (nonatomic,assign)NSInteger role_id;      //角色
@property (nonatomic,assign)NSInteger sex;          //性别


@property (nonatomic,copy)NSString *school_name; //学校名称
@property (nonatomic,assign)NSInteger school_id; //学校 id

@property (nonatomic,copy)NSString *className;  //班级
@property (nonatomic,assign)NSInteger class_id; //班级 id


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

@interface UserManager : NSObject

/**
 存储用户信息
 @param dic 服务器获取来的用户信息字典
 @return yes
 */
+ (BOOL)saveUserInfo:(NSDictionary *)dic;


+ (BOOL)saveUserSigleInfo:(NSString *)key andValue:(NSString *)value;

/**
 取用户信息
 @return 返回用户信息模型
 */
+ (UserInfor *)userInfo;

//是否登录
+ (BOOL)userIsLogin;

/**
 清空用户信息
 @return yes
 */
+ (BOOL)clearUserInfo;

@end
 
NS_ASSUME_NONNULL_END


/*
 
 #import "UserManager.h"
 // 调用
 [UserManager saveUserInfo:@{@"nickname":@"小张飞"}];
 
 UserInfo *model =  [UserManager userInfo];
 
 NSLog(@"%@", model.nickname);

 
 */
