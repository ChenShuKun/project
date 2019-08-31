//
//  DetailModel.h
//  BluetoothHelper
//
//  Created by alsrobot on 2019/8/22.
//  Copyright © 2019 ChenShuKun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailModel : NSObject

@property (nonatomic,copy) NSData *data;
@property (nonatomic,copy) CBUUID *uuid;

@property (nonatomic ,strong) NSMutableArray *dataArray;

@end


@interface DetailModel22 : NSObject

@property (nonatomic,copy) NSData *data22;
@property (nonatomic,copy) CBUUID *uuid22;

@end

NS_ASSUME_NONNULL_END

