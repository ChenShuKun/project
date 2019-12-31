//
//  DetailModel.h
//  BluetoothHelper
//
//  Created by a on 2019/8/22.
//  Copyright © 2019 ChenShuKun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailModel : NSObject

@property (nonatomic,copy) NSString *header_name;
@property (nonatomic,copy) NSString *header_type;
@property (nonatomic ,strong) NSMutableArray *dataArray;
 

@end

NS_ASSUME_NONNULL_END
