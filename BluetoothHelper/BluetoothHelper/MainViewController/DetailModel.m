//
//  DetailModel.m
//  BluetoothHelper
//
//  Created by a on 2019/8/22.
//  Copyright © 2019 ChenShuKun. All rights reserved.
//

#import "DetailModel.h"

@implementation DetailModel

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
