//
//  RefWebViewController.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 8. 16..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "RefWebViewController.h"

@interface RefWebViewController ()
@property (assign) NSInteger loadCount;
@end

@implementation RefWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadCount = 0;
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

/**
 공유 등의 기능을 할 수 있는 Action Sheet (Pop Up)을 띄운다.
 */
- (void)showUIActionSheet {
    UIActionSheet *sheet = [[UIActionSheet alloc]
                            initWithTitle:nil
                            delegate:self
                            cancelButtonTitle:@"취소"
                            destructiveButtonTitle:nil
                            otherButtonTitles:@"링크 복사", @"Safari에서 열기" , nil];
    [sheet showInView:self.view];
}

/**
 현재 WebView의 URL을 safari에서 연다.
 */
- (void)openSafariWithCurrentUrl {
    [[UIApplication sharedApplication] openURL:self.webView.request.URL];
}

/**
 현재 URL을 clipboard로 복사한다.
 */
- (void)copyCurrentUrlToClipboard {
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = self.webView.request.URL.absoluteString;
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
    [self showUIActionSheet];
}

#pragma mark - WebView Delegate

-(void)webViewDidStartLoad:(UIWebView *)webView {
    self.navigationItem.title = @"불러오는중...";
    [self.indicator setHidden:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.indicator setHidden:YES];
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

#pragma mark = UIActionSheet Delegate 

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self copyCurrentUrlToClipboard];
            break;
        case 1:
            [self openSafariWithCurrentUrl];
            break;
        default:
            break;
    }
}
@end
