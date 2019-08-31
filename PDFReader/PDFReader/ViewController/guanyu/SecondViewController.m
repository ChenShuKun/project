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

    if ([UserDefault isLogIn]) {
        [self loginSucceed];
    }
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
  
    NSDictionary *dict = @{@"name":@"退出",@"icon":@"",@"id":@"exit"};
    if (![self.dataArray containsObject:dict]) {
        [self.dataArray addObject:dict];
        [self reloadTableView];
    }
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
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
        
    }
    
    NSDictionary *dict =  self.dataArray[indexPath.row];

    cell.imageView.image = [UIImage imageNamed:dict[@"icon"]];
    //调整cell.imageView大小
    CGSize itemSize = CGSizeMake(24, 24);//希望显示的大小
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    cell.textLabel.text = dict[@"name"];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict =  self.dataArray[indexPath.row];
    NSLog(@"name = %@",dict[@"name"]);
    if ([dict[@"id"] isEqualToString:@"exit"]) {
        
        [self exitAlertActions];
    }else {
        NSLog(@"--%@",@(indexPath.row));
        if (![UserDefault isLogIn]) {
            
            if (indexPath.row == 1 || indexPath.row == 5) {
                [self jumpToWithStoryBoardID:dict[@"id"]];
            }else {
                 [self goToLogin];
            }
        }else {
            [self jumpToWithStoryBoardID:dict[@"id"]];
        }
       
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        
        [UserDefault removeToken];
        
        [SVProgressHUD showSuccessWithStatus:@"登出成功"];
        
        [self reloadTableView];
    });
}



- (NSArray *)getDatas {
    return @[ @{@"name":@"等级",@"icon":@"dengji.png",@"id":@"levelViewConroller"},
              @{@"name":@"书单",@"icon":@"shudan.png",@"id":@"bookViewConroller"},
              @{@"name":@"关注作者",@"icon":@"guanzhu_zuozhe.png",@"id":@"AttentionAuther"},
              @{@"name":@"关注",@"icon":@"guanzhu.png",@"id":@"attentionViewConroller"},
              @{@"name":@"收藏",@"icon":@"shoucang.png",@"id":@"collectViewConroller"},
              @{@"name":@"关于",@"icon":@"guanyuwomen.png",@"id":@"aboutViewController"},
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
    if ([UserDefault isLogIn]) {
        NSLog(@"已经登录 ");
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        InforViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"InforViewControllersss"];
        vc.inforDict = [[SKPDFReader sharedSingleton] getInforData:@"244410894@qq.com"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
        NSLog(@"没登录 ");
        [self goToLogin];
    }
}

- (void)goToLogin {
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"LoginViewControllerSSS"];
    [self presentViewController:vc animated:YES completion:nil];
    
}

@end
