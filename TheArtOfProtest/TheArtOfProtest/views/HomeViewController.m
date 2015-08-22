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
#import "NoticeViewController.h"
#import "DocumentViewController.h"

@interface HomeViewController ()
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://theartofprotest.jinbo.net/home.html"]];
    [self initNoticeView];
    
    self.webView.delegate = self;
    [self.webView loadRequest:request];
    [self.navigationController setNavigationBarHidden:YES];
}

/**
 
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
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
    
    [self.btnNotice setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]] forState:UIControlStateHighlighted];
}

/**
 문서보기 창으로 이동한다.
 */
- (void)moveToDocumentView:(NSInteger)postId {
    AOPContentsManager *manager = [AOPContentsManager sharedManager];
    for(PostItem* post in manager.postList) {
        if (postId == post.postId) {
            DocumentViewController *vc = [[DocumentViewController alloc] initWithNibName:@"DocumentViewController" bundle:nil];
            vc.post = post;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
    }
}

/**
 UIButton이 Click 되었을 때 배경 색 변화를 위해 사용하는 메소드
 */
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.indicator setHidden:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *urlString = [[request URL] absoluteString];
    // 최초 로딩 시에는 그냥 리턴한다.
    if (![urlString hasPrefix:@"linkto"]) {
        return YES;
    }
    NSString *postIdStr =
        [urlString stringByReplacingOccurrencesOfString:@"linkto:" withString:@""];
    NSInteger postId = [postIdStr integerValue];
    [self moveToDocumentView:postId];
    return NO;
}
#pragma mark - IBActions

/**
 공지가 Toauch 되었을 때 
 */
- (IBAction)noticeTouched:(id)sender {
    NoticeViewController *vc = [[NoticeViewController alloc] initWithNibName:@"NoticeViewController" bundle:nil];
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navigationVC animated:YES completion:nil];
}
@end
