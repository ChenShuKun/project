//
//  AppDelegate.h
//  Drivingvoices
//
//  Created by ChenShuKun on 2019/7/30.
//  Copyright © 2019 ChenShuKun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

