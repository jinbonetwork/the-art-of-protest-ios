//
//  DocumentViewController.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 8. 1..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "DocumentViewController.h"
#import "FileManager.h"

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
    imageName = (self.post.isBookMarked) ? @"bookmark_marked" : @"bookmark_unmarked";
    [self.btnBookmark setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    UIBarButtonItem *bookMark = [[UIBarButtonItem alloc] initWithCustomView:self.btnBookmark];
    self.navigationItem.rightBarButtonItem = bookMark;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityIndicator setHidden:YES];
}

/**
 북마크 버튼 클릭 시 
 */
- (IBAction)btnBookMarkTouched:(id)sender {
    BOOL isBookMarked = !self.post.isBookMarked;
    self.post.isBookMarked = isBookMarked;
    [[AOPContentsManager sharedManager] setBookMark:self.post.postId isBookMakred:self.post.isBookMarked];
    [self setBookMarkButton];
}
@end
