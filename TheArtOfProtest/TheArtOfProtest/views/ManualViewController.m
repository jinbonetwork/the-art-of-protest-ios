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
#import "DocumentViewController.h"
#import "ManualCell.h"

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
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

/**
 indexPath에 해당하는 postItem을 return 한다.
 */
- (PostItem*)getPostItemAtIndexPath:(NSIndexPath*)indexPath {
    PostItem *postItem = nil;
    int cnt = 0;
    NSArray *categoryMenu = [[AOPContentsManager sharedManager] categoryMenuList];
    NSArray *postList = [[AOPContentsManager sharedManager] postList];
    for(PostItem *item in postList) {
        CategoryMenuItem *category = [categoryMenu objectAtIndex:indexPath.section];
        if (item.categoryId == category.categoryID) {
            if (cnt == indexPath.row) {
                postItem = item;
                break;
            }
            cnt++;
        }
    }
    return postItem;
}

/**
 이 앱 매뉴얼에서 카테고리 및 맨 처음 아이템에서 사용되는 View를 return 한다.
 */
- (UIView*) getCustomSectionView:(NSString*)title imageName:(NSString*)imageName {
    CGFloat width = self.tableView.frame.size.width;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 135)];
    [view setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    
    UILabel *topLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 5)];
    [topLine setBackgroundColor:[UIColor colorWithRed:255/255.0 green:114/255.0 blue:0 alpha:1.0]];
    
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, width, 25)];
    [titleView setFont:[UIFont boldSystemFontOfSize:21]];
    [titleView setTextAlignment:NSTextAlignmentCenter];
    [titleView setText:title];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, width, 85)];
    imageView.image = [UIImage imageNamed:imageName];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 134, width, 1)];
    [separator setBackgroundColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:0.7]];
    
    [view addSubview:topLine];
    [view addSubview:titleView];
    [view addSubview:imageView];
    [view addSubview:separator];
    
    return view;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSArray *categoryMenu = [[AOPContentsManager sharedManager] categoryMenuList];
    if (categoryMenu == nil) {
        return 0;
    }
    return [categoryMenu count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int cnt = 0;
    NSArray *categoryMenu = [[AOPContentsManager sharedManager] categoryMenuList];
    if (categoryMenu == nil) {
        return 0;
    }
    
    NSArray *postList = [[AOPContentsManager sharedManager] postList];
    for(PostItem *item in postList) {
        CategoryMenuItem *category = [categoryMenu objectAtIndex:section];
        if (item.categoryId == category.categoryID) {
            ++cnt;
        }
    }
    return cnt;
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    static NSString *CellIdentifier = @"manualCell";
    ManualCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil ) {
        cell = (ManualCell*)[[[NSBundle mainBundle] loadNibNamed:@"ManualCell" owner:self options:nil] objectAtIndex:0];
    }
    PostItem *item = [self getPostItemAtIndexPath:indexPath];
    
    /* 맨 처음 아이템일 경우 */
    if(indexPath.row == 0 && indexPath.section == 0) {
        [cell.customView setHidden:NO];
        [cell.titleLabel setHidden:YES];
        NSArray *viewsToRemove = [cell.customView subviews];
        for (UIView *v in viewsToRemove) {
            [v removeFromSuperview];
        }
        [cell.customView addSubview:[self getCustomSectionView:item.title imageName:@"manual1"]];
    } else {
        [cell.customView setHidden:YES];
        [cell.titleLabel setHidden:NO];
        cell.titleLabel.text = item.title;
    }

    if ((indexPath.row%2) == 0) {
        CGFloat val = 247/255.0;
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:val green:val blue:val alpha:1.0]];
    } else {
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    }

    
  
    return cell;
}

/**
 동적 Cell 높이를 지정하기 위해 Cell의 높이를 계산해서 반환한다.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* 맨 처음 아이템일 경우 */
    if(indexPath.row == 0 && indexPath.section == 0) {
        return 135;
    }
    
    PostItem *item = [self getPostItemAtIndexPath:indexPath];
    NSString *str = item.title;
    
    CGFloat width = self.view.frame.size.width - 24;
    UIFont *font = [UIFont systemFontOfSize:17.0f];
    NSAttributedString *attributeText = [[NSAttributedString alloc] initWithString:str
                                                                        attributes:@{NSFontAttributeName: font}];
    CGRect rect = [attributeText boundingRectWithSize:(CGSize){width,CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGSize size = rect.size;
    
    return size.height + 24.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    NSString *imageName = [NSString stringWithFormat:@"manual%d",section+1];
    
    NSArray *categoryMenu = [[AOPContentsManager sharedManager] categoryMenuList];
    CategoryMenuItem *item = [categoryMenu objectAtIndex:section];
    return [self getCustomSectionView:[item name] imageName:imageName];
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01f;
    }
    return 135;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PostItem* postItem = [self getPostItemAtIndexPath:indexPath];
    DocumentViewController *documentVC =
        [[DocumentViewController alloc] initWithNibName:@"DocumentViewController" bundle:nil];
    [documentVC setPost:postItem];
    [self.navigationController pushViewController:documentVC animated:YES];
}
@end
