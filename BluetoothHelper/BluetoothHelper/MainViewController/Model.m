//
//  Model.m
//  BluetoothHelper
//
//  Created by ChenShuKun on 2019/8/17.
//  Copyright © 2019 ChenShuKun. All rights reserved.
//

#import "Model.h"

@implementation Model


- (NSString *)textLabelString {
    if (_name.length == 0 || ![_name isKindOfClass:[NSString class]]) {
        return @"";
    }
    return self.name;
}


- (NSString *)detailTextString {
    return [NSString stringWithFormat:@"[%@db],%@,%@",self.rssi, [self getStatus],[self getServers]];
}

- (NSString *)getStatus {
    
    switch (self.pheral.state) {
        case 0:
            return @"可连接";
            break;
        case 1:
            return @"正在连接中";
            break;
        case 2:
            return @"已连接";
            break;
        case 3:
            return @"可连接";
            break;
        default:
            break;
    }
    return @"";
}

- (NSString *)getServers {
    if (!self.advertisementData) {
        return @"0个Service";
    }
    NSArray *count = self.advertisementData[@"kCBAdvDataServiceUUIDs"];
    if (count.count == 0 || ![count isKindOfClass:[NSArray class]]   ) {
        return @"0个Service";
    }
    return [NSString stringWithFormat:@"%@个Service",@(count.count)];
}


- (BOOL)isExitModel:(NSMutableArray *)aray {
    if (aray.count == 0) {
        return NO;
    }
    for (Model *model in aray) {
        if ([model.pheral.identifier.UUIDString isEqualToString:self.pheral.identifier.UUIDString]) {
            return YES;
        }
    }
    return NO;
}


@end
