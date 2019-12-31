//
//  BluetoothCentralManager.h
//   
//
//  Created by apple on 2018/3/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEPeripheral.h"
#import "BLEControllerDelegate.h"
#import <CoreBluetooth/CoreBluetooth.h>
@interface BluetoothCentralManager : NSObject
@property(strong, nonatomic)CBCentralManager  *activeCentralManager;
// NSMutableArray
@property(strong, nonatomic) NSMutableArray    *peripherals;            // blePeripheral
@property(strong, nonatomic) NSMutableDictionary  *rssiDict;            // blePeripheral
@property(strong, nonatomic) BLEPeripheral        *activePeripheral;            // blePeripheral

@property(readonly)NSUInteger currentCentralManagerState;

// method
-(void)startScanning;
-(void)stopScanning;
-(void)resetScanning;

-(void)addDelegate:(id<BLEControllerDelegate>)delegate;
-(void)removeDelegate:(id<BLEControllerDelegate>)delegate;

-(void)connectPeripheral:(CBPeripheral*)peripheral;
-(void)disconnectPeripheral:(CBPeripheral*)peripheral;
//-(void)connectLastPer:(CBPeripheral*)p;
+(BluetoothCentralManager*)sharedManager;

-(void)autoConnect;
- (CBPeripheralState)blueToothConnectStatus;
//蓝牙是否连接
- (BOOL)isConnected ;
@end
