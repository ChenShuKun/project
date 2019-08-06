//
//  AppDelegate.h
//  PDFReader
//
//  Created by alsrobot on 2019/7/26.
//  Copyright © 2019 ChenShukun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

