//
//  UserDefault.h
//  PDFReader
//
//  Created by ChenShuKun on 2019/8/21.
//  Copyright © 2019 ChenShukun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserDefault : NSObject

+ (BOOL)isLogIn;
+ (void)saveToken:(NSString *)token ;
+ (NSString *)getToken;
+ (void)removeToken;
@end

NS_ASSUME_NONNULL_END
