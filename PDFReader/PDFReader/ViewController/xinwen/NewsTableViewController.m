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

    
    [self getDatasWithParams:nil];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self pullDownActions];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self pullUpActions];
    }];
    
    
}
- (void)testData {
    /*
     
     self.titleLable.text = dict[@"title"];
     self.contentLabel.text = dict[@"content"];
     self.sourceLabel.text = dict[@"source"];
     self.careCountLabel.text = [NSString stringWithFormat:@"%@人关心",dict[@"careCount"]];
     self.timeLabel.text = dict[@"time"];
     */
    for (int i = 0; i <10; i++) {
        NSString *care = @"YES";
        NSString *content = @" 阿斯兰的激发了的房间案例的";
        if (i%2==0) {
            care = @"NO";
            content = @"大家发了肯德基疯狂夺金佛奥飓风破我金佛全文我解放啦是可敬的法拉盛  撒娇东方丽景阿斯蒂芬 怕啥积分破案件发假发票 就是批发价";
        }
        NSDictionary *dict = @{@"index":@(i),
                               @"isCare":care,
                               @"title":@"我是标题1111",
                               @"content":content,
                               @"source":@"北京电视台",
                               @"careCount":@(i),
                               @"time":@"08/17 12:34:22",
                               @"detailUrl":@"http://www.baidu.com"
                               };
        [self.dataArray addObject:dict];
    }
}


- (void)getDatasWithParams:(NSDictionary *)params {
    
    [SVProgressHUD show];
    [AFNetworkingManager requestGetUrlString:@"https://www.baidu.com" parameters:@{} successBlock:^(id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        [self testData];
        
        [self.tableView reloadData];
        
    } failureBlock:^(NSError * _Nonnull error) {
        
        NSLog(@"error  = %@",[error description]);
    }];
}

//下拉刷新
- (void)pullDownActions {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self endRefresh];
    });
}

//上拉加载更多
- (void)pullUpActions {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self testData];
        
        [self.tableView reloadData];
        [self endRefresh];
        
        
    });
}

- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    if (self.dataArray.count > 32) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
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
    
    NSDictionary *dict  = self.dataArray[indexPath.row];
    cell.dict = dict;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict  = self.dataArray[indexPath.row];
    
    WebViewController *webView = [[WebViewController alloc]init];
    webView.urlString = dict[@"detailUrl"];
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




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
