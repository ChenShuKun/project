//
//  DataViewController.h
//  BluetoothHelper
//
//  Created by a on 2019/12/31.
//  Copyright © 2019 ChenShuKun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^DataViewBlock)(NSString *str );

@interface DataViewController : UIViewController

@property (nonatomic ,copy ) DataViewBlock block;

@end

NS_ASSUME_NONNULL_END
