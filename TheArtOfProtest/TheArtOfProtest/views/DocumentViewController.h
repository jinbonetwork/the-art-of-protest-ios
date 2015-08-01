//
//  DocumentViewController.h
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 8. 1..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AOPContentsManager.h"
#import "PostItem.h"

/**
 WebView를 통해 문서를 보여주는 창
 */
@interface DocumentViewController : UIViewController <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *btnBookmark;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) PostItem *post;
- (IBAction)btnBookMarkTouched:(id)sender;
@end
