//
//  DetailViewController.m
//  BluetoothHelper
//
//  Created by ChenShuKun on 2019/8/17.
//  Copyright © 2019 ChenShuKun. All rights reserved.
//

#import "DetailViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "DetailModel.h"

@interface DetailViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UITableView *tableiView ;
@property (nonatomic ,strong) NSMutableArray *dataArray;

@property (nonatomic, strong) CBCentralManager        *manager;
@property (nonatomic, strong) CBPeripheral           *peripheral;

@end

@implementation DetailViewController

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
    if (self.peripheral) {
        [self.manager cancelPeripheralConnection:self.peripheral];
    }
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"服务";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self initCentralManager];
    [self performSelector:@selector(stopstopScan111) withObject:nil afterDelay:20];
    
    NSString *message = @"设备连接中...";
    [SVProgressHUD showWithStatus:message];
    
    
    
    self.tableiView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableiView.dataSource = self;
    self.tableiView.delegate = self;
    [self.view addSubview:self.tableiView];
    

    NSString *text = [NSString stringWithFormat:@"    【 %@db 】  %@\n\n    UUID:%@ \n    %@    \n }",
                      self.detailModel.rssi,self.detailModel.name,self.detailModel.pheral.identifier.UUIDString,
                      self.detailModel.advertisementData ];
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    textView.editable = NO;
    textView.font = [UIFont systemFontOfSize:14];
    textView.text = text;
    [textView sizeToFit];
    
    CGRect frame = textView.frame;
    frame.size.height = frame.size.height + 20 ;
    textView.frame = frame;
    
    self.tableiView.tableHeaderView = textView;
    
    
#ifdef CHENSHUKUN_TEST
    
    for (int i = 0; i < 5; i++) {
        
        DetailModel *model = [[DetailModel alloc]init];
        model.header_name = [NSString stringWithFormat:@"我是标题 %@",@(i)];
        model.header_type = @"1111";
        model.dataArray = @[@{@"name":@"aaa",@"tpe":@"1"},@{@"name":@"bbb",@"tpe":@"2"}].mutableCopy;
        
        [self.dataArray addObject:model];
    }
#else
    
#endif
    
    
    //直接连接
//    self.manager = self.detailModel.manager;
//    self.peripheral = self.detailModel.pheral;
//
//    [self.manager connectPeripheral:_peripheral options:nil];
    
}

- (void)stopstopScan111 {
    // 扫描到设备之后停止扫描
    if (self.manager.isScanning) {
        [_manager stopScan];
    }
    [SVProgressHUD showErrorWithStatus:@"连接设备失败"];
}

- (void)initCentralManager {
    
     if (self.manager) {
        self.manager.delegate = nil;
        self.manager = nil;
    }

    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

#pragma mark - CBCentralManagerDelegate
// 该方法当蓝牙状态改变(打开或者关闭)的时候就会调用
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBManagerStatePoweredOn:
        {
            NSLog(@"蓝牙已打开,请扫描外设");
            // 第一个参数填nil代表扫描所有蓝牙设备,第二个参数options也可以写nil
            [_manager scanForPeripheralsWithServices:nil options:nil];
        }
            break;
        case CBManagerStatePoweredOff:
        {
            NSLog(@"蓝牙没有打开,请先打开蓝牙");
            [SVProgressHUD showErrorWithStatus:@"蓝牙没有打开,请先打开蓝牙"];
        }
            break;
        default:
        {
            [SVProgressHUD showErrorWithStatus:@"该设备不支持蓝牙功能"];
            NSLog(@"该设备不支持蓝牙功能,请检查系统设置");
        }
            break;
    }
}

//查到外设后，停止扫描，连接设备
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    // 可在该方法内部区分扫描到的蓝牙设备
    if ([self.detailModel.pheral.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
        NSLog(@"已发现可连接的 peripheral: %@ rssi: %@, UUID: %@ advertisementData: %@ ", peripheral.name, RSSI, peripheral.identifier, advertisementData);

        _peripheral = peripheral;
        [self.manager connectPeripheral:_peripheral options:nil];
        [self.manager stopScan];
    }
    
    // 扫描到设备之后停止扫描
}


- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    NSLog(@"成功连接 peripheral: %@ with UUID: %@",peripheral,peripheral.identifier);
    // 连接设备之后设置蓝牙对象的代理,扫描服务
    [self.peripheral setDelegate:self];
    [self.peripheral discoverServices:nil];
    
    NSLog(@"扫描服务");
    
}

// 获取热点强度
-(void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error {
    
    NSLog(@"%s,%@",__PRETTY_FUNCTION__,peripheral);
    
    int rssi = abs([RSSI intValue]);
    NSString *length = [NSString stringWithFormat:@"发现BLT4.0热点:%@,强度:%.1ddb",_peripheral,rssi];
    NSLog(@"距离：%@", length);
    
}

//已发现服务
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    for (CBService *s in peripheral.services) {
        // 扫描到服务后,根据服务发现特征
        [peripheral discoverCharacteristics:nil forService:s];
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    [_manager cancelPeripheralConnection:_peripheral];
    
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"已断开与设备:[%@]的连接",peripheral.name]];
    NSLog(@"已断开与设备:[%@]的连接", peripheral.name);
}


//已搜索到 Characteristics
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    
    NSLog(@"didDiscoverCharacteristicsForService 发现特征的服务:%@ (%@)",service.UUID.data ,service.UUID );

    for (CBService *s in peripheral.services) {
       
        NSLog(@"didDiscover - UUID: %@(%@)",s.UUID.data,s.UUID);
        DetailModel *model = [[DetailModel alloc]init];
        model.data = s.UUID.data;
        model.uuid = s.UUID;
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:service.characteristics.count];
        for (CBCharacteristic *c in service.characteristics) {
            DetailModel22 *detail = [[DetailModel22 alloc]init];
            detail.data22 = c.UUID.data;
            detail.uuid22 = c.UUID;
            [array addObject:detail];
        }
        model.dataArray = array;
        
        if (![self.dataArray containsObject:model]) {
            [self.dataArray addObject:model];
        }
    }
    
//    for (CBCharacteristic *c in service.characteristics) {
//        NSLog(@"特征 UUID: %@ (%@)",c.UUID.data,c.UUID);
//        // 此处FFE1为连接到蓝牙的特征UUID,我是获取之后写固定了,或许也可以不做该判断,我也不是太懂,如果有大神懂得希望指教一下.
//        [_peripheral readValueForCharacteristic:c];
//        [_peripheral setNotifyValue:YES forCharacteristic:c];
//
//    }
    [self.tableiView reloadData];
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@" didUpdateValueForCharacteristic ");
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE1"]]) {
        NSData * data = characteristic.value;
        Byte * resultByte = (Byte *)[data bytes];
        
        // 此处的byte数组就是接收到的数据
        NSLog(@"%s", resultByte);
        
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }
    
    // Notification has started
    if (characteristic.isNotifying) {
        [peripheral readValueForCharacteristic:characteristic];
    } else { // Notification has stopped
        // so disconnect from the peripheral
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
        //        [self updateLog:[NSString stringWithFormat:@"Notification stopped on %@.  Disconnecting", characteristic]];
        [self.manager cancelPeripheralConnection:self.peripheral];
    }
}


-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"=======%@",error.userInfo);
    }else{
        NSLog(@"发送数据成功");
    }
    
    /* When a write occurs, need to set off a re-read of the local CBCharacteristic to update its value */
    [peripheral readValueForCharacteristic:characteristic];
}


#pragma mark - UITableView data Source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
   
    DetailModel *model  = self.dataArray[section];
    NSArray *array = self.detailModel.advertisementData[@"kCBAdvDataServiceUUIDs"];
    
    NSString *str = @"";
    if (array !=nil && array.count > 0 && [array[0] isKindOfClass:[CBUUID class]]) {
        
        CBUUID *aa = array[0];
        if ([aa.UUIDString isEqualToString:model.uuid.UUIDString]) {
            str = [NSString stringWithFormat:@"SERVICE UUID : %@",model.uuid];
        }
    }else {
        str = [NSString stringWithFormat:@"%@ : %@",model.uuid,model.data];
    }
    return str;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DetailModel *model  = self.dataArray[section];
    return model.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"Cell_ID";
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    DetailModel *model  = self.dataArray[indexPath.section];
    DetailModel22 *model22 = model.dataArray[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@:%@",model22.uuid22, model22.data22];
    cell.detailTextLabel.text = @"属性:可读";
    
    return cell;
}


@end
