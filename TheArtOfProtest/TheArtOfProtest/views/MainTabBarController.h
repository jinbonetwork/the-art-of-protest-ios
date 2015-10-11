//
//  MainTabBarController.h
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 6..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppInitDelegate.h"

/**
 탭바 Controller
 */
@interface MainTabBarController : UITabBarController
@property (strong, nonatomic) IBOutlet UITabBar *mTabBar;
@property (assign, nonatomic) id<AppInitDelegate> appInitDelegate;
@end
