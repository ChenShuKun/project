//
//  ScratchWebViewController.h
//  ALSScratch3
//
//  Created by alsrobot on 2019/10/9.
//  Copyright © 2019 Chenshukun. All rights reserved.
//

#import "WebViewController.h"
#import "ScratchModel.h"
@class LocalModel;

typedef void(^ScratchWebViewBlock)(ScratchModel *model);
NS_ASSUME_NONNULL_BEGIN

@interface ScratchWebViewController : WebViewController


@property (nonatomic ,strong) ScratchModel *model;
@property (nonatomic ,copy)   ScratchWebViewBlock scratchBlock;
@property (nonatomic ,strong) LocalModel *localModel;

- (instancetype)initWithURLString:(NSString *)urlStr andTitle:(NSString *)title;


@end

NS_ASSUME_NONNULL_END
