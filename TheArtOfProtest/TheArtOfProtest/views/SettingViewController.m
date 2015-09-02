//
//  SettingViewController.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 8. 23..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "SettingViewController.h"
#import "AOPContentsManager.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AOPContentsManager *manager = [AOPContentsManager sharedManager];
    if (manager.lastModified == nil) {
        self.lastModified.text = @"초기화 필요";
    } else {
        NSString *date = [manager.lastModified substringToIndex:10];
        date = [date stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        self.lastModified.text = date;
    }
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
