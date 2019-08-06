//
//  SecondViewController.m
//  PDFReader
//
//  Created by alsrobot on 2019/7/26.
//  Copyright © 2019 ChenShukun. All rights reserved.
//

#import "SecondViewController.h"
#import "TableHeaderView.h"
#import "InforViewController.h"
#import "LoginViewController.h"

@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SecondViewController

-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray= [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucceed) name:@"reloadTableViewNSNotification" object:nil];
    
    self.dataArray = [NSMutableArray arrayWithArray:[self getDatas]];

    
    [self initTableViewHeaderView];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
    }];
    
    
}
- (void)loginSucceed {
  
    [self.dataArray addObject:@{@"name":@"退出",@"icon":@"",@"id":@"exit"}];
    [self reloadTableView];
}

- (void)reloadTableView {

    self.tableView.tableHeaderView = nil;
    [self initTableViewHeaderView];
    [self.tableView reloadData];
}

- (void)initTableViewHeaderView {

    TableHeaderView *headerView = [[TableHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 230)];
    self.tableView.tableHeaderView = headerView;
    headerView.block = ^(NSDictionary * _Nonnull dict, BOOL isLogIn) {
        
        [self goToInFor];
    };
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID ];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    NSDictionary *dict =  self.dataArray[indexPath.row];
    cell.textLabel.text = dict[@"name"];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict =  self.dataArray[indexPath.row];
    NSLog(@"name = %@",dict[@"name"]);
    if ([dict[@"id"] isEqualToString:@"exit"]) {
        
        [self exitAlertActions];
        
    }else {
        
        [self jumpToWithStoryBoardID:dict[@"id"]];
    }
}

#pragma mark:-- 退出操作
- (void)exitAlertActions {
    //第三个参数是对话框的类型（分为操作表类型 UIAlertControllerStyleActionSheet 和 警告框 UIAlertControllerStyleAlert ）
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil     message:@"确定要退出吗 ?" preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        NSLog(@"tap no button");
    }];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^ void (UIAlertAction *action){
        NSLog(@"tap yes button");
        [self exitAction];
    }];
    
    [alertController addAction:noAction];
    [alertController addAction: yesAction];
    
    //以模态框的形式显示
    [self presentViewController:alertController animated:true completion:^(){
        NSLog(@"success");
    }];
    
}

- (void)exitAction {
    
    [SVProgressHUD show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.dataArray removeLastObject];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"123" forKey:@"userName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [SVProgressHUD showSuccessWithStatus:@"登出成功"];
        
        [self reloadTableView];
    });
}

- (NSArray *)getDatas {
    return @[ @{@"name":@"等级",@"icon":@"",@"id":@"levelViewConroller"},
              @{@"name":@"书单",@"icon":@"",@"id":@"bookViewConroller"},
              @{@"name":@"评论",@"icon":@"",@"id":@"commentViewConroller"},
              @{@"name":@"关注",@"icon":@"",@"id":@"attentionViewConroller"},
              @{@"name":@"收藏",@"icon":@"",@"id":@"collectViewConroller"},
              @{@"name":@"关于",@"icon":@"",@"id":@"aboutViewController"},
               ];
}

#pragma mark:-- 跳转
- (void)jumpToWithStoryBoardID:(NSString *)boardID {
    //将我们的storyBoard实例化，“Main”为StoryBoard的名称
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //将第二个控制器实例化，"SecondViewController"为我们设置的控制器的ID
    UIViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:boardID];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToInFor {
    
    //没有登录 去登录 ,否则看个人信息
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    BOOL hasLogIn =  [[SKPDFReader sharedSingleton] hasSaveUserName:name];
    if (hasLogIn) {
        NSLog(@"已经登录 ");
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        InforViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"InforViewControllersss"];
        vc.inforDict = [[SKPDFReader sharedSingleton] getInforData:name];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
        NSLog(@"没登录 ");

        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"LoginViewControllerSSS"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
