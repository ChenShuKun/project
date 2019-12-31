//
//  TableHeaderView.m
//  PDFReader
//
//  Created by ChenShuKun on 2019/8/2.
//  Copyright © 2019 ChenShukun. All rights reserved.
//

#import "TableHeaderView.h"
@interface TableHeaderView()
@property (nonatomic, strong) UIImageView *imagess ;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end
@implementation TableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightTextColor];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    UIImageView *imagess = [[UIImageView alloc]init];
    CGFloat height = 140;
    imagess.frame = CGRectMake(20, 20, height, height);
    imagess.layer.cornerRadius = height/2;
    imagess.clipsToBounds = YES;
    imagess.image = [UIImage imageNamed:@"head.jpg"];
    [self addSubview:imagess];
    self.imagess = imagess;
    
    CGFloat www = self.frame.size.width - 20 - height - 20 - 20;
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(20 + height + 20, 40, www, 21)];
    name.backgroundColor = [UIColor clearColor];
    [self addSubview:name];
    self.nameLabel = name;
    
    
    //miasohu
    UILabel *des = [[UILabel alloc] initWithFrame:CGRectMake(name.frame.origin.x, 40 +  21 + 20, www, 80)];
    des.numberOfLines = 0;
    des.font = [UIFont systemFontOfSize:15];
    des.textColor = [UIColor blackColor];
    [self addSubview:des];
    self.desLabel = des;
    
    
    UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(20, 20 + height + 10, self.frame.size.width, 21)];
    content.textColor = [UIColor orangeColor];
    [self addSubview:content];
    self.contentLabel = content;
    
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActions)];
    [self addGestureRecognizer:tap];
    
    
    [self fillDatas];
}

- (void)tapActions {
    if (self.block) {
        self.block(@{}, NO);
    }
}

- (void)fillDatas {
/*
 @{@"name":@"小麦家爱",
 @"sex":@"男",
 @"account":@"244410894@qq.com",
 @"password":@"123456",
 @"head":@"head.jpg",
 @"read":@"阅读 42 分钟",
 @"readBooks":@"读过 0 本",
 @"zanCount":@"被赞 0 次",
 @"des":@"我是一个爱好的阅读者,阅读让我开心,阅读让我充实,阅读让我的生活丰富,阅读让我增长知识,阅读是我的美好习惯,加油!!!"
 }
 */
    NSString *name = @"244410894@qq.com";
    if ([UserDefault isLogIn]) {
        NSLog(@"-----已经登录 ");
        NSDictionary *dic = [[SKPDFReader sharedSingleton] getInforData:name];
        self.imagess.image = [UIImage imageNamed:dic[@"head"]];
        self.nameLabel.text = [NSString stringWithFormat:@"昵称: %@",dic[@"name"]];
        self.desLabel.text = [NSString stringWithFormat:@"%@",dic[@"des"]];
        
        self.contentLabel.hidden = NO;
        self.contentLabel.text = [NSString stringWithFormat:@"%@  %@  %@",dic[@"read"],dic[@"readBooks"],dic[@"zanCount"]];
    }else {
        
        NSLog(@"-----没登录 ");
        self.imagess.image = [UIImage imageNamed:@"no_head.jpeg"];
        self.nameLabel.text = @"游客AA03";
        self.desLabel.text = @"暂无描述";
        self.contentLabel.hidden = YES;
    }
    
}

@end
