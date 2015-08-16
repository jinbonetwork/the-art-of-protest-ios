//
//  SplashViewController.h
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 25..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceConfig.h"
#import "AppInitDelegate.h"

@interface SplashViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *splashImage;
@property (assign, nonatomic) id<AppInitDelegate> appInitDelegate;
@property (weak, nonatomic) IBOutlet UILabel *progressMessage;

@end
