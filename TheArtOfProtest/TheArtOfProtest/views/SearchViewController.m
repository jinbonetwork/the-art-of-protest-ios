//
//  SearchViewController.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 8. 1..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "SearchViewController.h"
#import "AOPContentsManager.h"
#import "SearchResultCell.h"
#import "PostItem.h"
#import "ContentViewController.h"

@interface SearchViewController ()
@property (strong, nonatomic) NSArray *searchedPosts;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchedPosts = [NSArray array];
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
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    BOOL selectable = self.tableView.allowsSelection;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    self.tableView.allowsSelectionDuringEditing = YES;
    
    [self.view addGestureRecognizer:tap];
}

#pragma mark - Search Bar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *keyword = searchBar.text;
    self.searchedPosts = [[AOPContentsManager sharedManager] searchPostsWithKeyword:keyword];
    [self.tableView reloadData];
    [self dismissKeyboard];
}

#pragma mark - TableView Related Delgates

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchedPosts == nil) {
        return 0;
    }
    return self.searchedPosts.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView
                  cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchResultCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SearchResultCell" bundle:nil] forCellReuseIdentifier:@"searchResultCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"searchResultCell"];
    }
    
    PostItem *item = [self.searchedPosts objectAtIndex:indexPath.row];
    cell.titleLabel.text = item.title;
    cell.excerptLable.text = item.excerpt;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PostItem *item = [self.searchedPosts objectAtIndex:indexPath.row];
    
    ContentViewController *contentVC =
    [[ContentViewController alloc] initWithNibName:@"ContentViewController" bundle:nil];
    [contentVC setContent:item.content];
    
    [self.navigationController pushViewController:contentVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 106;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dismissKeyboard {
    [self.searchBar resignFirstResponder];
}

@end
