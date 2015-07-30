//
//  ContentViewController.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 12..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "ContentViewController.h"
#import "FileManager.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FileManager *fileManager = [[FileManager alloc] init];
    NSString *path = [fileManager getAppSupportRoot];
    NSURL* baseURL = [NSURL fileURLWithPath:path];
    
    NSData *data = [self.content dataUsingEncoding:NSUTF8StringEncoding];
    [self.webView loadData:data MIMEType: @"text/html" textEncodingName: @"UTF-8" baseURL:baseURL];
    
}

- (void)initWebView {
    
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
