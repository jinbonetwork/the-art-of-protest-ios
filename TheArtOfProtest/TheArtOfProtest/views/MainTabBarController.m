//
//  MainTabBarController.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 6..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "MainTabBarController.h"
#import "ServerCommunicator.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testCode];
    // Do any additional setup after loading the view from its nib.
}

- (void) testCode {
    ServerCommunicator *communicator = [ServerCommunicator sharedCommunicator];
    
    [communicator getDocumentListAsync:^(NSArray *docList) {
        int debug;
        
    } failure:^(NSError *error) {
        int debug;
    }];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *applicationSupportDirectory = [paths firstObject];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
