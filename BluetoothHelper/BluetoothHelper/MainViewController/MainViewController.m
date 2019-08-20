//
//  MainViewController.m
//  BluetoothHelper
//
//  Created by ChenShuKun on 2019/8/17.
//  Copyright © 2019 ChenShuKun. All rights reserved.
//

#import "MainViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "DetailViewController.h"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource,CBCentralManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *dataArray;
@property (strong,nonatomic) UIImageView *noDataImageView;
@property (nonatomic, strong) CBCentralManager        *manager;

@end

@implementation MainViewController

-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self initCentralManager];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    
//    465 × 400
    self.noDataImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 465/2, 400/2)];
    self.noDataImageView.image = [UIImage imageNamed:@"nodatas.jpeg"];
    self.noDataImageView.center = self.view.center;
    self.noDataImageView.hidden = YES;
    [self.view addSubview:self.noDataImageView];
}


- (void)initCentralManager {
    
    [SVProgressHUD showWithStatus:@"开始扫描周围的设备"];
    if (self.manager) {
        self.manager.delegate = nil;
        self.manager = nil;
    }
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    [self performSelector:@selector(stopstopScan111) withObject:nil afterDelay:6];
}

- (void)stopstopScan111 {
    // 扫描到设备之后停止扫描
    if (self.manager.isScanning) {
        [_manager stopScan];
    }
    [SVProgressHUD dismiss];
    [self.tableView reloadData];
    
    if (self.dataArray.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"没发现可连接设备"];
        self.noDataImageView.hidden = NO;
    }else {
        self.noDataImageView.hidden = YES;
    }
}

#pragma mark - Navigation
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID ];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Model *mode =  self.dataArray[indexPath.row];
    
    cell.textLabel.text = [mode textLabelString];
    cell.detailTextLabel.text = [mode detailTextString];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Model *mode =  self.dataArray[indexPath.row];
    
    DetailViewController *detail = [[DetailViewController alloc]init];
    detail.detailModel = mode;
    self.manager.delegate = nil;
    [self.navigationController pushViewController:detail animated:YES];
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
            [_manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : [NSNumber numberWithBool:YES]}];
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
    NSLog(@"已发现 peripheral: %@ rssi: %@, UUID: %@ advertisementData: %@ ", peripheral.name, RSSI, peripheral.identifier, advertisementData);
    
    
    Model *models = [[Model alloc]init];
    models.name = peripheral.name;
    models.rssi = RSSI;
    models.pheral = peripheral;
    models.advertisementData = advertisementData;
    
    if (![models isExitModel:self.dataArray]) {
        [self.dataArray addObject:models];
    }
    
    [self stopstopScan111];
//    _peripheral = peripheral;
//    [_manager connectPeripheral:_peripheral options:nil];
//
//    // 扫描到设备之后停止扫描
//    [_manager stopScan];
}


- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    NSLog(@"成功连接 peripheral: %@ with UUID: %@",peripheral,peripheral.identifier);
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
     NSLog(@" didFailToConnectPeripheral");
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
//    if (_peripheral) {
//        [_manager cancelPeripheralConnection:_peripheral];
//    }
    
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"已断开与设备:[%@]的连接",peripheral.name]];
    NSLog(@"已断开与设备:[%@]的连接", peripheral.name);
}

#pragma mark - Navigation

- (IBAction)refreshActions:(UIBarButtonItem *)sender {
    NSLog(@"=== 刷新 ");
    [self initCentralManager];
}


@end
