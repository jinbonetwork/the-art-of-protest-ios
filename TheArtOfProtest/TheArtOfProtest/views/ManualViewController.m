//
//  ManualViewController.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 24..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "ManualViewController.h"
#import "AOPContentsManager.h"
#import "PostItem.h"
#import "CategoryMenuItem.h"
#import "ContentViewController.h"

@interface ManualViewController ()

@end

@implementation ManualViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayout];
}

/**
 레이아웃을 초기화한다.
 */
- (void)initLayout {
    [self.navigationItem setTitle:@"매뉴얼"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSArray *categoryMenu = [[AOPContentsManager sharedManager] categoryMenuList];
    return [categoryMenu count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    int cnt = 0;
    
    NSArray *categoryMenu = [[AOPContentsManager sharedManager] categoryMenuList];
    NSArray *postList = [[AOPContentsManager sharedManager] postList];
    for(PostItem *item in postList) {
        CategoryMenuItem *category = [categoryMenu objectAtIndex:section];
        if (item.categoryId == category.categoryID) {
            ++cnt;
        }
    }
    return cnt;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   /* UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"identifier" forIndexPath:indexPath];*/
    
    UITableViewCell *cell;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifier"];
    }
    
    int cnt = 0;
    NSArray *categoryMenu = [[AOPContentsManager sharedManager] categoryMenuList];
    NSArray *postList = [[AOPContentsManager sharedManager] postList];
    for(PostItem *item in postList) {
        CategoryMenuItem *category = [categoryMenu objectAtIndex:indexPath.section];
        if (item.categoryId == category.categoryID) {
            if (cnt == indexPath.row) {
                cell.textLabel.text = item.title;
                break;
            }
            cnt++;
        }
    }

    return cell;
}

/*
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *categoryMenu = [[AOPContentsManager sharedManager] categoryMenuList];
    CategoryMenuItem *item = [categoryMenu objectAtIndex:section];
    return [item name];
}
 */

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *view = [UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 75);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 75)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 50)];
    [label setFont:[UIFont boldSystemFontOfSize:21]];
    
    NSArray *categoryMenu = [[AOPContentsManager sharedManager] categoryMenuList];
    CategoryMenuItem *item = [categoryMenu objectAtIndex:section];
    NSString *string = [item name];
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:1/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 75;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int cnt = 0;
    NSString* content = @"";
    
    NSArray *categoryMenu = [[AOPContentsManager sharedManager] categoryMenuList];
    NSArray *postList = [[AOPContentsManager sharedManager] postList];
    for(PostItem *item in postList) {
        CategoryMenuItem *category = [categoryMenu objectAtIndex:indexPath.section];
        if (item.categoryId == category.categoryID) {
            if (cnt == indexPath.row) {
                content = item.content;
            }
            cnt++;
        }
    }
    
    ContentViewController *contentVC =
        [[ContentViewController alloc] initWithNibName:@"ContentViewController" bundle:nil];
    [contentVC setContent:content];
    
    [self.navigationController pushViewController:contentVC animated:YES];
     
}
@end
