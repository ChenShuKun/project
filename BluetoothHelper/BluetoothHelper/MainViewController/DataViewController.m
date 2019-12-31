//
//  DataViewController.m
//  BluetoothHelper
//
//  Created by a on 2019/12/31.
//  Copyright © 2019 ChenShuKun. All rights reserved.
//

#import "DataViewController.h"
#import "WriteDataViewController.h"

@interface DataViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,weak) UITextField *textField;

@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
   
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44 + 40)];
    header.backgroundColor = [UIColor lightGrayColor];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(20, 20, self.view.frame.size.width-40, 44)];
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDone ;
    textField.delegate = self;
    textField.placeholder = @"请输入文字...";
    [header addSubview:textField];
    self.textField = textField;
    self.tableView.tableHeaderView = header;
    
    
//    [self.dataArray addObject:@"ff5509040208000000ff0000"]; //红色
    [self.dataArray addObject:@"ff5509040208000000008000"]; //绿色
    [self.dataArray addObject:@"ff5509040208000000006000"]; //黑色

}


- (void)rightBarButtonItemActions {

    WriteDataViewController *writeData = [[WriteDataViewController alloc]init];
    [self.navigationController pushViewController:writeData animated:YES];
    writeData.block = ^(NSString * _Nonnull string) {
        NSLog(@"  writeData  string = %@",string);
    };
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    
    if (textField.text.length >0 ) {
        
        [self.dataArray addObject:textField.text];
        [self.tableView reloadData];
    }
    [textField resignFirstResponder];
    return YES;
}
#pragma mark:---  UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    NSString *namss = self.dataArray[indexPath.row];
    cell.textLabel.text = namss;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *data = self.dataArray[indexPath.row];
    //发送命令
    if (self.block) {
        self.block(data);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
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
