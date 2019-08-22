//
//  ViewController.m
//  Drivingvoices
//
//  Created by ChenShuKun on 2019/7/30.
//  Copyright © 2019 ChenShuKun. All rights reserved.
//

#import "ViewController.h"
#import "CKAudioPlayer.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)playBtn:(id)sender {
    
    [[CKAudioPlayer sharedInstance] playWithAudioName:@"2019_07_31_13_56_IMG_4938"];
    
}

- (IBAction)stopBtn:(id)sender {
    [[CKAudioPlayer sharedInstance] stopPlay];
}

@end
