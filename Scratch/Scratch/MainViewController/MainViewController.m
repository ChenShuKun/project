//
//  MainViewController.m
//  Scratch
//
//  Created by ChenShuKun on 2019/12/30.
//  Copyright © 2019 ChenShuKun. All rights reserved.
//

#import "MainViewController.h"
#import "LocalViewController.h"
#import "CloudViewController.h"
#import "WantToKnowViewController.h"
#import "MessageViewController.h"
#import "MainLeftTableViewCell.h"
#import "MainLeftModel.h"
#import "LoginViewController.h"


@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) NSMutableArray *viewControllViewsArray;
@property (weak, nonatomic) IBOutlet UIButton *goLoginBtn;
@property (strong, nonatomic) UIButton *userInforBtn;

@end

@implementation MainViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadIsLoginOrUserInfo];
}


- (UIButton *)userInforBtn {
    if (!_userInforBtn) {
        
        _userInforBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _userInforBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_userInforBtn addTarget:self action:@selector(goLogoutButtonActions:) forControlEvents:UIControlEventTouchUpInside];
        _userInforBtn.backgroundColor = [UIColor mainColor];
        [self.view addSubview:_userInforBtn];
        [_userInforBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(140);
            make.height.mas_equalTo(34);
            make.top.equalTo(self.view.mas_top).offset(44);
            make.right.equalTo(self.view.mas_right).offset(-10);
        }];
    }
    return _userInforBtn;
}

- (void)loadIsLoginOrUserInfo {
    
    if ([UserManager userIsLogin]) {
        
        self.userInforBtn.hidden = NO;
        self.goLoginBtn.hidden = YES;
        [self loadUserInforActions];
    }else {
        self.userInforBtn.hidden = YES;
        self.goLoginBtn.hidden = NO;
    }
}

- (void)viewDidLayoutSubviews {
    
    self.userInforBtn.layer.cornerRadius = self.userInforBtn.frame.size.height /2;
    self.userInforBtn.clipsToBounds = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStatus:) name:REACHABILITYSTATUS_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goLoginViewController) name:GOLOGINACTIONS_NOTIFICATION object:nil];
    
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    UIImageView *imagesss = [[UIImageView alloc]initWithFrame:CGRectMake(statusRect.origin.x-2, statusRect.origin.y, mainView_left_width+2, statusRect.size.height+ KScreen_Height)];
    imagesss.image = [UIImage imageNamed:@"mainView_left_bg"];
    [self.view addSubview:imagesss];
    [self.view insertSubview:imagesss atIndex:0];
    
    
    [self initSubViews];
    [self loadSubViewControllerssss];

}

- (void)initSubViews {
     
    self.dataArray = [NSMutableArray arrayWithArray:[MainLeftModel getModelArray]];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:(UITableViewScrollPositionNone)];
    
    [self.tableView reloadData];
    
}

- (void)loadSubViewControllerssss {
    
    self.viewControllViewsArray = [NSMutableArray array];

    LocalViewController *local = [[LocalViewController alloc] init];
    
    CloudViewController *cloud = [[CloudViewController alloc] init];

    WantToKnowViewController *wantToKnow = [[WantToKnowViewController alloc]init];

    MessageViewController *message = [[MessageViewController alloc]init];

   [self.viewControllViewsArray addObject:local];
   [self.viewControllViewsArray addObject:cloud];
   [self.viewControllViewsArray addObject:wantToKnow];
   [self.viewControllViewsArray addObject:message];
    
    [self addChildViewController:local];
    [self addChildViewController:cloud];
    [self addChildViewController:wantToKnow];
    [self addChildViewController:message];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self loadViewssss:indexPath];

}


- (void)netWorkStatus:(NSNotification *)notifica {
    
    NSLog(@"object = %@",notifica.object);
    NSInteger status = [notifica.object[kcode] integerValue];
    if (status != -1) {
//        [self updateAppActions];
    }
}

//退出登录
- (IBAction)goLogoutButtonActions:(UIButton *)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"确定要退出登录 ?" preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        NSLog(@"tap no button");
    }];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^ void (UIAlertAction *action){

        [self logOuntSucceedActions];
    }];
    
    [alertController addAction:noAction];
    [alertController addAction: yesAction];
    
    //以模态框的形式显示
    [self presentViewController:alertController animated:true completion:^(){
        NSLog(@"success");
    }];
 
}


// 退出成功 操作
- (void)logOuntSucceedActions {

    [SKProgressHUD showSuccessWithStatus:@"退出登录成功"];
    BOOL succeed =[UserManager clearUserInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadIsLoginOrUserInfo];
    });
    NSLog(@"退出以后 是否删除成功 =- %@",@(succeed));
}

#pragma mark:-- UITableView DataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    for (MainLeftModel *modelss in self.dataArray) {
        modelss.isSelected = 0;
    }
    
    MainLeftModel *model = self.dataArray[indexPath.row];
    model.isSelected = 1;
    NSLog(@" name = %@",model.title);
    
    for (UIView *subView in self.view.subviews) {
        BOOL isView = [NSStringFromClass([subView class]) isEqualToString:@"UIView"];
        if (isView && subView.tag != 0) {
           [subView removeFromSuperview];
        }
    }
    [self loadViewssss:indexPath];
    
    [tableView reloadData];
}

- (NSInteger)getCurrentIndexPath {
    
    for (UIView *subView in self.view.subviews) {
        BOOL isView = [NSStringFromClass([subView class]) isEqualToString:@"UIView"];
        if (isView && subView.tag != 0) {
            return subView.tag;
        }
    }
    return 0;
}

- (void)loadViewssss:(NSIndexPath *)indexPath {
    
    UIViewController *controller = (UIViewController *)self.viewControllViewsArray[indexPath.row];
     
    
    CGFloat frame_x = mainView_left_width + 10;
    CGFloat navigationBarAndStatusBarHeight =  [[UIApplication sharedApplication] statusBarFrame].size.height;
     CGFloat frame_y = 40 + navigationBarAndStatusBarHeight + 40;

     controller.view.frame = CGRectMake( frame_x, frame_y, self.view.frame.size.width - frame_x - 20, self.view.frame.size.height - frame_y-20);
     controller.view.tag = indexPath.row + 100;
    
//    [(LocalViewController *)controller firstLoadLocalData];
    
     [self.view addSubview:controller.view];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
};

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    NSLog(@"MainViewController cellForRowAtIndexPath");
    MainLeftTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MainLeftTableViewCell"];
    if (!cell) {
        cell =  [[NSBundle mainBundle]loadNibNamed:@"MainLeftTableViewCell" owner:self options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    MainLeftModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (IBAction)loginButtonActions:(UIButton *)sender {

    
    [self goLoginViewController];
}

//登录多功能了
- (void)goLoginViewController {
    
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [UIView animateWithDuration:0.3 animations:^{
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    } completion:^(BOOL finished) {
        
    }];
    
    CGFloat Kview_width = self.view.frame.size.width;
    CGFloat Kview_height = self.view.frame.size.height;
    LoginViewController *login = [[LoginViewController alloc]init];
    login.view.frame = CGRectMake(Kview_width/3 * 2 - 100, 0, Kview_width/3 + 100, Kview_height);
    if (![self.childViewControllers containsObject:login]) {
        [self addChildViewController:login];
    }
    [self.view addSubview:login.view];
    
    CGFloat login_W =  Kview_width/3 + 100;
    CGFloat login_h =  Kview_height;
    login.view.frame = CGRectMake(Kview_width, 0, login_W, login_h);
    [UIView animateWithDuration:0.3 animations:^{
        login.view.frame = CGRectMake(Kview_width/3 * 2 , 0, login_W, login_h);
        [UIView animateWithDuration:0.3 animations:^{
            login.view.frame = CGRectMake(Kview_width/3 * 2 - 100, 0, login_W, login_h);
        }];
    }];
    
    login.block = ^(NSString * _Nonnull str) {
        
        if ([str isEqualToString:@"1"]) {
            [view removeFromSuperview];
            [self loadIsLoginOrUserInfo];
        }
    };
    
}

//加载 用户的 信息
- (void)loadUserInforActions {
    
    UserInfor *userInfo = [UserManager userInfo];
    [self.userInforBtn setTitle:userInfo.real_name forState:UIControlStateNormal];
    
}


#pragma makr:--- NetWork
- (void)updateAppActions {
    
    if (![ScratchNetWork isNetworkAvailable]) {
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@mobile_student/update",BASEURL];
   // __WeakSelf(self);
    [ScratchNetWork NetworkPOSTURL:url parameters:@{} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@" 成功 返回数据 = %@",responseObject);
        
         if ([ScratchNetWork isValidResponse:responseObject]) {
      
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

@end
