//
//  SettingViewController.m
//  Scratch
//
//  Created by ChenShuKun on 2019/12/30.
//  Copyright © 2019 ChenShuKun. All rights reserved.
//

#import "SettingViewController.h"
#import "AlertView.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation SettingViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.versionLabel.text = [NSString stringWithFormat:@"VERSION:%@",[ScratchNetWork apiAppVersion]];
    
}
//
- (IBAction)tapAction1:(UITapGestureRecognizer *)sender {
    NSLog(@" tapAction1  ");
    
    NSDictionary *dict = [[self dataArray] firstObject];
    
    AlertView *views = [[AlertView alloc] initWithFrame:CGRectZero];
    [views reSetTitle:dict[@"title"]];
    [views reSetContentText:dict[@"content"]];
    [views alertShow];
    
}

- (IBAction)tapAction2:(UITapGestureRecognizer *)sender {
    
    
    NSLog(@" tapAction2 tapAction2  ");
    
    NSDictionary *dict = [self dataArray][1];
    
    AlertView *views = [[AlertView alloc] initWithFrame:CGRectZero];
    [views reSetTitle:dict[@"title"]];
    [views reSetContentText:dict[@"content"]];
    [views alertShow];

}


- (NSArray *)dataArray {
    
    return @[
        @{@"title":@"软件相关介绍",
          @"content":@"\nScratch是基于scratch3进行的二次开发软件,在原生UI的基础上增加了离线操作、云端保存、想知道等功能以后Scratch将陆续集成更多、更智能的硬件,一个编程环境实现编程、机器人、创客的完美结合,体验不一样的编程乐趣。\n\n\n什么是 scratch?\nScratch-是MT媒体实验室终生幼儿园小组开发的一个图形化编程项目,特别为8到16岁孩子设计,通过 Scratch,可以编写属于你的互动媒体,例如:故事、游戏、动画,培养孩子的创造力、逻辑力、协作力,这些都是生活在21世纪的孩子不可或缺的基本能力。",
          @"icon":@"",
        },
        @{@"title":@"家长使用指南",
          @"content":@"人工智能时代的到来,我们生活的数字世界无不与编程相关，超过90%的美国家长希望在他们孩子的学习中增加编程，在未来,孩子懂编程,他就是未来世界的创造者,如果他不懂，他只是附庸者。\n\n当今,编程已经是语文、数学和英语之外的一项基本技能,也是一种新的素养,编程可以培养少儿的创造力、逻辑思维能力及解决问题的能力,以及解决问的能力，间接培养孩子的协同合作、沟通及表达能力，提高孩子的数学及写作能力,激发孩子主动学习的动力,同时为未来的职业生涯做准备。\n\nScratch将为您以及您的孩子推出相应的模块，让您的孩子可以创作属于自己的专属作品，让孩子有满满的成就感，并与科学相融合，发掘孩子的无限潜能。\n\n少儿学习编程,不是未来成为一名程序员，而是通过学习编程，培养孩子的逻辑思维，发散思维、想象力、创造力、沟通协作的能力，解决问题的能力，自信心，这些都是21世纪不可或缺的基本能力，另外，有助于提升成绩，有机会考入更好的名校\n\n通过编程,改变孩子未来，让孩子站在人工智能时代的前沿。",
          @"icon":@"",
        }
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

@end
