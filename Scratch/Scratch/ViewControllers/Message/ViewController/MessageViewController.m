//
//  MessageViewController.m
//  LearnDemo
//
//  Created by alsrobot on 2020/1/7.
//  Copyright © 2020 Chenshukun. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "MessageModel.h"
#import "MJRefresh.h"
#import "AlertView.h"

@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,weak) UITableView *tableView;
@property (nonatomic ,strong) AlertView *alertView;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray array];
    NSMutableArray *array = [MessageModel getDataModel];
    [self.dataArray addObjectsFromArray:array];
    
    [self initTableView];
    [self initTable_footerView];
    
}

- (void)viewDidLayoutSubviews {
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

- (void)initTableView {
    
    UITableView *tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    self.tableView = tableview;
    
    
    UIView *footer = [[UIView alloc]init];
    tableview.tableFooterView = footer;
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
    
    NSMutableArray *array = [MessageModel getDataModel];
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
    
    MessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTableViewCellID"];
    if (!cell) {
        cell =  [[NSBundle mainBundle]loadNibNamed:@"MessageTableViewCell" owner:self options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    MessageModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 122+4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MessageModel *model = self.dataArray[indexPath.row];
    NSLog(@"name = %@",model.content);
    
    if (self.alertView==nil) {
        AlertView *views = [[AlertView alloc] initWithFrame:CGRectZero];
        self.alertView = views;
    }
    [self.alertView reSetTitle:model.title];
    [self.alertView reSetContentText:model.content];
    [self.alertView alertShow];
   
    
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}




@end
