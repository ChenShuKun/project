//
//  SearchViewController.m
//  PDFReader
//
//  Created by ChenShuKun on 2019/8/12.
//  Copyright © 2019 ChenShukun. All rights reserved.
//

#import "SearchViewController.h"
#import "ReaderViewController.h"


@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,ReaderViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@end

@implementation SearchViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray ) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self pullDownActions];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self pullUpActions];
    }];
}

#pragma makr:-- actions
- (IBAction)searchBtnActions:(UIButton *)sender {
    
    NSLog(@"---搜索 ");
    [self searchTFActions:self.searchTF.text];
}

//搜索 actions
- (void)searchTFActions:(NSString *)name {
    
    if (name.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入搜索内容"];
        return;
    }
    
    [self.dataArray removeAllObjects];
    
    [SVProgressHUD show];
    [AFNetworkingManager requestGetUrlString:@"https://www.baidu.com" parameters:@{} successBlock:^(id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        [self.dataArray addObjectsFromArray:[self getArrayData1s]];
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
        
        [self.tableView reloadData];
        [self endRefresh];
        
        if (self.dataArray.count > 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    });
    
    
}

- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
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
    
 
    NSLog(@"dict =%@",dict);
    [self goToPdfReaderViewControllerWithName:dict[@"pafName"]];
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



- (NSArray *)getArrayData1s {
    
    return @[@{@"pafName":@"建立你自己的iOS开发知识体系", @"author":@"于禁",@"price":@"108",@"nowPrice":@"0",@"img":@"001.png",@"title":@"建立你自己的iOS开发知识体系",@"subTitle":@"",},
             @{@"pafName":@"App 启动速度怎么做优化与监控？", @"author":@"张超",@"price":@"78",@"nowPrice":@"0",@"img":@"002.png",@"title":@"App 启动速度怎么做优化与监控？",@"subTitle":@"",},
             @{@"pafName":@"Auto Layout 是怎么进行自动布局的，性能如何？", @"author":@"李大山",@"price":@"97",@"nowPrice":@"0",@"img":@"003.png",@"title":@"Auto Layout 是怎么进行自动布局的，性能如何？",@"subTitle":@"",},
             
             ];
}

@end
