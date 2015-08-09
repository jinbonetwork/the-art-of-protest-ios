//
//  HomeViewController.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 6..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "HomeViewController.h"
#import "AFNetworking.h"
#import "AOPContentsManager.h"

@interface HomeViewController ()
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://theartofprotest.jinbo.net/home.html"]];
    [self initNoticeView];
    
    self.webView.delegate = self;
    [self.webView loadRequest:request];
}

/**
 공지View를 초기화 한다.
 */
- (void)initNoticeView {
    AOPContentsManager *contentsManager = [AOPContentsManager sharedManager];
    if(contentsManager.notice == nil) { // 공지가 없을 경우 그냥 return
        return;
    }

    // 사용할 View 및 webView 교체
    self.view = self.noticeView;
    self.webView = self.webViewForNotice;
    self.indicator = self.indicatorForNoticeView;
    [self.labelNoticeTitle setText:contentsManager.notice.title];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.indicator setHidden:YES];
}

@end
