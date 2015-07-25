//
//  AppDelegate.h
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 4..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "AppInitDelegate.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, AppInitDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

