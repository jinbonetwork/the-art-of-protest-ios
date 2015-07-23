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
    ServerCommunicator *communicator = [ServerCommunicator sharedCommunicator];
    
    [communicator getPostsAsync:^(NSArray *postList) {
        [[AOPContentsManager sharedManager] setPostList:postList];
    } failure:^(NSError *error) {}];
    
    [communicator getCategoryMenusAsync:^(NSArray *docList) {
        [[AOPContentsManager sharedManager] setCategoryMenuList:docList];
    } failure:^(NSError *error) {}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
