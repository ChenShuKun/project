//
//  WantToKnowViewController.m
//  LearnDemo
//
//  Created by alsrobot on 2020/1/6.
//  Copyright © 2020 Chenshukun. All rights reserved.
//

#import "WantToKnowViewController.h"
#import "KnowTableViewCell.h"
#import "WantKnowModel.h"
#import "FullScreenViewController.h"
#import "MJRefresh.h"

@interface WantToKnowViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,weak) UITableView *tableView;

@end

@implementation WantToKnowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray array];
    NSMutableArray *array = [WantKnowModel getDataModel];
    [self.dataArray addObjectsFromArray:array];
    
    [self initTableView];
    
    
    [self initTable_footerView];
}

- (void)initTableView {
    
    UITableView *tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableview.dataSource = self;
    tableview.delegate = self;
    [self.view addSubview:tableview];
    self.tableView = tableview;

    UIView *footer = [[UIView alloc]init];
    tableview.tableFooterView = footer;
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
}

- (void)initTable_footerView {
    
    typeof(self) weakself = self;
    self.tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself pullDownRefreshAction];
    }];
    self.tableView.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakself pullUpRefreshAction];
    }];
}
#pragma mark:-- 下来刷新和上拉加载
//下拉刷新获取最新数据
- (void)pullDownRefreshAction {
    NSLog(@"下拉刷新 ");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self endRefreshing];
    });
}

//上拉获取更多 数据
- (void)pullUpRefreshAction {
    NSLog(@"上拉获取更多");
    
    NSMutableArray *array = [WantKnowModel getDataModel];
    [self.dataArray addObjectsFromArray:array];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self endRefreshing];
    });
}

- (void)endRefreshing {
    
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    
    
    [self.tableView reloadData];
    
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KnowTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"KnowTableViewCellID"];
    if (!cell) {
        cell =  [[NSBundle mainBundle]loadNibNamed:@"KnowTableViewCell" owner:self options:nil].firstObject;
    }
    
    WantKnowModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    __WeakSelf(self);
    cell.zanBlock = ^(UIButton * _Nonnull button, WantKnowModel * _Nonnull model) {
        [weakself zanButtonAction:button indexPath:indexPath];
    };
    cell.collectionBlock = ^(UIButton * _Nonnull button, WantKnowModel * _Nonnull model) {
        [weakself collectionButtonAction:button indexPath:indexPath];
    };
    return cell;
}

- (void)zanButtonAction:(UIButton *)button indexPath:(NSIndexPath *)indexPath {

    WantKnowModel *model = self.dataArray[indexPath.row];
    if (model.isZan != 0) {
        model.isZan = 0;
    }else {
        model.isZan = 1;
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)collectionButtonAction:(UIButton *)button indexPath:(NSIndexPath *)indexPath  {
    
    WantKnowModel *model = self.dataArray[indexPath.row];
    if (model.isCollect != 0) {
        model.isCollect = 0;
    }else {
        model.isCollect = 1;
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 173;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WantKnowModel *model = self.dataArray[indexPath.row];
    NSLog(@"name = %@",model.playUrl);
    
   [self initPlayerWithUrl:model.playUrl andIndexPath:indexPath];
    
}


- (void)initPlayerWithUrl:(NSString *)urlStr andIndexPath:(NSIndexPath *)indexPath {
 
    FullScreenViewController *player = [[FullScreenViewController alloc]init];
    player.videoUrl = urlStr;
    [self.navigationController pushViewController:player animated:YES];
    
}


- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
