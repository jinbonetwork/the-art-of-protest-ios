//
//  HomeViewController.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 6..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "HomeViewController.h"
#import "AFNetworking.h"

@interface HomeViewController ()
@property (assign) BOOL notifyExists;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad] ;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://theartofprotest.jinbo.net/home.html"]];
    [self.webView loadRequest:request];
    
    self.notifyExists = YES;
    
    if(self.notifyExists) {
        
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)addNotifyView {
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
