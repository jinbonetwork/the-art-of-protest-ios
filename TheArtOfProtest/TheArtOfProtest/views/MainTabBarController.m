//
//  MainTabBarController.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 6..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *items = self.tabBar.items;
    
    // 선택되지 않은 상태의 탭바 아이콘에 기본 회색이 덮어씌어지지 않고 원래 색깔을 유지하도록 한다.
    for (UITabBarItem *tbi in items) {
        UIImage *image = tbi.image;
        tbi.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
