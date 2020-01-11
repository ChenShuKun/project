//
//  WebViewBlueToothCell.h
//  ALSScratch3
//
//  Created by alsrobot on 2019/10/24.
//  Copyright © 2019 Chenshukun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CBPeer.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebViewBlueToothCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

NS_ASSUME_NONNULL_END
