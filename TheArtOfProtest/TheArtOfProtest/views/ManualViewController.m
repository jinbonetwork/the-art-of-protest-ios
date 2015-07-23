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

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *categoryMenu = [[AOPContentsManager sharedManager] categoryMenuList];
    CategoryMenuItem *item = [categoryMenu objectAtIndex:section];
    return [item name];
}
/*
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/
@end
