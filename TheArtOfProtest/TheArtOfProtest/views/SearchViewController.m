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
@property (strong, nonatomic) UITapGestureRecognizer *tapViewGesture;
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
    self.tapViewGesture = [[UITapGestureRecognizer alloc]
                           initWithTarget:self
                           action:@selector(dismissKeyboard)];
    [self initSearchBar];
    [self initTableView];
}

/**
 searchBar를 초기화한다.
 */
- (void)initSearchBar {
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    [self.searchBar sizeToFit];
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
}

/**
 tableView를 초기화한다.
 */
- (void)initTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Search Bar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *keyword = searchBar.text;
    self.searchedPosts = [[AOPContentsManager sharedManager] searchPostsWithKeyword:keyword];
    [self.tableView reloadData];
    [self dismissKeyboard];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.view addGestureRecognizer:self.tapViewGesture];
}

#pragma mark - TableView Related Delgates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchedPosts == nil) {
        return 0;
    }
    return self.searchedPosts.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    static NSString *CellIdentifier = @"searchResultCell";
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil ) {
        cell = (SearchResultCell*)[[[NSBundle mainBundle] loadNibNamed:@"SearchResultCell" owner:self options:nil] objectAtIndex:0];
    }
    PostItem *item = [self.searchedPosts objectAtIndex:indexPath.row];
    cell.titleLabel.text = item.title;
    cell.excerptLabel.text = item.excerpt;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PostItem *item = [self.searchedPosts objectAtIndex:indexPath.row];
    
    ContentViewController *contentVC =
    [[ContentViewController alloc] initWithNibName:@"ContentViewController" bundle:nil];
    [contentVC setPost:item];
    
    [self.navigationController pushViewController:contentVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dismissKeyboard {
    [self.searchBar resignFirstResponder];
    [self.view removeGestureRecognizer:self.tapViewGesture];
}

@end
