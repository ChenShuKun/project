//
//  WriteDataViewController.h
//  BluetoothHelper
//
//  Created by a on 2019/12/31.
//  Copyright © 2019 ChenShuKun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^WriteDataBlock)(NSString *string);
@interface WriteDataViewController : UIViewController

@property (nonatomic, copy) WriteDataBlock block;

@end

NS_ASSUME_NONNULL_END
