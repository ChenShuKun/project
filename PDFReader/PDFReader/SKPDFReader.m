//
//  SKPDFReader.m
//  PDFReader
//
//  Created by ChenShuKun on 2019/8/2.
//  Copyright © 2019 ChenShukun. All rights reserved.
//

#import "SKPDFReader.h"

@interface SKPDFReader ()
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end
@implementation SKPDFReader

+ (instancetype)sharedSingleton {
    static SKPDFReader *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //不能再使用alloc方法
        //因为已经重写了allocWithZone方法，所以这里要调用父类的分配空间的方法
        _sharedSingleton = [[super allocWithZone:NULL] init];
    });
    return _sharedSingleton;
}

-(NSMutableArray *)array {
    if (!_array) {
        _array  = [NSMutableArray array];
    }
    return _array;
}


- (void)addObject:(NSString *)name {
    if (![self.array containsObject:name]) {
        [self.array addObject:name];
    }
}

- (void)removeObject:(NSString *)name {
    
    if ([self.array containsObject:name]) {
        [self.array removeObject:name];
    }
}
- (NSArray *)getObjectArr {
    return self.array;
}





//登录相关

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        NSArray *array = @[@{@"name":@"小麦家爱",
                             @"account":@"244410894@qq.com",
                             @"password":@"123456",
                             @"sex":@"男",
                             @"head":@"head.jpg",
                             @"read":@"阅读 42 分钟",
                             @"readBooks":@"读过 0 本",
                             @"zanCount":@"被赞 0 次",
                             @"des":@"我是一个爱好的阅读者,阅读让我开心,阅读让我充实,阅读让我的生活丰富,阅读让我增长知识,阅读是我的美好习惯,加油!!!"
                             },
                           ];
        _dataArray = [NSMutableArray arrayWithArray:array];
    }
    return _dataArray;
}

- (void)saveUserName:(NSString *)name {
    
    if (name) {
        [self.dataArray addObject:@{@"name":@"小麦家爱",
                                    @"sex":@"男",
                                    @"account":@"244410894@qq.com",
                                    @"password":@"123456",
                                    @"head":@"head.jpg",
                                    @"read":@"阅读 42 分钟",
                                    @"readBooks":@"读过 0 本",
                                    @"zanCount":@"被赞 0 次",
                                    @"des":@"我是一个爱好的阅读者,阅读让我开心,阅读让我充实,阅读让我的生活丰富,阅读让我增长知识,阅读是我的美好习惯,加油!!!"
                                    }];
    }
}

- (BOOL)hasSaveUserName:(NSString *)name {
   
    for (NSDictionary *dict in self.dataArray) {
        if ([dict[@"account"] isEqualToString:name]) {
            return YES;
        }
    }
    return NO;
}
- (NSDictionary *)getInforData:(NSString *)name {

    for (NSDictionary *dict in self.dataArray) {
        if ([dict[@"account"] isEqualToString:name]) {
            return dict;
        }
    }
    return @{};
}


@end
