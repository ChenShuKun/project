//
//  CollectViewController.m
//  PDFReader
//
//  Created by ChenShuKun on 2019/8/2.
//  Copyright © 2019 ChenShukun. All rights reserved.
//

#import "CollectViewController.h"
#import "ReaderViewController.h"


@interface CollectViewController ()<UITableViewDelegate,UITableViewDataSource,ReaderViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) NSInteger totalRow ;
@end

@implementation CollectViewController

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
    //http://127.0.0.1:8888/page/getPageInfoByCollcetion?token=aef44ddfbed1168480951c93984e84d1&page=1&rows=10

    NSDictionary *dict = @{@"page":@(page),@"rows":@10};
    [SVProgressHUD show];
    [AFNetworkingManager requestGetUrlString:@"page/getPageInfoByCollcetion" parameters:dict successBlock:^(id  _Nonnull responseObject) {
        
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
    /*
     {
     author = "\U4e8e\U7981";
     id = 1;
     img = "001.png";
     isCollection = 0;
     isFollow = 1;
     nowPrice = 0;
     pafName = "\U5efa\U7acb\U4f60\U81ea\U5df1\U7684iOS\U5f00\U53d1\U77e5\U8bc6\U4f53\U7cfb";
     price = 108;
     subTitle = "";
     title = "\U5efa\U7acb\U4f60\U81ea\U5df1\U7684iOS\U5f00\U53d1\U77e5\U8bc6\U4f53\U7cfb";
     }
     */
    NSString *isCollectionTitle = @"收藏";
    NSString *isCollection = @"1";
    if (dict[@"isCollection"] && [dict[@"isCollection"] integerValue] == 1){
        isCollectionTitle = @"取消收藏";isCollection = @"0";
    }
    UITableViewRowAction *rowActionSec = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault  title:isCollectionTitle handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSLog(@" 是否收藏了 ");
        [self changeCollectionOrFollowKey:@"isCollection" value:isCollection Message:isCollectionTitle indexPath:indexPath];
    }];
    
    rowActionSec.backgroundColor = [UIColor redColor];
    NSArray *arr = @[rowActionSec];
    return arr;
}


#pragma mark:-- 是否关注了 // 是否收藏了
- (void)changeCollectionOrFollowKey:(NSString *)keyStr value:(NSString *)value Message:(NSString *)message indexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict =  self.dataArray[indexPath.row];
    NSLog(@"type  == %@",keyStr);
    NSString *urlString = @"";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
   
    urlString = @"page/updateCollection";
    [params setObject:dict[@"id"] forKey:@"id"];
    NSInteger isCollect = [dict[@"isCollection"] integerValue] == 0 ? 1:0;
    [params setObject:@(isCollect) forKey:@"isCollection"];
    
    [SVProgressHUD show];
    [AFNetworkingManager requestGetUrlString:urlString parameters:params successBlock:^(id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        if ([responseObject[@"code"] integerValue] == 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.dataArray removeObjectAtIndex:indexPath.row];
                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@成功",message]];
            
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


- (NSArray *)getArrayData1s {
    
    return @[@{@"pafName":@"建立你自己的iOS开发知识体系", @"author":@"于禁",@"price":@"108",@"nowPrice":@"0",@"img":@"001.png",@"title":@"建立你自己的iOS开发知识体系",@"subTitle":@"",},
             @{@"pafName":@"App 启动速度怎么做优化与监控？", @"author":@"张超",@"price":@"78",@"nowPrice":@"0",@"img":@"002.png",@"title":@"App 启动速度怎么做优化与监控？",@"subTitle":@"",},
             @{@"pafName":@"Auto Layout 是怎么进行自动布局的，性能如何？", @"author":@"李大山",@"price":@"97",@"nowPrice":@"0",@"img":@"003.png",@"title":@"Auto Layout 是怎么进行自动布局的，性能如何？",@"subTitle":@"",},
             @{@"pafName":@"项目大了人员多了，架构怎么设计更合理？", @"author":@"郭涛",@"price":@"88",@"nowPrice":@"0",@"img":@"004.png",@"title":@"架构怎么设计合理",@"subTitle":@"",},
             @{@"pafName":@"链接器：符号是怎么绑定到地址上的？", @"author":@"李思",@"price":@"111",@"nowPrice":@"0",@"img":@"005.png",@"title":@"链接器：符号是怎么绑定到地址上的？",@"subTitle":@"",},
             @{@"pafName":@"App 如何通过注入动态库的方式实现极速编译调试", @"author":@"李树",@"price":@"215",@"nowPrice":@"0",@"img":@"006.png",@"title":@"",@"subTitle":@"",},
             @{@"pafName":@"Clang、Infer 和 OCLint ，我们应该使用谁来做静态分析？", @"author":@"张奇",@"price":@"48",@"nowPrice":@"0",@"img":@"007.png",@"title":@"",@"subTitle":@"",},
             
             @{@"pafName":@"如何利用 Clang 为 App 提质？", @"author":@"陈涛",@"price":@"99",@"nowPrice":@"0",@"img":@"008.png",@"title":@"",@"subTitle":@"",},
             @{@"pafName":@"无侵入的埋点方案如何实现", @"author":@"梁起",@"price":@"147",@"nowPrice":@"0",@"img":@"009.png",@"title":@"",@"subTitle":@"",},
             @{@"pafName":@"人月神话20周年中文版", @"author":@"fee",@"price":@"37",@"nowPrice":@"0",@"img":@"010.png",@"title":@"",@"subTitle":@"",},
             @{@"pafName":@"PHP5中文手册", @"author":@"王静",@"price":@"741",@"nowPrice":@"0",@"img":@"011.png",@"title":@"",@"subTitle":@"",},
             
             @{@"pafName":@"Reader", @"author":@"stentven",@"price":@"25",@"nowPrice":@"0",@"img":@"012.png",@"title":@"",@"subTitle":@"",},
             
             ];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initDatasWithArray:(NSArray *)array {
    
    NSArray *allArray = [self getArrayData1s];
    for (NSString *name in array) {
        for (NSDictionary *dict in allArray) {
            if ([dict[@"pafName"] isEqualToString:name]) {
                
                if (![self.dataArray containsObject:dict]) {
                    [self.dataArray addObject:dict] ;
                }
            }
        }
    }
    
}



@end
