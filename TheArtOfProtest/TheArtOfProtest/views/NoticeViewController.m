//
//  NoticeViewController.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 8. 16..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "NoticeViewController.h"
#import "FileManager.h"
#import "AOPContentsManager.h"

@interface NoticeViewController ()

@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noticeItem = [[AOPContentsManager sharedManager] notice];
    [self initWebView];
    [self initTopBar];
}

/**
 webView를 초기화 한다.
 */
- (void)initWebView {
    // BASE URL을 얻는다.
    FileManager *fileManager = [[FileManager alloc] init];
    NSString *path = [fileManager getAppSupportRoot];
    NSURL* baseURL = [NSURL fileURLWithPath:path];
    
    NSString *date = [self.noticeItem.date substringToIndex:10];
    date = [date stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    // WebView 들어갈 html콘텐츠를 구성
    NSString *html= [NSString stringWithFormat:@"%@%@%@%@%@%@%@",
                     @"<html><head><link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\"/></head><body><header><h1>",
                     self.noticeItem.title,
                     @"</h1><time>",
                     date,
                     @"</time></header><div id=\"notice-content\">",
                     self.noticeItem.content,
                     @"</div></body></html>"];
    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
    
    self.webView.delegate = self;
    [self.webView loadData:data MIMEType: @"text/html" textEncodingName: @"UTF-8" baseURL:baseURL];
}

/**
 상단 바를 초기화 한다.
 */
- (void)initTopBar {
    [self.navigationItem setTitle:self.noticeItem.title];
    UIBarButtonItem *closeBarBtn = [[UIBarButtonItem alloc] initWithCustomView:self.btnClose];
    [self.navigationItem setLeftBarButtonItem:closeBarBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 닫기 버튼이 클릭되었을 때
 */
- (IBAction)btnCloseTouched:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - webview 
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.indicator setHidden:YES];
}
@end
