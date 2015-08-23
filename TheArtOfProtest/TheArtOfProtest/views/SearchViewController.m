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
#import "DocumentViewController.h"

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
    self.searchBar.placeholder = @"검색어를 입력하세요";
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

/**
 해당 keyword의 검색 결과를 보여준다.
 */
- (void)showSearchResultForKeyword:(NSString*)keyword {
    self.searchedPosts = [[AOPContentsManager sharedManager] searchPostsWithKeyword:keyword];
    if (self.searchedPosts == nil || self.searchedPosts.count == 0) {
        [self.imgNoResult setHidden:NO];
        [self.labelNoResult setHidden:NO];
        [self.tableView setHidden:YES];
    } else {
        [self.imgNoResult setHidden:YES];
        [self.labelNoResult setHidden:YES];
        [self.tableView setHidden:NO];
        [self.tableView reloadData];
    }
}

#pragma mark - Search Bar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self dismissKeyboard];
    [self showSearchResultForKeyword:searchBar.text];
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
    
    DocumentViewController *documentVC =
    [[DocumentViewController alloc] initWithNibName:@"DocumentViewController" bundle:nil];
    [documentVC setPost:item];
    [self.navigationController pushViewController:documentVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostItem *item = [self.searchedPosts objectAtIndex:indexPath.row];
    NSString *str = item.excerpt;
    
    CGFloat width = self.view.frame.size.width - 24;
    UIFont *font = [UIFont systemFontOfSize:15.0f];
    NSAttributedString *attributeText = [[NSAttributedString alloc] initWithString:str
                                                                        attributes:@{NSFontAttributeName: font}];
    CGRect rect = [attributeText boundingRectWithSize:(CGSize){width,CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGSize size = rect.size;
    
    return size.height + 51.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dismissKeyboard {
    [self.searchBar resignFirstResponder];
    [self.view removeGestureRecognizer:self.tapViewGesture];
}

@end
