//
//  SplashViewController.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 25..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "SplashViewController.h"
#import "AOPContentsManager.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initContents];
}

- (void)initUI {
    NSString *imageName = @"";
    if (IS_IPHONE_6P) {
        imageName = @"SplashImage_ip6p";
    } else if (IS_IPHONE_6) {
        imageName = @"SplashImage_ip6";
    } else if (IS_IPHONE_5) {
        imageName = @"SplashImage_ip5";
    } else {
        imageName = @"SplashImage";
    }
    
    [self.splashImage setImage:[UIImage imageNamed:imageName]];
}

- (void)initContents {
    AOPContentsManager *contentsManager = [AOPContentsManager sharedManager];
    
    //  앱의 기본 내용이 초기화가 안되어 있으면 초기화
    if (![contentsManager isAppInitialized]) {
        [contentsManager initApp];
    }
    
    [contentsManager initContents:^{
        [self.appInitDelegate checkAndInitAppDone];
    } progress:^(NSInteger percent) {
        
    } failure:^(NSError *error) {
        [self.appInitDelegate checkAndInitAppDone];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
