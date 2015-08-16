//
//  RefWebViewController.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 8. 16..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "RefWebViewController.h"

@interface RefWebViewController ()

@end

@implementation RefWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWebview];
    [self initTopBar];
}

- (void)initWebview {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.startUrl]]];
    self.webView.delegate = self;
}

- (void)initTopBar {
    UIBarButtonItem *closeBarBtn = [[UIBarButtonItem alloc] initWithCustomView:self.btnClose];
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc] initWithCustomView:self.btnShare];
    
    self.navigationItem.rightBarButtonItem = shareBtn;
    self.navigationItem.leftBarButtonItem = closeBarBtn;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 닫기 버튼이 터치 되었을 때 해당 ViewController를 dismiss한다.
 */
- (IBAction)closeBtnTouched:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 공유 버튼이 터치 되었을 때
 */
- (IBAction)shareBtnTouched:(id)sender {
}

#pragma mark - WebView Delegate

-(void)webViewDidStartLoad:(UIWebView *)webView {
    self.navigationItem.title = @"불러오는중...";
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.indicator setHidden:YES];
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
@end
