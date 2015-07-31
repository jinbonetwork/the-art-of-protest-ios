//
//  SearchViewController.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 8. 1..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "SearchViewController.h"
#import "AOPContentsManager.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayout];
}

/**
 레이아웃을 초기화한다.
 */
- (void)initLayout {
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    [self.searchBar sizeToFit];
    self.searchBar.delegate = self;
    
    self.navigationItem.titleView = self.searchBar;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

#pragma mark - Search Bar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *keyword = searchBar.text;
    NSArray* searchResult = [[AOPContentsManager sharedManager] searchPostsWithKeyword:keyword];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [self.searchBar resignFirstResponder];
}

@end
