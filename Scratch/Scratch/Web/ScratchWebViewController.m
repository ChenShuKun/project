//
//  ScratchWebViewController.m
//  ALSScratch3
//
//  Created by alsrobot on 2019/10/9.
//  Copyright © 2019 Chenshukun. All rights reserved.
//

#import "ScratchWebViewController.h"
//#import "BluetoothCentralManager.h"
#import "webViewHeader.h"
//#import "ALSDeleteAlertView.h"
#import "WebViewBlueToothCell.h"
#import "LocalModel.h"
//#import "ALSDeleteAlertView.h"
//#import "UIScrollView+EmptyDataSet.h"  //数据没有的时候显示

static NSString *IS_CURRENT_VIEW_KEY = @"isLeaveCurrentView";

@interface ScratchWebViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,weak) UILabel *titleLabel;

@property (nonatomic ,weak) UIImageView *tableViewBGView;
@property (nonatomic ,weak) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataArray;

//@property (nonatomic ,weak) ALSDeleteAlertView *alertDeleteView;
@property (nonatomic ,weak) UIView *bgView333;

@property (nonatomic ,strong) NSTimer *blueToothStatusTimer; //蓝牙状态 timer

@end

@implementation ScratchWebViewController {
    NSInteger checkIndex;
}

- (instancetype)initWithURLString:(NSString *)urlStr andTitle:(NSString *)title {

    return [super initWithURLString:urlStr andTitle:title];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (LocalModel *)localModel {
    if (!_localModel) {
        _localModel = [[LocalModel alloc]init];
    }
    return _localModel;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self checkConnectStatus];
    
    [self setCurrentViewKey:1];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self setCurrentViewKey:0];
    
}

- (void)setCurrentViewKey:(NSInteger)type {
    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:IS_CURRENT_VIEW_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)isCurrentView {
    
    NSInteger type = [[NSUserDefaults standardUserDefaults] integerForKey:IS_CURRENT_VIEW_KEY];
    return type;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubViews];
//    [self initTestViews];
    [self initBleSearchView];

    
//    [self startCheckBlueToothStatus];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bluetoothStateChanged:) name:@"nCBCentralStateChange" object:nil];
    
    __weak typeof(self) this = self;
    NSArray *functions = @[kJSLOG,kBLESEARCH, kRECEIVECMD,kGETSCRATCHINFOR,kSAVEPROJECT3,
                           kHOMEWORKPROJECT3,kCLOUDPROJECT3];
    [self registerIDWithID:functions andCompleteBlock:^(NSDictionary * _Nonnull dict) {
        [this scratchDetailWithDict:dict];
    }];
    
}

- (void)startCheckBlueToothStatus {
    
    if (self.blueToothStatusTimer ==nil ) {
        self.blueToothStatusTimer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(checkBlueToothStatus) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.blueToothStatusTimer forMode:NSRunLoopCommonModes];
    }
}

#pragma mark:--- iOS 和 webView 交互
- (void)scratchDetailWithDict:(NSDictionary *)dict {
    if (![dict isKindOfClass:[ NSDictionary class]]) {
        return;
    }
    NSString *name = dict[kName];
    if (name == nil) {
        NSLog(@" name = nil ");
        return;
    }
    [self scratchDetailWitDictWithName:name andWithData:dict];
}

// 处理 不同的 H5回到的 aciton
- (void)scratchDetailWitDictWithName:(NSString *)name andWithData:(NSDictionary *)dict {
    
    NSLog(@"scratchDetailWitDictWithName = %@ ++++++ %@",name,dict[kBody]);
    if ([name isEqualToString:kJSLOG]) {
        

    }else if ([name isEqualToString:kBLESEARCH]) {
 
        [self mobile_bleSearch];
    }else if([name isEqualToString:kRECEIVECMD]){
       
        [self moblile_receiveCmd:dict[kBody]];
    }else if([name isEqualToString:kGETSCRATCHINFOR]){
        
        [self moblile_getScratchInfor:dict[kBody]];
    }else if ([name isEqualToString:kSAVEPROJECT3]) {
        
        NSLog(@"kSAVEPROJECT3 name = %@ ++++++ %@",name,dict[kBody]);
        NSDictionary *data = dict[kBody];
        if ([data isKindOfClass:[NSDictionary class]]) {
            
            NSString *title = data[@"title"];
            NSString *content = data[@"content"];
            [self saveScratchActionWithTitle:title andContent:content];
        }
    }else if ([name isEqualToString:kHOMEWORKPROJECT3]) { //作业模块
        
        NSDictionary *data = dict[kBody];
        NSLog(@"作业模块 data = %@",data);
        if ([data isKindOfClass:[NSDictionary class]]) {
            //"code":"0","msg":"发生了错误catch"
//            NSInteger code = [data[kcode] integerValue];

        }
    }else if ([name isEqualToString:kCLOUDPROJECT3]){//云端存储 模块
       
        NSDictionary *data = dict[kBody];
        NSLog(@"云端存储 data = %@",data);
        
    }
}

- (void)saveScratchActionWithTitle:(NSString *)scratchName andContent:(NSString *)content {
 
    FileManger *file = [[FileManger alloc]init];
    file.fileName = scratchName;
    file.fileContent = content;
    /*1 是否是创建进来的
     */
    if ([self.title isEqualToString:@"create"]) {
        //判断是否存在，然后再存储
        if ([FileManger isExistAtFileName:scratchName]) {
          
        }else {
            
            [file fileManger_add];
            [self alertSucceedWithTitle:@"保存成功" andDelayTime:3];
        }
    }else if ([self.title isEqualToString:@"update"]){
        
        if ([FileManger isExistAtFileName:scratchName]) {
            //更新操作
            [file fileManger_updateContent];
            [self alertSucceedWithTitle:@"更新成功" andDelayTime:3];
        }else {
            
            [FileManger fileManger_remove_FileName:self.localModel.localTitle];
            [file fileManger_add];
            [self alertSucceedWithTitle:@"保存成功" andDelayTime:3];
        }
    }
    
}


- (void)alertSucceedWithTitle:(NSString *)title andDelayTime:(NSInteger)time {
    [SKProgressHUD showSuccessWithStatus:title];
}

- (void)delayDissmiss {

}

/*
    1 搜索蓝牙框弹出 bleSearch()
    2 接收命令，receiveCmd() -> 16进制字符串
    3 获取Scratch信息， -> getScratchInfor -> "{}""
    4 打log日志 jsLog  -> 字符串
    5 设置蓝牙状态 setBleStatus("0")
 6 发送命令, sendCmd()  -> 16进制字符串
    7 设置Scratch信息   -> setScratchInfor -> "{}"
*/
// 蓝牙框搜索 ---OK
- (void)mobile_bleSearch {
    NSLog(@"mobile_bleSearch =  蓝牙搜索 ");

    [self searchActions];
}

// 接收命令 OK
- (void)moblile_receiveCmd:(NSArray *)cmdArray {
    
    //判断蓝牙连接状态
    if ([self bluetoothIsConnected]) {
        
    }
}

// 获取 Scratch 信息 OK
- (void)moblile_getScratchInfor:(NSString *)infor {
   
    NSLog(@"moblile_getScratchInfor  = %@ ",infor);
    if ([infor isKindOfClass:[NSString class]] && infor.length > 0) {
     
        NSDictionary *dict = [infor mj_JSONObject];
        ScratchModel *model = [ScratchModel mj_objectWithKeyValues:dict];
        model.scratchName = @"我是内部的名称";
        self.model = model;
        
        if (self.scratchBlock) {
            self.scratchBlock(self.model);
        }
    }
}

// 设置蓝牙状态 --ok
- (void)moblile_setBleStatus {
    
    NSString *bleStatus = @"0";
    if ([self bluetoothIsConnected]) {
        bleStatus = @"1";
    }
    NSString *method = [NSString stringWithFormat:@"setBleStatus('%@')",bleStatus];
    [self evaluateJavaScriptWithStr:method completionHandler:^(id _Nullable result, NSError * _Nullable error) {

        NSLog(@"result = %@ ",result);
        NSLog(@"error = %@ ",error.description);
    }];
    
}

- (BOOL)bluetoothIsConnected {
//
//    if ([BluetoothCentralManager sharedManager].currentCentralManagerState == 11) {
//        NSLog(@" 未开启蓝牙 ");
//        return NO;
//    }
//
//    CBPeripheral *per = [BluetoothCentralManager sharedManager].activePeripheral.activePeripheral;
//    if (per != nil && per.state == CBPeripheralStateConnected) {
//        return YES;
//    }
    return NO;
}

// 发送命令 给 js
- (void)moblile_sendCmd:(NSString *)cmd {
    
  NSLog(@" moblile_sendCmd = %@ ", cmd);
    if (cmd.length <= 0) {
        return;
    }
    NSString *method = [NSString stringWithFormat:@"sendCmd('%@')",cmd];
    [self evaluateJavaScriptWithStr:method completionHandler:^(id _Nullable result, NSError * _Nullable error) {

        NSLog(@"result = %@ ",result);
        NSLog(@"error = %@ ",error.description);
    }];
}

// 设置Scratch信息 --ok
- (void)moblile_setScratchInfor {
    
    NSLog(@" 设置 scratch 信息 ");
    if (!self.model) {
        return;
    }
    NSString *infor = [self.model mj_JSONString];
    NSString *method = [NSString stringWithFormat:@"setScratchInfor('%@')",infor];
    [self evaluateJavaScriptWithStr:method completionHandler:^(id _Nullable result, NSError * _Nullable error) {

    }];
    
}

//检查蓝牙状态
- (void)checkBlueToothStatus {
    
//    if ([BluetoothCentralManager sharedManager].currentCentralManagerState == 11) {
//        NSLog(@" 未开启蓝牙 ");
//        [self showBlueToothAuthAlert];
//        return ;
//    }
//
//    CBPeripheral *per = [BluetoothCentralManager sharedManager].activePeripheral.activePeripheral;
//    if (per == nil || per.state != CBPeripheralStateConnected) {
//
//        if (checkIndex == 0) {
//            checkIndex = 1;
//            [self searchActions];
//        }else {
//
//        }
//        return;
//    }
    NSLog(@" 检查蓝牙状态 ");
}


#pragma mark:-- 测试视图
- (void)initTestViews {
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = kRandomColor;
    [button setTitle:@"搜蓝牙" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(searchActions) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(60);
        make.top.equalTo(self.view).offset(24 +60+20);
        make.right.equalTo(self.view).offset(-30);
    }];
    
    UIButton* button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.backgroundColor = kRandomColor;
    [button1 setTitle:@"断开" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(disConnectedBle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(60);
        make.top.equalTo(button.mas_bottom).offset(20);
        make.right.equalTo(self.view).offset(-30);
    }];
    
    UIButton* button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.backgroundColor = kRandomColor;
    [button2 setTitle:@"红灯" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(redLedActions) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(60);
        make.top.equalTo(button1.mas_bottom).offset(20);
        make.right.equalTo(self.view).offset(-30);
    }];
    
    UIButton* button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.backgroundColor = kRandomColor;
    [button3 setTitle:@"停止" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(blackLedActions) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    [button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(60);
        make.top.equalTo(button2.mas_bottom).offset(20);
        make.right.equalTo(self.view).offset(-30);
    }];
    
    UIButton* button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    button4.backgroundColor = kRandomColor;
    [button4 setTitle:@"保存" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(saveProjectActions) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];
    [button4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(60);
        make.top.equalTo(button3.mas_bottom).offset(20);
        make.right.equalTo(self.view).offset(-30);
    }];
    
}

- (void)initBleSearchView {
    //背景图片
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreen_width, KScreen_Height)];
    view.image = ImageNamed(@"mainViewBackground2");
    view.hidden = YES;
    view.userInteractionEnabled = YES;
    [self.view addSubview:view];
    self.tableViewBGView = view;
    
    //飞碟icon
//    UIImageView *leftIcon = [self getMainLeftIconImageView];
    UIImageView *leftIcon = [[UIImageView alloc]init];
    [view addSubview:leftIcon];
    [leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(131);
        make.height.mas_equalTo(90);
        make.left.equalTo(view.mas_left).offset(60);
        make.top.equalTo(view.mas_top).offset(100);
    }];
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
//    tableView.emptyDataSetSource = self;
//    tableView.emptyDataSetDelegate = self;
    [view addSubview:tableView];
    self.tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(KScreen_width/3);
        make.height.mas_equalTo(KScreen_Height/2);
        make.center.equalTo(self.view);
    }];
    
    UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setBackgroundImage:ImageNamed(@"alertDelete") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnActions) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(40);
        make.bottom.equalTo(tableView.mas_top).offset(-40);
        make.left.equalTo(tableView.mas_right).offset(40);
    }];
    
//    __WeakSelf(self);
//    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakself searchActions];
//    }];
    
}
- (void)tableViewBgisShow:(BOOL)isShow {
    self.tableViewBGView.hidden = !isShow;
    if (!isShow) {
        checkIndex = 0;
    }
}

//搜索
- (void)searchActions {

    NSLog(@"搜索 蓝牙 ");
    if ([self bluetoothIsConnected]) {
        NSLog(@" 已经连接了 ，不用在搜索了 ");
        return;
    }
//    if ([BluetoothCentralManager sharedManager].currentCentralManagerState == 11) {
//        NSLog(@" 未开启蓝牙 ");
//        [self showBlueToothAuthAlert];
//        return ;
//    }
    
//    if (self.tableView.mj_header.isRefreshing && [[BluetoothCentralManager  sharedManager].activeCentralManager isScanning]) {
//        NSLog(@" 正在刷新中 ... ");
//        return;
//    }
//
//    if (self.tableViewBGView.hidden == NO || [[BluetoothCentralManager  sharedManager].activeCentralManager isScanning] ) {
//        NSLog(@" 存在 显示视图 ... 或者 扫描中 ... ");
//        return;
//    }
    
//    if (!self.tableView.mj_header.isRefreshing) {
//        [self.tableView.mj_header beginRefreshing];
//    }
//
//    if (![[BluetoothCentralManager  sharedManager].activeCentralManager isScanning]) {
//
//        [[BluetoothCentralManager sharedManager] startScanning];
//        [self.dataArray removeAllObjects];
//        [self.tableView reloadData];
//        [self tableViewBgisShow:YES ];
//        //十秒后停止扫描
//        [self performSelector:@selector(stopScanningAction) withObject:nil afterDelay:6];
//
//    }
 
}

- (void)disConnectedBle {
    
    NSLog(@" 主动 断开连接  disConnectedBle");
//    CBPeripheral *per = [BluetoothCentralManager sharedManager].activePeripheral.activePeripheral;
//    [[BluetoothCentralManager sharedManager] disconnectPeripheral:per];
    
}

- (void)closeBtnActions {
  
//    if (!self.tableViewBGView.isHidden) {
//
//        [[BluetoothCentralManager sharedManager] stopScanning];
//
//        [self.dataArray removeAllObjects];
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView reloadData];
//
//        [self tableViewBgisShow:NO];
//    }

}

- (void)saveProjectActions {
   
    NSLog(@" 保存 项目信息 ");

//    NSDictionary *dict = [self.model toDictionary];
//    [TestData saveLocalTestData:dict];
    
}

// 停止扫描
- (void)stopScanningAction {
    
    NSLog(@"搜索 停止扫描 ");
//    [[BluetoothCentralManager sharedManager] stopScanning];
//
//    NSArray *array  = [[BluetoothCentralManager sharedManager] peripherals];
//    NSLog(@" 搜索到的 蓝牙数据  -%@",array);
   /*
    [self.dataArray removeAllObjects];
    if (array.count > 0) {
        [self.dataArray addObjectsFromArray:array];
    }else {
       
        NSLog(@" 没有搜索到数据 ");
        if ([self isCurrentView] != 0) {
//            [self.tableView reloadEmptyDataSet];
//            [SKProgressHUD showWithStatus:@"没有搜索到蓝牙，请下拉刷重试" andDealy:2];
        }
    }
*/
//    [self tableViewBgisShow:YES];
//    [self.tableView.mj_header endRefreshing];
//    [self.tableView reloadData];
}


#pragma mark:-- 测试视图 end
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellID = @"CellID";
    WebViewBlueToothCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WebViewBlueToothCell" owner:self options:nil] firstObject];
    }
    
//    CBPeripheral *per = self.dataArray[indexPath.row];
//    cell.nameLabel.text = per.name;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    CBPeripheral *per = self.dataArray[indexPath.row];
//    NSLog(@"点击的是 那个 per = %@",per);
//    if (per.state == CBPeripheralStateDisconnected) {
//        [SKProgressHUD showWithStatus:@"连接中..."];
//        [[BluetoothCentralManager sharedManager] connectPeripheral:per];
//    }
}

#pragma mark:-- 初始化视图
- (void)initSubViews {
    
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setBackgroundImage:[UIImage imageNamed:@"backNoraml"] forState:UIControlStateNormal];
    [back setBackgroundImage:[UIImage imageNamed:@"backSelcted"] forState:UIControlStateSelected];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];

    back.frame = CGRectMake(30, 24, 40, 40);
//    [back setBackgroundImage:[UIImage imageNamed:@"backNoraml_black"] forState:UIControlStateNormal];
    [back setBackgroundImage:[UIImage imageNamed:@"backNoraml"] forState:UIControlStateNormal]; //白色
    [self.view addSubview:back];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(40);
        make.top.equalTo(self.view).offset(24);
        make.right.equalTo(self.view).offset(-30);
    }];
    
    
    UILabel* titleL = [[UILabel alloc] init];
    [self.view addSubview:titleL];
    titleL.textColor = kRGB(87, 94, 114);
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor = [UIColor blackColor];
    titleL.font = [UIFont systemFontOfSize:20.0];
    titleL.frame =CGRectMake(0, 60, KScreen_width, 20);
    titleL.hidden = YES;
    titleL.text = @"设置";
    [self.view addSubview:titleL];
    self.titleLabel = titleL;
    if (self.model) {
        titleL.text = self.model.scratchName;
    }else {
       titleL.text = @"创建作品";
    }
    
}

#pragma mark:-- // 返回上个界面 actions
- (void)popToLastVCActions {
  
    if ([self.blueToothStatusTimer isValid]) {
        [self.blueToothStatusTimer invalidate];
        self.blueToothStatusTimer = nil;
    }
     //根据key值清空某个localStorage  localStorage.clear()
    [self evaluateJavaScriptWithStr:@"localStorage.removeItem('title')" completionHandler:^(id _Nullable result, NSError * _Nullable error) {

    }];
    
//    if ([[BluetoothCentralManager sharedManager].activeCentralManager isScanning]) {
//        [[BluetoothCentralManager sharedManager] stopScanning];
//        [BluetoothCentralManager sharedManager].activePeripheral.activePeripheral = nil;
//    }
    [self.navigationController popViewControllerAnimated:YES];
}

//返回到上界面
- (void)backAction {
    
    NSString *method = [NSString stringWithFormat:@"moblileGoBack()"];
    [self evaluateJavaScriptWithStr:method completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
    }];
    [self clickBackActions];
}

#pragma mark: --  webView 加载完成
- (void)loadWebViewDidFinish {
    [super loadWebViewDidFinish];
    
    NSLog(@"ScratchWebView:--加载完成");
//    [self moblile_setBleStatus];
//    [self moblile_setScratchInfor];

    [self fillLocalDataToWebView];
    [self searchActions];
}

//填充标题和 内容sb3
- (void)fillLocalDataToWebView {
    
    if ([self isCurrentView] == 1 ) {
        
        [self setCurrentViewKey:2];
        if (self.localModel.localTitle) {    
            NSString *jsString = [NSString stringWithFormat:@"sendScratchTitle('%@')", self.localModel.localTitle];
            [self evaluateJavaScriptWithStr:jsString completionHandler:^(id  _Nullable result, NSError * _Nullable error) {
                NSLog(@"jsString---- %@  error =%@",result ,error.description);
            }];
        }
        
        if (self.localModel.localContent) {
            
            NSString *jsString2 = [NSString stringWithFormat:@"sendScratchContent('%@')",self.localModel.localContent];
            [self evaluateJavaScriptWithStr:jsString2 completionHandler:^(id  _Nullable result, NSError * _Nullable error) {
                NSLog(@"jsString222 ---- %@  error =%@",result ,error.description);
            }];
        }
    }
    
    
    
}

#pragma mark:--- 蓝牙方法 和 回调
//蓝牙状态改变事件
- (void)bluetoothStateChanged:(NSNotification*)sender{
    
    NSString* status = [sender object];
    NSLog(@"bluetoothStateChanged status = %@",status);
    if ([status isEqualToString:@"connect"]) {
    
        //显示链接的蓝牙名称
//        NSString *blueTooth = [BluetoothCentralManager sharedManager].activePeripheral.nameString;
//        NSLog(@" 蓝牙名称 = %@",blueTooth);
        [self checkConnectStatus];
        
    }else if([status isEqualToString:@"search"]){
        
        
    }else if ([status isEqualToString:@"failToConnect"]){
        
        NSLog(@" 蓝牙 search = 连接失败  ");
        [self checkConnectStatus];
        [SKProgressHUD dismissLoading];
        
    }else if ([status isEqualToString:@"disconnect"]){

        NSLog(@" 蓝牙 断开连接 了 disconnect ");
        [self checkConnectStatus];
    }else if ([status isEqualToString:@"poweredOff"]){
        
        NSLog(@" 蓝牙 断开连接 了 poweredOff");
        [self checkConnectStatus];
    }else if([status isEqualToString:@"didconnect"]){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@" 蓝牙 连接 了 didconnect");
            
            [SKProgressHUD showSuccessWithStatus:@"蓝牙已经连接"];
            [self checkConnectStatus];
            [self tableViewBgisShow:NO];
//            [self moblile_setBleStatus];
        });
        
    }else{
//        [self checkConnectStatus];
    }
}

//蓝牙开关alert
- (void)showBlueToothAuthAlert {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"蓝牙未开启,请打开蓝牙" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ac1 = [UIAlertAction actionWithTitle:@"确定"style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction* ac2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction: ac1];
    [alert addAction:ac2];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

//检测连接状态
- (void)checkConnectStatus {
    
//    if ([BluetoothCentralManager sharedManager].activePeripheral.activePeripheral != nil ) {
//
//        NSLog(@"  您已连接蓝牙 ");
//        [[BluetoothCentralManager sharedManager] addDelegate:self];
//    }else{
//        NSLog(@"  没有连接 ");
//
//    }
    
}

//接收数据回调
/*
 蓝牙返回的数据异常 <ff550004 15312e30 2e302e32 30313830 3730355f 636f6f63 6f6f>
 正常的蓝牙返回的数据 <636f6f63 6f6f>
 */
-(void)bleReceivedData:(NSData *)data {
    
    NSLog(@"--===-- %@ 获取蓝牙数据：%@",NSStringFromClass([self class]),data);
    if (data.length > 0) {// <ff559902 8db0c841>
        NSString* str = [NSString stringWithFormat:@"%@",data];
        
        NSString *str1 = @"<";
        NSString *str2 = @">";
        NSString *str3 = @" ";
        if ([str containsString:str1]) {
            str = [str stringByReplacingOccurrencesOfString:str1 withString:@""];
        }
        if ([str containsString:str2]) {
            str = [str stringByReplacingOccurrencesOfString:str2 withString:@""];
        }
        if ([str containsString:str3]) {
            str = [str stringByReplacingOccurrencesOfString:str3 withString:@""];
        }

        NSMutableString *mutableStr = [NSMutableString string];
        for (int i = 0 ; i < str.length / 2 ; i++ ) {
            NSString *string = [str substringWithRange:NSMakeRange(i*2, 2)];
            [mutableStr appendString:string];
            if (i < str.length/2 - 1) {
                [mutableStr appendString:@","];
            }
        }
        
        [self moblile_sendCmd:mutableStr];
    }
}

- (void)clickBackActions {
    
    [self tapActions];
   
    
}

- (void)cancleButtonAcions {
    
    [self.bgView333 removeFromSuperview];
    self.bgView333 = nil;
    
//    [self.alertDeleteView removeFromSuperview];
//    self.alertDeleteView = nil;
}

#pragma mark:--和CooCoo小车 进行交互
- (void)redLedActions {
    NSLog(@"红灯");
    [self changeColorWithSide:0 R:255 andG:0 andB:0];
    
}

- (void)blackLedActions {
    NSLog(@" 黑色  ");
    [self changeColorWithSide:0 R:0 andG:0 andB:0];
}

//发送灯光颜色数据
-(void)changeColorWithSide:(short)side R:(int)r andG:(int)g andB:(int)b{
//    NSData* data = [self buildColorWithSide:side r:r andg:g andb:b];
//    [[BluetoothCentralManager sharedManager].activePeripheral sendDataMandatory:data];
}

//颜色选择
- (NSData*)buildColorWithSide:(short)side r:(int)r andg:(int)g andb:(int)b{
    unsigned char a[12]={0xff,0x55,0x09,0x04,0x02,0x08,0x00,0x00,0,0,0,0};
    a[8] = side;
    a[9] =  r;
    a[10] = g ;
    a[11] =  b;
    NSData * data = [NSData dataWithBytes:a length:12];
    return data;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
/*
- (ALSDeleteAlertView *)alertDeleteView {
    if (!_alertDeleteView) {
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        
        UIView *bgView11 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreen_width, KScreen_Height)];
        bgView11.backgroundColor = kRGBA(0, 0, 0,0.5) ;
        bgView11.userInteractionEnabled = YES;
        [bgView11 addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActions)]];
        [window addSubview:bgView11];
        self.bgView333 = bgView11;
        
        ALSDeleteAlertView *deletView = [[ALSDeleteAlertView alloc] initWithFrame:CGRectZero];
        [bgView11 addSubview:deletView];
        self.alertDeleteView = deletView;
        CGFloat left_x = 200;
        [deletView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView11.mas_left).offset(left_x);
            make.right.equalTo(bgView11.mas_right).offset(-left_x);
            make.top.equalTo(bgView11.mas_top).offset(left_x*1.2);
            make.bottom.equalTo(bgView11.mas_bottom).offset(-left_x*1.7);
        }];
    }
    return _alertDeleteView;
}

- (void)cancleDeleteButtonAcions {
    
    [self.bgView333 removeFromSuperview];
    self.bgView333 = nil;
    
    [self.alertDeleteView removeFromSuperview];
    self.alertDeleteView = nil;
}
*/
- (void)tapActions {
    
    [self.view endEditing:YES];
}


#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return ImageNamed(@"emptyImage_no_network");
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"点击重新搜索"];
    return string;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    
    NSLog(@"didTapButton ");
//    if (![self.tableView.mj_header isRefreshing]) {
//        [self.tableView.mj_header beginRefreshing];
//    }
    
}


@end
