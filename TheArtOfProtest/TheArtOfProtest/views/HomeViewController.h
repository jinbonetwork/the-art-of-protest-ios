//
//  HomeViewController.h
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 6..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *labelNoticeTitle;
@property (strong, nonatomic) IBOutlet UIView *noticeView;
@property (weak, nonatomic) IBOutlet UIWebView *webViewForNotice;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIButton *btnNotice;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorForNoticeView;
- (IBAction)noticeTouched:(id)sender;

@end
