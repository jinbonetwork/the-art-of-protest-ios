//
//  MainTabBarController.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 6..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "MainTabBarController.h"
#import "ServerCommunicator.h"
#import "AOPContentsManager.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testCode];
}

- (void) testCode {
    AOPContentsManager *contentsManager = [AOPContentsManager sharedManager];
    [contentsManager initContents:^{
        int debug;
        AOPContentsManager *manager = [AOPContentsManager sharedManager];
        debug = 1;
    } progress:^(NSInteger percent) {
        
    } failure:^(NSError *error) {
        int debug;
        debug = 1;
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
