//
//  CloudViewController.m
//  Scratch
//
//  Created by ChenShuKun on 2019/12/30.
//  Copyright © 2019 ChenShuKun. All rights reserved.
//

#import "CloudViewController.h"
#import "CloudCollectionViewCell.h"
#import "CloudModel.h"

static NSString *CellID = @"CloudCollectionViewCellID" ;

//基本变量
#define KMainViewLeft  180
#define KMainViewTop   240
#define KMainViewBtnViewHeight 50
#define KMainViewBackGrondViewWidth 20
/** 获取屏幕尺寸 */
#define KScreen_width  [UIScreen mainScreen].bounds.size.width
#define KScreen_Height  [UIScreen mainScreen].bounds.size.height
#define __WeakSelf(type)  __weak typeof(type) weak##type = type;


@interface CloudViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectView1;
@property (nonatomic, strong) NSMutableArray *dataArray1;

@end

@implementation CloudViewController {
    CGFloat space; //间距
    CGFloat item_width; //item 宽度
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    if (self.dataArray1.count == 0) {
    
        [self.collectView1.mj_header beginRefreshing];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initConfig];
    [self.view addSubview:self.collectView1];
    
//    [self fillData];
//    [self.collectView1 reloadData];
    
    [self initTable_footerView];
}

- (void)initTable_footerView {
    
    typeof(self) weakself = self;
    self.collectView1.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself pullDownRefreshAction];
    }];
    
//    self.collectView1.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [weakself pullUpRefreshAction];
//    }];
    
}

#pragma mark:-- 下来刷新和上拉加载
//下拉刷新获取最新数据
- (void)pullDownRefreshAction {
   
    NSLog(@"下拉刷新 ");
    [self getCloudData];
}

//上拉获取更多 数据
- (void)pullUpRefreshAction {

    NSLog(@"上拉获取更多");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self endRefreshing];
    });
}

- (void)endRefreshing {

    [self.collectView1.mj_footer endRefreshing];
    [self.collectView1.mj_header endRefreshing];

    [self.collectView1 reloadData];
    
}
//停止刷新
- (void)collectionViewEndRefreshing {
    
    [self.collectView1.mj_footer endRefreshing];
    [self.collectView1.mj_header endRefreshing];

    [self.collectView1 reloadData];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.collectView1.frame = self.view.bounds;
}


#pragma mark:-- 基础的配置
- (void)initConfig {
    
    space = 15;
    
    CGFloat frame_x = mainView_left_width + 10;
    item_width = (KScreen_width - frame_x - 20 - 4*space )/3;
}

- (void)fillData {
    
    NSMutableArray *data = [CloudModel getCloudData];
    [self.dataArray1 addObjectsFromArray:data];
}

#pragma mark - Lazy load
- (UICollectionView *)collectView1{
    if (!_collectView1) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = space;
        layout.minimumInteritemSpacing = space;
        layout.itemSize = CGSizeMake(60, 60);
        layout.sectionInset = UIEdgeInsetsMake(space, space, space, space);;
        
        
        _collectView1 = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectView1.backgroundColor = [UIColor clearColor];
        _collectView1.showsVerticalScrollIndicator = NO;
        _collectView1.delegate = self;
        _collectView1.dataSource = self;
        [_collectView1 registerNib:[UINib nibWithNibName:@"CloudCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:CellID];
    }
    
    return _collectView1;
}

- (NSMutableArray *)dataArray1 {
    if (!_dataArray1) {
        _dataArray1 = [NSMutableArray array];
    }
    return _dataArray1;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray1.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    CloudCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    
    CloudModel *model= self.dataArray1[indexPath.row];
    cell1.model = model;
    __WeakSelf(self);
    cell1.buttonActions = ^(UIButton * _Nonnull button, CloudModel * _Nonnull model) {
        
        [weakself deleteButtonAction:button andModel:model andIndexPath:indexPath];
    };
    return cell1;
}

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(item_width, item_width);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(space, space, space, space);
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CloudModel *model= self.dataArray1[indexPath.row];
    NSLog(@"aaa = %@",model.titleStr);

}


#pragma mark - actions
- (void)deleteButtonAction:(UIButton *)button andModel:(CloudModel *)model andIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"deleteButtonAction  = %@",model.titleStr);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"确定要删除 ?" preferredStyle: UIAlertControllerStyleAlert];
       
       UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
           NSLog(@"tap no button");
       }];
       
       UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^ void (UIAlertAction *action){

           
           NSLog(@"---- 发送网络请求 然后删除 ");
           [self deleteSucceed:@{} indexPath:indexPath];
       }];
       
       [alertController addAction:noAction];
       [alertController addAction: yesAction];
       
       //以模态框的形式显示
       [self presentViewController:alertController animated:true completion:^(){
           NSLog(@"success");
       }];
}


- (void)deleteSucceed:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath {
    
    
    
    [self.dataArray1 removeObjectAtIndex:indexPath.row];
    [self.collectView1 reloadData];
}



#pragma mark:--API
#pragma mark:--和服务器进行数据交互 （获取云端数据）
- (void)getCloudData {
    
    if (![UserManager userIsLogin]) {
        NSLog(@" 用户没登录  ");
        [self collectionViewEndRefreshing];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@mobile_student/get_scratch",BASEURL];
    NSDictionary *params = @{@"student_id":[UserManager userInfo].userid,
                             @"school_id":@([UserManager userInfo].school_id)
                             };
    
    [ScratchNetWork NetworkPOSTURL:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@" 成功 返回数据 = %@",responseObject);
        if ([ScratchNetWork isValidResponse:responseObject]) {
            // 数据处理
            NSMutableArray *dataArr = [CloudModel getModelArrayWithDict:responseObject];
            if (dataArr) {
                [self.dataArray1 removeAllObjects];
                [self.dataArray1 addObjectsFromArray:dataArr];
            }
            [self collectionViewEndRefreshing];
        }else {
            [self collectionViewEndRefreshing];
            [SKProgressHUD showErrorWithStatus:[ScratchNetWork getToastMsg:responseObject]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self collectionViewEndRefreshing];
    }];
    
    
}


@end
