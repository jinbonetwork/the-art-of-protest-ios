//
//  RefWebViewController.h
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 8. 16..
//  Copyright (c) 2015년 JinboNet. All rights reserved
//

#import <UIKit/UIKit.h>

@interface RefWebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate>

@property (copy, nonatomic) NSString *startUrl;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UILabel *disconnectErrorLabel;
@property (strong, nonatomic) IBOutlet UIButton *btnShare;
- (IBAction)closeBtnTouched:(id)sender;
- (IBAction)shareBtnTouched:(id)sender;

@end
