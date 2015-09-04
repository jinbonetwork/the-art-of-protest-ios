//
//  DocumentViewController.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 8. 1..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "DocumentViewController.h"
#import "RefWebViewController.h"
#import "FileManager.h"
#import "UIView+Toast.h"
#import "AOPUtils.h"

@interface DocumentViewController ()

@end

@implementation DocumentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.post.categoryName;
    [self initWebview];
    [self setBookMarkButton];
}

/**
 WebView를 초기화한다.
 */
- (void)initWebview {
    // BASE URL을 얻는다.
    FileManager *fileManager = [[FileManager alloc] init];
    NSString *path = [fileManager getAppSupportRoot];
    NSURL* baseURL = [NSURL fileURLWithPath:path];

    // WebView 들어갈 html콘텐츠를 구성
    NSString *html= [NSString stringWithFormat:@"%@%@%@",
                     @"<html><head><link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\"/></head><body>",
                     self.post.content,
                     @"</body></html>"];
    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
    
    self.webView.delegate = self;
    [self.webView loadData:data MIMEType: @"text/html" textEncodingName: @"UTF-8" baseURL:baseURL];
}

/**
 북마크 버튼을 설정한다.
 */
- (void)setBookMarkButton {
    NSString *imageName;
    imageName = (self.post.isBookMarked) ? @"bookmarked" : @"bookmark_removed";
    [self.btnBookmark setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    UIBarButtonItem *bookMark = [[UIBarButtonItem alloc] initWithCustomView:self.btnBookmark];
    self.navigationItem.rightBarButtonItem = bookMark;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self setBookMarkButton];
}

/**
 a링크가 클릭 되었을 때 참조할 웹문서 페이지를 띄운다.
 */
- (void)showReferenceWebViewWithUrl:(NSString*)url {
    RefWebViewController *vc = [[RefWebViewController alloc] initWithNibName:@"RefWebViewController" bundle:nil];
    vc.startUrl = url;
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:naviVC animated:YES completion:nil];
}

- (void)showToast:(BOOL)isBookMarked
{
    NSString *text = (isBookMarked)?@"북마크가 저장되었습니다.":@"북마크가 해제되었습니다.";
    [self.view showToast:[AOPUtils getToastView:text]
                duration:1.5f
                position:CSToastPositionBottom];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityIndicator setHidden:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *urlString = [[request URL] absoluteString];
    
    // 본 문서 내용은 로컬 캐싱된 것을 가져옴으로 http로 시작하지 않는다
    if (![urlString hasPrefix:@"http"]) {
        return YES;
    }
    
    [self showReferenceWebViewWithUrl:urlString];
    return NO;
}

/**
 북마크 버튼 클릭 시 
 */
- (IBAction)btnBookMarkTouched:(id)sender {
    BOOL isBookMarked = !self.post.isBookMarked;
    self.post.isBookMarked = isBookMarked;
    [[AOPContentsManager sharedManager] setBookMark:self.post.postId isBookMakred:self.post.isBookMarked];
    [self setBookMarkButton];
    [self showToast:isBookMarked];
}
@end
