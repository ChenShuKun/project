//
//  FullScreenViewController.m
//  LearnDemo
//
//  Created by alsrobot on 2020/1/7.
//  Copyright © 2020 Chenshukun. All rights reserved.
//

#import "FullScreenViewController.h"
//#import <ZFPlayer/ZFPlayer.h>
//#import <ZFPlayer/ZFAVPlayerManager.h>
//#import <ZFPlayer/ZFIJKPlayerManager.h>
//#import <ZFPlayer/KSMediaPlayerManager.h>
//#import <ZFPlayer/ZFPlayerControlView.h>
//#import "ZFSmallPlayViewController.h"
#import "ZFPlayer.h"
#import "ZFAVPlayerManager.h"
#import "ZFIJKPlayerManager.h"
#import "KSMediaPlayerManager.h"
#import "ZFPlayerControlView.h"
//#import "ZFSmallPlayViewController.h"


static NSString *kVideoCover = @"https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";

@interface FullScreenViewController ()

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@end

@implementation FullScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.containerView];

    @weakify(self)
    self.controlView.backBtnClickCallback = ^{
        @strongify(self)
        [self.player enterFullScreen:NO animated:NO];
        [self.player stop];
        [self.navigationController popViewControllerAnimated:NO];
    };
   
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// 播放器相关
    self.player = [[ZFPlayerController alloc] initWithPlayerManager:playerManager containerView:self.containerView];
    self.player.controlView = self.controlView;
    self.player.orientationObserver.supportInterfaceOrientation = ZFInterfaceOrientationMaskLandscapeRight;
    [self.player enterFullScreen:YES animated:NO];
    
    playerManager.assetURL = [NSURL URLWithString:self.videoUrl];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.player.viewControllerDisappear = NO;
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.player.viewControllerDisappear = YES;
    [self.navigationController.navigationBar setHidden:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate {
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.effectViewShow = NO;
        _controlView.fullScreenOnly = YES;
        _controlView.prepareShowLoading = YES;
    }
    return _controlView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
    }
    return _containerView;
}

@end
