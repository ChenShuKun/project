//
//  Model.h
//  BluetoothHelper
//
//  Created by ChenShuKun on 2019/8/17.
//  Copyright © 2019 ChenShuKun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface Model : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *rssi;
@property (nonatomic, copy) NSDictionary * advertisementData;

@property (nonatomic, strong) CBPeripheral *pheral;
@property (nonatomic, strong)  CBCentralManager *manager;


- (NSString *)textLabelString;
- (NSString *)detailTextString;

- (BOOL)isExitModel:(NSMutableArray *)aray;
@end

NS_ASSUME_NONNULL_END
