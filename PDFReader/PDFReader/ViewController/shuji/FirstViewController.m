//
//  FirstViewController.m
//  PDFReader
//
//  Created by alsrobot on 2019/7/26.
//  Copyright © 2019 ChenShukun. All rights reserved.
//

#import "FirstViewController.h"
#import "ReaderViewController.h"
#import "SearchViewController.h"

@interface FirstViewController ()<UITableViewDelegate,UITableViewDataSource,ReaderViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) NSInteger totalRow ;
@property (strong, nonatomic) NSIndexPath *focusOnIndex;
@end

@implementation FirstViewController {
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
     [self pullDownActions];
}

-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray= [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self pullDownActions];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self pullUpActions];
    }];
    
    //长摁手势
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(pressAction:)];
    [self.tableView addGestureRecognizer:longpress];

}

- (void)getDatasWithParams:(NSInteger)page {

    NSDictionary *dict = @{@"page":@(page),@"rows":@10};
    [SVProgressHUD show];
    [AFNetworkingManager requestGetUrlString:@"page/getPageInfo" parameters:dict successBlock:^(id  _Nonnull responseObject) {
       
        [SVProgressHUD dismiss];
        NSArray *data = responseObject[@"data"];
        self.totalRow = [responseObject[@"totalRow"] integerValue];
        if (data) {
            [self.dataArray addObjectsFromArray:data];
        }
        [self.tableView reloadData];
        [self endRefresh];
    } failureBlock:^(NSError * _Nonnull error) {
        
        NSLog(@"error  = %@",[error description]);
        [self endRefresh];
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

    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
 
    if (self.dataArray.count >= self.totalRow) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else {
        [self.tableView.mj_footer resetNoMoreData];
    }
}

- (IBAction)searchBooksActions:(UIBarButtonItem *)sender {
    
    if (![UserDefault isLogIn]) {
        [self goToLoginViewController];
        return;
    }
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"searchViewController111"];
    [self.navigationController pushViewController:vc animated:YES];
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
    /*
     @{@"pafName":@"建立你自己的iOS开发知识体系",
     @"author":@"于禁",
     @"price":@"108",
     @"nowPrice":@"0",
     @"img":@"001.png",
     @"title":@"建立你自己的iOS开发知识体系",
     @"subTitle":@"",},
     */
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
    
    if (![UserDefault isLogIn]) {
        [self goToLoginViewController];
        return;
    }
    
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
    NSString *isFollowTitle = @"关注";
    NSString *isFollow = @"1";
    if (dict[@"isFollow"] && [dict[@"isFollow"] integerValue] == 1 ){
        isFollowTitle = @"取消关注";isFollow = @"0";
    }
    NSString *isCollectionTitle = @"收藏";
    NSString *isCollection = @"1";
    if (dict[@"isCollection"] && [dict[@"isCollection"] integerValue] == 1){
        isCollectionTitle = @"取消收藏";isCollection = @"0";
    }

    // 自定义左滑显示编辑按钮
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:isFollowTitle handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
            NSLog(@" 是否关注了 ");
        [self changeCollectionOrFollowKey:@"isFollow" value:isFollow Message:isFollowTitle indexPath:indexPath];
        
        }];
    
    UITableViewRowAction *rowActionSec = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault  title:isCollectionTitle handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSLog(@" 是否收藏了 ");
        [self changeCollectionOrFollowKey:@"isCollection" value:isCollection Message:isCollectionTitle indexPath:indexPath];
    }];
    
    rowActionSec.backgroundColor = [UIColor redColor];
    rowAction.backgroundColor = [UIColor greenColor];
    NSArray *arr = @[rowAction,rowActionSec];
    return arr;
}


#pragma mark:-- 是否关注了 // 是否收藏了
- (void)changeCollectionOrFollowKey:(NSString *)keyStr value:(NSString *)value Message:(NSString *)message indexPath:(NSIndexPath *)indexPath {
    
    if (![UserDefault isLogIn]) {
        [self goToLoginViewController];
        return;
    }
    
    NSDictionary *dict =  self.dataArray[indexPath.row];
    NSLog(@"type  == %@",keyStr);
    NSString *urlString = @"";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([keyStr isEqualToString:@"isFollow"]) {

        urlString = @"page/updateFollow";
        [params setObject:dict[@"id"] forKey:@"id"];
        NSInteger isFollow = [dict[@"isFollow"] integerValue] == 0 ? 1:0;
        [params setObject:@(isFollow) forKey:@"isFollow"];
    }else {
        urlString = @"page/updateCollection";
        [params setObject:dict[@"id"] forKey:@"id"];
        NSInteger isCollect = [dict[@"isCollection"] integerValue] == 0 ? 1:0;
        [params setObject:@(isCollect) forKey:@"isCollection"];
    }
    [SVProgressHUD show];
    [AFNetworkingManager requestGetUrlString:urlString parameters:params successBlock:^(id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        if ([responseObject[@"code"] integerValue] == 0) {
         
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary *dict1 = [NSMutableDictionary dictionaryWithDictionary:dict];
                [dict1 setObject:value forKey:keyStr];
                [self.dataArray replaceObjectAtIndex:indexPath.row withObject:dict1];
                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@成功",message]];
                [self.tableView reloadData];
            });
            
        }else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
        NSLog(@"error  = %@",[error description]);
        
    }];
   
}

#pragma mark:-- 长摁 关注作者
- (void)pressAction:(UILongPressGestureRecognizer *)longPressGesture
{
    
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {//手势开始
        
        CGPoint point = [longPressGesture locationInView:self.tableView];
        self.focusOnIndex = [self.tableView indexPathForRowAtPoint:point]; // 可以获取我们在哪个cell上长按
    }
    if (longPressGesture.state == UIGestureRecognizerStateEnded)//手势结束
    {
        NSDictionary *dict =  self.dataArray[self.focusOnIndex.row];
        
        NSString *title = [NSString stringWithFormat:@"是否关注作者:[%@] ?",dict[@"author"]];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *makeSure = [UIAlertAction actionWithTitle:@"关注" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
            [self updateAuthorActions];
        }];
        [alert addAction:makeSure];
        [alert addAction:[UIAlertAction actionWithTitle:@"不关注" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:true completion:nil];
    }
    
}

#pragma mark:-- 长摁 关注作者 接口
- (void)updateAuthorActions {

    if (![UserDefault isLogIn]) {
        [self goToLoginViewController];
        return;
    }
    
    
    NSDictionary *dict =  self.dataArray[self.focusOnIndex.row];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    [params setObject:dict[@"author"] forKey:@"author"];
    [params setObject:@(1) forKey:@"isFollow"];
    
    [SVProgressHUD show];
    [AFNetworkingManager requestGetUrlString:@"page/updateAuthor" parameters:params successBlock:^(id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        if ([responseObject[@"code"] integerValue] == 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"关注作者[%@]成功",dict[@"author"]]];
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
    
    return @[@{@"pafName":@"建立你自己的iOS开发知识体系", @"author":@"于禁",@"price":@"108",@"nowPrice":@"0",@"img":@"001.png",@"title":@"建立你自己的iOS开发知识体系",@"subTitle":@"",@"isFollow":@"YES",@"isCollection":@"NO"},
             @{@"pafName":@"App 启动速度怎么做优化与监控？", @"author":@"张超",@"price":@"78",@"nowPrice":@"0",@"img":@"002.png",@"title":@"App 启动速度怎么做优化与监控？",@"subTitle":@"",@"isFollow":@"YES",@"isCollection":@"NO"},
             @{@"pafName":@"Auto Layout 是怎么进行自动布局的，性能如何？", @"author":@"李大山",@"price":@"97",@"nowPrice":@"0",@"img":@"003.png",@"title":@"Auto Layout 是怎么进行自动布局的，性能如何？",@"subTitle":@"",@"isFollow":@"NO",@"isCollection":@"YES"},
             @{@"pafName":@"项目大了人员多了，架构怎么设计更合理？", @"author":@"郭涛",@"price":@"88",@"nowPrice":@"0",@"img":@"004.png",@"title":@"架构怎么设计合理",@"subTitle":@"",@"isFollow":@"YES",@"isCollection":@"NO"},
             @{@"pafName":@"链接器：符号是怎么绑定到地址上的？", @"author":@"李思",@"price":@"111",@"nowPrice":@"0",@"img":@"005.png",@"title":@"链接器：符号是怎么绑定到地址上的？",@"subTitle":@"",@"isFollow":@"YES",@"isCollection":@"NO"},
             @{@"pafName":@"App 如何通过注入动态库的方式实现极速编译调试", @"author":@"李树",@"price":@"215",@"nowPrice":@"0",@"img":@"006.png",@"title":@"",@"subTitle":@"",@"isFollow":@"YES",@"isCollection":@"NO"},
             ];
}

- (NSArray *)getArrayData2s {
    return @[
             @{@"pafName":@"Clang、Infer 和 OCLint ，我们应该使用谁来做静态分析？", @"author":@"张奇",@"price":@"48",@"nowPrice":@"0",@"img":@"007.png",@"title":@"",@"subTitle":@"",},
             
             @{@"pafName":@"如何利用 Clang 为 App 提质？", @"author":@"陈涛",@"price":@"99",@"nowPrice":@"0",@"img":@"008.png",@"title":@"",@"subTitle":@"",},
             @{@"pafName":@"无侵入的埋点方案如何实现", @"author":@"梁起",@"price":@"147",@"nowPrice":@"0",@"img":@"009.png",@"title":@"",@"subTitle":@"",},
             @{@"pafName":@"人月神话20周年中文版", @"author":@"fee",@"price":@"37",@"nowPrice":@"0",@"img":@"010.png",@"title":@"",@"subTitle":@"",},
             @{@"pafName":@"PHP5中文手册", @"author":@"王静",@"price":@"741",@"nowPrice":@"0",@"img":@"011.png",@"title":@"",@"subTitle":@"",},

             @{@"pafName":@"Reader", @"author":@"stentven",@"price":@"25",@"nowPrice":@"0",@"img":@"012.png",@"title":@"",@"subTitle":@"",},
             
             ];
}

//去登录
- (void)goToLoginViewController {
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"LoginViewControllerSSS"];
    [self presentViewController:vc animated:YES completion:nil];
    
}


@end
