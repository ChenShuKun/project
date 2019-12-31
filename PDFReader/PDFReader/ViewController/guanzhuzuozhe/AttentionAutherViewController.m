//
//  AttentionAutherViewController.m
//  PDFReader
//
//  Created by ChenShuKun on 2019/8/22.
//  Copyright © 2019 ChenShukun. All rights reserved.
//

#import "AttentionAutherViewController.h"
#import "ReaderViewController.h"


@interface AttentionAutherViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) NSInteger totalRow ;

@end

@implementation AttentionAutherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
    self.dataArray = [NSMutableArray array];
    
    self.page = 1;
    [self getDatasWithParams:self.page];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self pullDownActions];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self pullUpActions];
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
- (void)initTableView {
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    self.tableView = tableView;
    [self.view addSubview:tableView];
}


#pragma mark:-- 收藏
- (void)getDatasWithParams:(NSInteger)page {
//http://127.0.0.1:8888/page/getPageInfoByAuthor?token=aef44ddfbed1168480951c93984e84d1&page=1&rows=10

    NSDictionary *dict = @{@"page":@(page),@"rows":@10};
    [SVProgressHUD show];
    [AFNetworkingManager requestGetUrlString:@"page/getPageInfoByAuthor" parameters:dict successBlock:^(id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        NSArray *data = responseObject[@"data"];
        self.totalRow = [responseObject[@"totalRow"] integerValue];
        if (data) {
            [self.dataArray addObjectsFromArray:data];
        }
        
        [self endRefresh];
    } failureBlock:^(NSError * _Nonnull error) {
        
        NSLog(@"error  = %@",[error description]);
        [self endRefresh];
    }];
}

- (void)endRefresh {
    
    [self.tableView reloadData];
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    if (self.dataArray.count == 0 || self.totalRow == 0) {
        
        self.tableView.hidden = YES;
    }else {
        
        self.tableView.hidden = NO;
    }
    
    if (self.dataArray.count >= self.totalRow) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else {
        [self.tableView.mj_footer resetNoMoreData];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID ];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    NSDictionary *dict =  self.dataArray[indexPath.row];
    
    //iOS UITableViewCell 的 imageView大小更改
    cell.imageView.image = [UIImage imageNamed:dict[@"img"]];
    
    CGSize itemSize = CGSizeMake(120, 90);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0, 10, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    cell.textLabel.text = dict[@"pafName"];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.numberOfLines = 2;
    
    NSString *detail = [NSString stringWithFormat:@"原价: %@元 ，现价: %@元",dict[@"price"],dict[@"nowPrice"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n作者: %@",detail,dict[@"author"]];
    cell.detailTextLabel.numberOfLines = 2;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary *dict =  self.dataArray[indexPath.row];
    
    [self goToPdfReaderViewControllerWithName:dict[@"pafName"]];
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
    
    NSString *isFollowTitle = @"关注";
    NSString *isFollow = @"1";
    if (dict[@"isFollow"] && [dict[@"isFollow"] integerValue] == 1 ){
        isFollowTitle = @"取消关注";isFollow = @"0";
    }
    
    // 自定义左滑显示编辑按钮
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"取消关注作者" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSLog(@" 是否关注了 ");
        [self changeCollectionOrFollowKey:@"isFollow" value:isFollow Message:isFollowTitle indexPath:indexPath];
        
    }];
    rowAction.backgroundColor = [UIColor greenColor];
    NSArray *arr = @[rowAction];
    return arr;
}


#pragma mark:-- 是否关注了 // 是否收藏了
- (void)changeCollectionOrFollowKey:(NSString *)keyStr value:(NSString *)value Message:(NSString *)message indexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict =  self.dataArray[indexPath.row];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:dict[@"author"] forKey:@"author"];
    [params setObject:@(0) forKey:@"isFollow"];
    
    [SVProgressHUD show];
    [AFNetworkingManager requestGetUrlString:@"page/updateAuthor" parameters:params successBlock:^(id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        if ([responseObject[@"code"] integerValue] == 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [SVProgressHUD showSuccessWithStatus:@"取消关注作者成功"];
                [self.dataArray removeObjectAtIndex:indexPath.row];
                [self endRefresh];
            });
            
            
        }else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
        NSLog(@"error  = %@",[error description]);
        
    }];
    
}




#pragma mark:--- 点击进行 阅读
- (void)goToPdfReaderViewControllerWithName:(NSString *)pdfName {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:pdfName ofType:@"pdf"];
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    //    NSArray *pdfs = [[NSBundle mainBundle] pathsForResourcesOfType:@"pdf" inDirectory:nil];
    //    NSString *filePath = [pdfs firstObject]; assert(filePath != nil); // Path to first PDF file
    
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    document.fileNamess = pdfName;
    if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
    {
        ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        
        readerViewController.delegate = self; // Set the ReaderViewController delegate to self
        
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
        
        [self.navigationController pushViewController:readerViewController animated:YES];
        
#else // present in a modal view controller
        
        readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self presentViewController:readerViewController animated:YES completion:NULL];
        
#endif // DEMO_VIEW_CONTROLLER_PUSH
    }
    else // Log an error so that we know that something went wrong
    {
        NSLog(@"%s [ReaderDocument withDocumentFilePath:'%@' password:'%@'] failed.", __FUNCTION__, filePath, phrase);
    }
}

#pragma mark - ReaderViewControllerDelegate methods

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
    
    [self.navigationController popViewControllerAnimated:YES];
    
#else // dismiss the modal view controller
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
#endif // DEMO_VIEW_CONTROLLER_PUSH
}

@end
