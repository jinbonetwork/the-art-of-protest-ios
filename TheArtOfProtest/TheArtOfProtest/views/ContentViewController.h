//
//  ContentViewController.h
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 12..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AOPContentsManager.h"
#import "PostItem.h"

/**
 문서를 보는 화면
 */
@interface ContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) PostItem *post;
@property (strong, nonatomic) IBOutlet UIButton *btnBookMark;
- (IBAction)btnBookMarkTouched:(id)sender;
@end
