//
//  NewsTableViewController.m
//  PDFReader
//
//  Created by ChenShuKun on 2019/8/12.
//  Copyright © 2019 ChenShukun. All rights reserved.
//

#import "NewsTableViewController.h"
#import "WebViewController.h"
#import "NewsTableViewCell.h"

@interface NewsTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) NSInteger totalRow ;
@end

@implementation NewsTableViewController

-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray= [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.page = 1;
    [self getDatasWithParams:self.page];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self pullDownActions];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self pullUpActions];
    }];
    
    
}

- (void)getDatasWithParams:(NSInteger)page  {
    
    [SVProgressHUD show];
    NSDictionary *params = @{@"page":@(page),@"rows":@"10"};
    [AFNetworkingManager requestGetUrlString:@"news/getNews" parameters:params successBlock:^(id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        NSArray *data = responseObject[@"data"];
        if (data) {
            [self.dataArray addObjectsFromArray:data];
        }
        [self endRefresh];
        
        
    } failureBlock:^(NSError * _Nonnull error) {
        
        NSLog(@"error  = %@",[error description]);
    }];
}

//下拉刷新
- (void)pullDownActions {
    
    self.page = 1;
    [self.dataArray removeAllObjects];
    [self getDatasWithParams:self.page];
    
}

//上拉加载更多
- (void)pullUpActions {
    self.page ++;
    [self getDatasWithParams:self.page];
}

- (void)endRefresh {
    
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    
    if (self.dataArray.count >= self.totalRow) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else {
        [self.tableView.mj_footer resetNoMoreData];
    }
    
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellID = @"NewsTableViewCell";
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID ];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NewsTableViewCell" owner:nil options:nil]lastObject];
    }
    /*
     "id": 1,
     "title": "莫砺锋教授谈“唐诗苑的入门与探幽”：读诗最后就是读人",
     "url": "http://book.sina.com.cn/news/whxw/2019-08-19/doc-ihytcern1719802.shtml"
     }
     */
    NSDictionary *dict  = self.dataArray[indexPath.row];
    cell.dict = dict;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict  = self.dataArray[indexPath.row];
    
    WebViewController *webView = [[WebViewController alloc]init];
    webView.hidesBottomBarWhenPushed = YES;
    webView.urlString = dict[@"url"];
    [self.navigationController pushViewController:webView animated:YES];
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"d");
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dict =  self.dataArray[indexPath.row];
    //@"isFollow":@"YES",@"isCollection":@"NO"
    NSString *isCareTitle = @"关注";
    NSString *isCare = @"YES";
    if (dict[@"isCare"] && [dict[@"isCare"] isEqualToString:@"YES"]){
        isCareTitle = @"取消关注";
        isCare = @"NO";
    }

    // 自定义左滑显示编辑按钮
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:isCareTitle handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSLog(@" 是否关心了 ");
        
        NSDictionary *dict =  self.dataArray[indexPath.row];
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionaryWithDictionary:dict];
        [dict1 setObject:isCare forKey:@"isCare"];
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:dict1];
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@成功",isCareTitle]];
        [self.tableView reloadData];
        
        
    }];
    rowAction.backgroundColor = [UIColor  redColor];
    NSArray *arr = @[rowAction];
    return arr;
}






@end
