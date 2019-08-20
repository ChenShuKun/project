//
//  DetailViewController.h
//  BluetoothHelper
//
//  Created by ChenShuKun on 2019/8/17.
//  Copyright © 2019 ChenShuKun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController

@property (nonatomic, strong) Model     *detailModel;
@property (nonatomic, strong) CBCentralManager        *manager;
@property (nonatomic, strong) CBPeripheral           *peripheral;


@end

NS_ASSUME_NONNULL_END
