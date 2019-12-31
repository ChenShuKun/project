//
//  CKAudioPlayer.h
//  Drivingvoices
//
//  Created by ChenShuKun on 2019/8/2.
//  Copyright © 2019 ChenShuKun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CKAudioPlayer : NSObject

+ (instancetype)sharedInstance;

-(void)playWithAudioName:(NSString *)name;
- (BOOL)isPlaying;
-(void)stopPlay ;

@end

NS_ASSUME_NONNULL_END
