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
#import "MainTabBarController.h"

@interface HomeViewController ()
@end

//@"http://theartofprotest.jinbo.net/home.html"
@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FileManager *fileManager = [[FileManager alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[fileManager getHomeHtmlFilePath]]];
    [self initNoticeView];
    
    self.webView.delegate = self;
    [self.webView loadRequest:request];
    [self.navigationController setNavigationBarHidden:YES];
}

/**
 네비게이션바가 첫화면에서는 안보이고 문서 보기창으로 이동했을 때만 나타나돌록 아래 두 메소드를 override한다.
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    AOPContentsManager *manager = [AOPContentsManager sharedManager];
    // 앱이 초기화 되지 않았으면 알림을 띄운다.
    if (![manager isContentInitialized] || manager.postList == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"초기화 필요"
                                                    message:@"콘텐츠가 초기화되지 않았습니다. 네트워크가 연결된 상황에서 다시 앱을 시작하여 콘텐츠를 초기화하셔야 합니다."
                                                   delegate:self
                                              cancelButtonTitle:@"취소"
                                              otherButtonTitles:@"초기화", nil];
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 알림창에서 초기화 버튼을 눌렀을 때
    if (buttonIndex == 1) {
        [self backToSplashToInitialize];
    }
}

- (void)backToSplashToInitialize {
    MainTabBarController *tabVC = (MainTabBarController *)self.tabBarController;
    [tabVC.appInitDelegate backToSplash];
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
    if (![manager isContentInitialized] || manager.postList == nil) {
        return;
    }
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
