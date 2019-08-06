//
//  SecondViewController.m
//  PDFReader
//
//  Created by alsrobot on 2019/7/26.
//  Copyright © 2019 ChenShukun. All rights reserved.
//

#import "SecondViewController.h"

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

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    self.dataArray = [NSMutableArray arrayWithArray:[self getDatas]];
    
    
    [self initTableViewHeaderView];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
    }];
    
    
}

- (void)initTableViewHeaderView {
    
    
    UIView  *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    headerView.backgroundColor = [UIColor redColor];
    self.tableView.tableHeaderView = headerView;
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
    
    [self jumpToWithStoryBoardID:dict[@"id"]];

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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
