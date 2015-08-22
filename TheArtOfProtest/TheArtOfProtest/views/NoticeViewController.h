//
//  NoticeViewController.h
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 8. 16..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeItem.h"

@interface NoticeViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIButton *btnClose;
@property (strong, nonatomic) NoticeItem* noticeItem;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
- (IBAction)btnCloseTouched:(id)sender;

@end
