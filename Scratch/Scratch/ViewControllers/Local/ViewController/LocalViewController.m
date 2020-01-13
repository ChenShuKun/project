//
//  LocalViewController.m
//  LearnDemo
//
//  Created by alsrobot on 2020/1/6.
//  Copyright © 2020 Chenshukun. All rights reserved.
//

#import "LocalViewController.h"
#import "ALSFlowLayout.h"
#import "LocalCollectionViewCell.h"
#import "LocalModel.h"

//基本变量
#define KMainViewLeft  180
#define KMainViewTop   240
#define KMainViewBtnViewHeight 50
#define KMainViewBackGrondViewWidth 20


static NSString *CellID = @"LocalCollectionViewCellID" ;

@interface LocalViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectView1;
@property (nonatomic, strong) NSMutableArray *dataArray1;

@end

@implementation LocalViewController {
    CGFloat space; //间距
    CGFloat item_width_local; //item 宽度
    CGRect frame_width;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self getLocalDataArray];
}

//获取本地数据
- (void)getLocalDataArray {
    
    NSMutableArray *data = [LocalModel getLocalModelArray];
    if (data != nil  || data.count > 0) {
        [self.dataArray1 removeAllObjects];
        [self.dataArray1 addObjectsFromArray:data];
        [self.collectView1 reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initConfig];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLocalDataArray) name:RELOADLOCALDATA_NOTIFICATION object:nil];
    [self.view addSubview:self.collectView1];
 
//    [self fillData];
//    [self.collectView1 reloadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.collectView1.frame = self.view.bounds;
}

- (void)firstLoadLocalData {
 
//    item_width_local = 234;
//    [self.view addSubview:self.collectView1];
//    NSMutableArray *data = [LocalModel getLocalData];
//    [self.dataArray1 addObjectsFromArray:data];
//
//    [self.collectView1 reloadData];

}

#pragma mark:-- 基础的配置
- (void)initConfig {
    
    space = 15;
    
    CGFloat frame_x = mainView_left_width + 10;
    item_width_local = (KScreen_width - frame_x - 20 - 4*space )/3;
}

- (void)fillData {
    
    NSMutableArray *data = [LocalModel getLocalData];
    [self.dataArray1 addObjectsFromArray:data];
    
    
    CGRect frame = self.collectView1.frame;
    CGFloat spaceCount = ceil(self.dataArray1.count / 3.0 ) ;
    frame.size.height =  KScreen_Height - KMainViewTop - space*spaceCount;
    self.collectView1.frame = frame;
    
}
#pragma mark - Lazy load
- (UICollectionView *)collectView1{
    if (!_collectView1) {

        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = space;
        layout.minimumInteritemSpacing = space;
        layout.itemSize = CGSizeMake(60, 60);
        layout.sectionInset = UIEdgeInsetsMake(space, space, space, space);;
        
        CGRect rect = self.view.bounds; 
        _collectView1 = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];

//        _collectView1 = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout1];
        _collectView1.backgroundColor = [UIColor whiteColor];
        _collectView1.showsVerticalScrollIndicator = NO;
        _collectView1.delegate = self;
        _collectView1.dataSource = self;
        [_collectView1 registerNib:[UINib nibWithNibName:@"LocalCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:CellID];
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

    LocalCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    
    LocalModel *model= self.dataArray1[indexPath.row];
    cell1.localModel = model;
    __WeakSelf(self);
    cell1.upLoadBlock =  ^(UIButton *_Nonnull button,LocalModel *_Nonnull model) {
        [weakself upLoadButtonAction:button andModel:model andIndexPath:indexPath];
    };
    cell1.deleteBlock = ^(UIButton * _Nonnull button, LocalModel * _Nonnull model) {
        
        [weakself deleteButtonAction:button andModel:model andIndexPath:indexPath];
    };
    return cell1;
}

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(item_width_local, item_width_local);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(space, space, space, space);
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    LocalModel *model = self.dataArray1[indexPath.row];
    if ([model.iconUrl isEqualToString:@"creat"]) {
        
    /*
        NSLog(@" 测试 存储数据  ");
        FileManger *file = [[FileManger alloc]init];
        file.fileName = @"我是测试数据05";
        file.fileContent = @"我是测试数据001";
        BOOL write = [file fileManger_add];
        if (write) {
          BOOL time =  [FileManger saveSaveTimekey:file.fileName];
          NSLog(@" timetimetime = %@ ",@(time));
        }
        NSLog(@" 测试 存储数据 write = %@ ",@(write));
     */
        NSString *url = @"http://localhost:6080?islocal=1";
        ScratchWebViewController * create = [[ScratchWebViewController alloc] initWithURLString:url andTitle:@"create"];
        [self.navigationController pushViewController:create animated:YES];

    }else {
        
        
        //用户的作品
        NSLog(@" 作品名称 ==%@",model.titleStr);
        
        LocalModel *localModel = [[LocalModel alloc]init];
        localModel.localTitle = model.titleStr;
        localModel.localContent = [FileManger fileManger_find_FileName:model.titleStr];
        
        
        
        ScratchModel *scratch = [[ScratchModel alloc]init];
        
        NSString *url = @"http://localhost:6080?islocal=1";
        ScratchWebViewController * create = [[ScratchWebViewController alloc]initWithURLString:url andTitle:@"update"];
        create.localModel = localModel;
        create.model = scratch;
        create.scratchBlock = ^(ScratchModel *model) {
        };
        [self.navigationController pushViewController:create animated:YES];
    }
    /*
     NSLog(@"aaa = %@",model.titleStr);
     AlertPromptView *views = [[AlertPromptView alloc] initWithFrame:CGRectZero];
     [views reSetTitle:@"我是测试内容"];
     [views alertShow];
     views.cancleBlock = ^(UIButton * _Nonnull cancleBtn) {
     
     NSLog(@"cancleBlock");
     
     };
     views.confirmDeleteBlock = ^(UIButton * _Nonnull confirmBtn) {
     
     NSLog(@"confirmDeleteBlock");
     
     };
     */
}


#pragma mark - actions
- (void)upLoadButtonAction:(UIButton *)button andModel:(LocalModel *)model andIndexPath:(NSIndexPath *)indexPath {

    NSLog(@" = %@",model.titleStr);
    if (![UserManager userIsLogin]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:GOLOGINACTIONS_NOTIFICATION object:nil];
        return;
    }
    
    
    NSLog(@"上传到云端接口");
    [SKProgressHUD showLoading];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SKProgressHUD dismissLoading];
        [self upLoadSucceed:@{} andIndexPath:indexPath];
    });
    
}

- (void)upLoadSucceed:(NSDictionary *)result andIndexPath:(NSIndexPath *)indexPath {
    
    [SKProgressHUD showSuccessWithStatus:@"上传成功"];
    
    
    [self.dataArray1 removeObjectAtIndex:indexPath.row];
    [self.collectView1 reloadData];
    
}

- (void)deleteButtonAction:(UIButton *)button andModel:(LocalModel *)model andIndexPath:(NSIndexPath *)indexPath  {
 
     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"确定要删除 ?" preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            NSLog(@"tap no button");
        }];
        
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^ void (UIAlertAction *action){
            NSLog(@"tap yes button");
            
            [FileManger fileManger_remove_FileName:model.titleStr];

            [self.dataArray1 removeObjectAtIndex:indexPath.row];
            [self.collectView1 reloadData];
            
        }];
        
        [alertController addAction:noAction];
        [alertController addAction: yesAction];
        
        //以模态框的形式显示
        [self presentViewController:alertController animated:true completion:^(){
            NSLog(@"success");
        }];
    
}


@end
