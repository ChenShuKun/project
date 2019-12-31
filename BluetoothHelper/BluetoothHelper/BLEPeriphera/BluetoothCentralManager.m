//
//  BluetoothCentralManager.m
//   
//
//  Created by apple on 2018/3/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BluetoothCentralManager.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"

@interface BluetoothCentralManager (){
    
}
@property (nonatomic, strong) NSMutableArray *delegates;
@end

/****************************************************************************/
/*                      CentralDelegateState的类型                           */
/****************************************************************************/
enum {
    // 中心设备事件状态
    BLECentralDelegateStateRetrievePeripherals = 0,
    BLECentralDelegateStateRetrieveConnectedPeripherals,
    BLECentralDelegateStateDiscoverPeripheral,
    BLECentralDelegateStateConnectPeripheral,
    BLECentralDelegateStateFailToConnectPeripheral,
    BLECentralDelegateStateDisconnectPeripheral,
    // 中心设备初始状态
    BLECentralDelegateStateCentralManagerResetting,
    BLECentralDelegateStateCentralManagerUnsupported,
    BLECentralDelegateStateCentralManagerUnauthorized,
    BLECentralDelegateStateCentralManagerUnknown,
    BLECentralDelegateStateCentralManagerPoweredOn,
    BLECentralDelegateStateCentralManagerPoweredOff,
};
typedef NSInteger BLECentralDelegateState;

enum {
    BLEPeripheralDelegateStateInit = 0,
    BLEPeripheralDelegateStateDiscoverServices,
    BLEPeripheralDelegateStateDiscoverCharacteristics,
    BLEPeripheralDelegateStateKeepActive,
};
typedef NSInteger BLEPeripheralDelegateState;


@implementation BluetoothCentralManager
static BluetoothCentralManager*_instance;

/******************************************************/
//          类初始化                                   //
/******************************************************/
// 初始化蓝牙
-(id)init{
    self = [super init];
    if (self) {
        [self.activeCentralManager isScanning];
        [self.delegates removeAllObjects];
        [self initProperty];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CBCentralStateChange:) name:@"nCBCentralStateChange" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CBUpdataShowStringBuffer:) name:@"CBUpdataShowStringBuffer" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CBPeripheralStateChange: ) name:@"CBPeripheralStateChange" object:nil];
    }
    return self;
}

- (CBCentralManager *)activeCentralManager {
    if (!_activeCentralManager) {
        _activeCentralManager = [[CBCentralManager alloc] initWithDelegate:(id<CBCentralManagerDelegate>)self queue:dispatch_get_main_queue()];
    }
    return _activeCentralManager;
}

- (NSMutableArray *)delegates {
    if (!_delegates) {
        _delegates = [NSMutableArray array];
    }
    return _delegates;
}

-(void)addDelegate:(id<BLEControllerDelegate>)delegate{
    if(![self.delegates containsObject:delegate]){
        [self.delegates addObject:delegate];
    }
}
-(void)removeDelegate:(id<BLEControllerDelegate>)delegate{
    if([self.delegates containsObject:delegate]){
        [self.delegates removeObject:delegate];
    }
}
-(void)stateChanged{
    for (id<BLEControllerDelegate> delegate in self.delegates) {
        if([delegate respondsToSelector:@selector(bleStateChanged)]){
            [delegate bleStateChanged];
        }
    }
}
-(void)peripheralConnected{
    for (id<BLEControllerDelegate> delegate in self.delegates) {
        if([delegate respondsToSelector:@selector(bleConnected)]){
            [delegate bleConnected];
        }
    }
}
-(void)peripheralDisconnected{
    _activePeripheral = nil;
    // todo: delegate maybe null
    for (int i=0;i<self.delegates.count;i++) {
        id delegate = [self.delegates objectAtIndex:i];
        if([delegate respondsToSelector:@selector(bleDisconnected)]){
            [delegate bleDisconnected];
        }
    }
}
-(void)receivedData:(NSData*)data{
    for (id<BLEControllerDelegate> delegate in self.delegates) {
        if([delegate respondsToSelector:@selector(bleReceivedData:)]){
            [delegate bleReceivedData:data];
        }
    }
}
-(void)CBCentralStateChange:(NSNotification*)notification{
    [self stateChanged];
}
-(void)CBUpdataShowStringBuffer:(NSNotification*)notification{
    [self receivedData:[notification.userInfo objectForKey:@"data"]];
}
-(void)CBPeripheralStateChange:(NSNotification*)notification{
    /*
     if(_activePeripheral.currentPeripheralState==BLEPeripheralDelegateStateKeepActive){
     //[self peripheralDisconnected];
     }else{
     [self peripheralConnected];
     }
     */
    if(_activePeripheral.currentPeripheralState==BLEPeripheralDelegateStateKeepActive){
        [self peripheralConnected];
    }
}
-(void)initProperty{
    self.peripherals = [NSMutableArray array];
    self.rssiDict = [NSMutableDictionary dictionaryWithCapacity:10];
}
+(BluetoothCentralManager*)sharedManager{
    if(_instance==nil){
        _instance = [[BluetoothCentralManager alloc]init];
    }
    return _instance;
}

#pragma bluetooth
/** 判断手机蓝牙状态
 CBManagerStateUnknown = 0,  未知
 CBManagerStateResetting,    重置中
 CBManagerStateUnsupported,  不支持
 CBManagerStateUnauthorized, 未验证
 CBManagerStatePoweredOff,   未启动
 CBManagerStatePoweredOn,    可用
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    // 蓝牙可用，开始扫描外设
     AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (central.state == CBManagerStatePoweredOn) {
        NSLog(@"蓝牙可用");
        // 根据SERVICE_UUID来扫描外设，如果不设置SERVICE_UUID，则扫描所有蓝牙设备
        // [central scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:SERVICE_UUID]] options:nil];
        //  [self  startScanning];
        _currentCentralManagerState = BLECentralDelegateStateCentralManagerPoweredOn;
        app.connectStatus = _currentCentralManagerState;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"nCBCentralStateChange"  object:[NSString stringWithFormat:@"poweron"]];
    }
    if(central.state==CBManagerStateUnsupported) {
        [self resetScanning];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"nCBCentralStateChange"  object:[NSString stringWithFormat:@"unsupported"]];
        NSLog(@"该设备不支持蓝牙");
        app.connectStatus = BLECentralDelegateStateCentralManagerUnsupported;
    }
    if (central.state==CBManagerStatePoweredOff) {
        [self resetScanning];
        _currentCentralManagerState = BLECentralDelegateStateCentralManagerPoweredOff;
        NSString* state = @"poweredOff";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"nCBCentralStateChange"  object:state];
        app.connectStatus = _currentCentralManagerState;
        NSLog(@"蓝牙已关闭");
    }
}

/** 发现符合要求的外设，回调 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    // 对外设对象进行强引用
    NSLog(@"------>name:%@ --------->RSSI:%@---------advertisementData:%@",peripheral.name,RSSI,advertisementData);
   
    //    if ([peripheral.name hasPrefix:@"WH"]) {
    //        // 可以根据外设名字来过滤外设
    //        [central connectPeripheral:peripheral options:nil];
    //    }
    
    if ([self.activeCentralManager isEqual:central]) {
        //dLog(@"didDiscoverPeripheral %@ %@ %@",peripheral.name,peripheral.UUID,RSSI);
        [_rssiDict setObject:RSSI forKey:[peripheral.identifier UUIDString]];
        NSString *perName = [peripheral.name lowercaseString];
        if ([perName containsString:@"robot"] ) {
            if(![self.peripherals containsObject:peripheral]){
                [self.peripherals addObject:peripheral];
            }
        }
    
        // 更新状态
        _currentCentralManagerState = BLECentralDelegateStateDiscoverPeripheral;
        AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        app.connectStatus = BLECentralDelegateStateDiscoverPeripheral;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"nCBCentralStateChange"  object:[NSString stringWithFormat:@"search"]];
    }
}
/** 连接成功 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    // 可以停止扫描
    [self stopScanning];
    
    // 设置代理
   // peripheral.delegate = self;
    //连接成功 隐藏外设列表
//    self.bluetoothView.frame = CGRectMake(KWidth, 0, self.bluetoothView.frame.size.width, self.bluetoothView.frame.size.height);
    
    //点击连接蓝牙隐藏搜索按钮
 //   self.searchBtn.hidden = YES;
    NSLog(@"连接成功");
  //  [self checkConnectStatus];
    // 根据UUID来寻找服务
   //  [peripheral discoverServices:@[[CBUUID UUIDWithString:@""]]];
    if (_activePeripheral == nil) {
        self.activePeripheral = [[BLEPeripheral alloc]init];
    }
    _activePeripheral.activePeripheral = peripheral;
    // 如果当前设备是已连接设备开始扫描服务
    CBUUID    *TransSerUUID     = [CBUUID UUIDWithString:@"FFF0"];
    NSArray    *serviceArray    = [NSArray arrayWithObjects:TransSerUUID, nil];
    
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    
    if (![[ud objectForKey:@"perUUID"] isEqualToString:[peripheral.identifier UUIDString]]) {
        [ud setObject:peripheral.name forKey:@"perName"];
        [ud setObject:[peripheral.identifier UUIDString] forKey:@"perUUID"];
    }
   
    [ud synchronize];
    
    [_activePeripheral startPeripheral:peripheral DiscoverServices:serviceArray];
    _currentCentralManagerState = BLECentralDelegateStateConnectPeripheral;
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    app.connectStatus = BLECentralDelegateStateConnectPeripheral;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"nCBCentralStateChange"  object:@"connect"];
}
/** 连接失败的回调 */
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"连接失败");
   [[NSNotificationCenter defaultCenter] postNotificationName:@"nCBCentralStateChange"  object:@"failToConnect"];
   // [self checkConnectStatus];
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    app.connectStatus = BLECentralDelegateStateFailToConnectPeripheral;
}

/** 断开连接 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    NSLog(@"断开连接");
   
   // [self checkConnectStatus];
    // 断开连接可以设置重新连接
    // [central connectPeripheral:peripheral options:nil];
    _currentCentralManagerState = BLECentralDelegateStateDisconnectPeripheral;
    [self peripheralDisconnected];
    [[self peripherals] removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"nCBCentralStateChange"  object:[NSString stringWithFormat:@"disconnect"]];
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    app.connectStatus = _currentCentralManagerState;
    // restart scan
    //[self resetScanning];
}


// 按UUID进行扫描
-(void)startScanning{
    //  NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    [self.activeCentralManager scanForPeripheralsWithServices:nil options:nil];
    //[[self peripherals] removeAllObjects]; // yzj, is necessary here?
    
    //十秒后停止扫描
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopScanning) object: nil];
    [self performSelector:@selector(stopScanning) withObject:nil afterDelay:10];
    NSLog(@"startScanning...");
}

// 停止扫描
-(void)stopScanning{
    //停止旋转刷新按钮
   // [self btnStopRotate:self.refreshBtnBgIV];
    [self.activeCentralManager stopScan];
}

// 扫描复位
-(void)resetScanning{
    [self stopScanning];
    [self startScanning];
    
}

// 开始连接
-(void)connectPeripheral:(CBPeripheral*)peripheral
{
    if (peripheral.state!=CBPeripheralStateConnected){
        // 连接设备
        [self.activeCentralManager connectPeripheral:peripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
        [self performSelector:@selector(connectFailed:) withObject:peripheral afterDelay:20];
    }
    else{
        // 检测已连接Peripherals
        [self.activeCentralManager retrieveConnectedPeripheralsWithServices:nil];
    }
}
-(void)connectFailed:(CBPeripheral*)peripheral{
    if (_currentCentralManagerState != BLECentralDelegateStateConnectPeripheral) {
        [self.activeCentralManager cancelPeripheralConnection:peripheral];
       // [SVProgressHUD showErrorWithStatus:@"连接失败"];
          [SVProgressHUD dismiss];
    }
    
}
// 断开连接
-(void)disconnectPeripheral:(CBPeripheral*)peripheral
{
    // 主动断开
    if (peripheral != nil) {
        [self.activeCentralManager cancelPeripheralConnection:peripheral];
    }
   // [self resetScanning];
}

-(void)autoConnect{
    [self resetScanning];
    [self performSelector:@selector(con) withObject:nil afterDelay:2];
}
-(void)con{
    
    float min_number = INFINITY;   //最小值
    int min_index = 0;           //最小值下标
    if (self.peripherals.count > 0) {
        for (int i = 0; i<self.peripherals.count; i++) {
            CBPeripheral*  p = self.peripherals[i];
            NSString * uuidStr = [[NSString alloc] initWithFormat:@"%@",[p.identifier UUIDString]];
            NSNumber * rssi = [self.rssiDict objectForKey:uuidStr];
            float dist = powf(10.0,((abs(rssi.intValue)-50.0)/50.0))*0.7;
            //取最小值和最小值对应的下标
            
            if (dist < min_number)
            {
                min_index = i;
            }
            min_number = dist > min_number ? min_number:dist;
        }
        
        CBPeripheral* per = self.peripherals[min_index];
        [self connectPeripheral:per];
    }else{
        [SVProgressHUD dismiss];
    }
    
    
    
}
//蓝牙是否连接
- (BOOL)isConnected {
    AppDelegate* app =(AppDelegate*)[UIApplication sharedApplication].delegate;
    if(app.connectStatus == 11 ){
        return NO;
    }
    return YES;
 
}
- (CBPeripheralState)blueToothConnectStatus {
    return [[[BluetoothCentralManager sharedManager].activePeripheral activePeripheral] state];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nCBCentralStateChange" object:nil];
}
@end
