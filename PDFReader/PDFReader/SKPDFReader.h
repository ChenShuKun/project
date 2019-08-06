//
//  SKPDFReader.h
//  PDFReader
//
//  Created by ChenShuKun on 2019/8/2.
//  Copyright © 2019 ChenShukun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKPDFReader : NSObject


+ (instancetype)sharedSingleton;

- (void)addObject:(NSString *)name;
- (void)removeObject:(NSString *)name;
- (NSArray *)getObjectArr;



// 登录相关
- (BOOL)hasSaveUserName:(NSString *)name;
- (void)saveUserName:(NSString *)name ;
- (NSDictionary *)getInforData:(NSString *)name ;

@end

NS_ASSUME_NONNULL_END
