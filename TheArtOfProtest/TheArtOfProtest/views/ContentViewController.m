//
//  ContentViewController.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 12..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "ContentViewController.h"
#import "FileManager.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FileManager *fileManager = [[FileManager alloc] init];
    NSString *path = [fileManager getAppSupportRoot];
    NSURL* baseURL = [NSURL fileURLWithPath:path];
    
    
    NSString *html= [NSString stringWithFormat:@"%@%@%@",@"<html><head><link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\"/></head><body>",self.post.content,@"</body></html>"];

    NSLog(html);
    
    
    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
    [self.webView loadData:data MIMEType: @"text/html" textEncodingName: @"UTF-8" baseURL:baseURL];
    
    
    
    if (self.post.isBookMarked) {
        [self.btnBookMark setImage:[UIImage imageNamed:@"bookmark_marked"] forState:UIControlStateNormal];
    } else {
        [self.btnBookMark setImage:[UIImage imageNamed:@"bookmark_unmarked"] forState:UIControlStateNormal];
    }
    UIBarButtonItem *bookMark = [[UIBarButtonItem alloc] initWithCustomView:self.btnBookMark];
    self.navigationItem.rightBarButtonItem = bookMark;

}

- (void)initWebView {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 BookMark 버튼이 클릭되었을 때
 */
- (IBAction)btnBookMarkTouched:(id)sender {
    BOOL isBookMarked = !self.post.isBookMarked;
    
    self.post.isBookMarked = isBookMarked;
    [[AOPContentsManager sharedManager] setBookMark:self.post.postId isBookMakred:self.post.isBookMarked];

    if (self.post.isBookMarked) {
        [self.btnBookMark setImage:[UIImage imageNamed:@"bookmark_marked"] forState:UIControlStateNormal];
    } else {
        [self.btnBookMark setImage:[UIImage imageNamed:@"bookmark_unmarked"] forState:UIControlStateNormal];
    }
    UIBarButtonItem *bookMark = [[UIBarButtonItem alloc] initWithCustomView:self.btnBookMark];
    self.navigationItem.rightBarButtonItem = bookMark;

}
@end
