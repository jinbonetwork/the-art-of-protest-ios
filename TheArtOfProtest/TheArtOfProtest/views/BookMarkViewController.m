//
//  BookMarkViewController.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 8. 2..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "BookMarkViewController.h"
#import "AOPContentsManager.h"
#import "BookMarkCell.h"
#import "PostItem.h"
#import "DocumentViewController.h"
#import "AOPUtils.h"
#import "UIView+Toast.h"

@interface BookMarkViewController ()

@property (strong, nonatomic) NSArray *bookMarkPosts;

@end

@implementation BookMarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
}

/**
 TableView를 초기화 한다.
 */
- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateTableViewContents];
}

/**
 TableView 콘텐츠 내용을 업데이트 한다.
 */
- (void)updateTableViewContents {
    self.bookMarkPosts = [[AOPContentsManager sharedManager] getBookMarkedPost];
    if (self.bookMarkPosts == nil || self.bookMarkPosts.count == 0) {
        [self showNoBookMarkUI];
    } else {
        [self showBookMarkListUI];
    }
}

/**
 북마크 된 것이 없을 때 나타내는 UI를 보여준다.
 */
- (void)showNoBookMarkUI {
    [self.labelNoResult1 setHidden:NO];
    [self.labelNoResult2 setHidden:NO];
    [self.iconNoResult setHidden:NO];
    [self.imgNoResult setHidden:NO];
    [self.tableView setHidden:YES];
}

/**
 북마크 목록을 나타내는 UI를 보여준다.
 */
- (void)showBookMarkListUI {
    [self.labelNoResult1 setHidden:YES];
    [self.labelNoResult2 setHidden:YES];
    [self.iconNoResult setHidden:YES];
    [self.imgNoResult setHidden:YES];
    [self.tableView setHidden:NO];
    [self.tableView reloadData];
}

/**
 Cell 아이템 안의 bookMark 버튼이 눌리었을 때
 */
- (void)bookMarkBtnTouched:(UIButton*)sender {
    AOPContentsManager *contentManager = [AOPContentsManager sharedManager];
    NSInteger idx = sender.tag;
    
    PostItem *post = [self.bookMarkPosts objectAtIndex:idx];
    BOOL changeBookMarked = !post.isBookMarked;
    
    post.isBookMarked = changeBookMarked;
    [contentManager setBookMark:post.postId isBookMakred:changeBookMarked];
    
    NSString *imageName = (changeBookMarked)? @"bookmarked" : @"bookmark_removed";
    [sender setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    [self showToast:changeBookMarked];
}

- (void)showToast:(BOOL)isBookMarked
{
    NSString *text = (isBookMarked)?@"북마크가 저장되었습니다.":@"북마크가 해제되었습니다.";
    [self.view showToast:[AOPUtils getToastView:text]
                duration:1.5f
                position:CSToastPositionBottom];
}

#pragma mark - tableview related delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.bookMarkPosts == nil) {
        return 0;
    }
    return self.bookMarkPosts.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    static NSString *CellIdentifier = @"bookMarkCell";
    BookMarkCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil ) {
        cell = (BookMarkCell*)[[[NSBundle mainBundle] loadNibNamed:@"BookMarkCell" owner:self options:nil] objectAtIndex:0];
    }
    PostItem *item = [self.bookMarkPosts objectAtIndex:indexPath.row];
    cell.titleLabel.text = item.title;
    cell.excerptLabel.text = item.excerpt;
    cell.btnBookMark.tag = indexPath.row;
    NSString *imageName = (item.isBookMarked)? @"bookmarked" : @"bookmark_removed";
    [cell.btnBookMark setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [cell.btnBookMark addTarget:self action:@selector(bookMarkBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

/**
 동적 Cell 높이를 지정하기 위해 Cell의 높이를 계산해서 반환한다.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostItem *item = [self.bookMarkPosts objectAtIndex:indexPath.row];
    NSString *str = item.excerpt;
    
    CGFloat width = self.view.frame.size.width - 52;
    UIFont *font = [UIFont systemFontOfSize:15.0f];
    NSAttributedString *attributeText = [[NSAttributedString alloc] initWithString:str
                                                                        attributes:@{NSFontAttributeName: font}];
    CGRect rect = [attributeText boundingRectWithSize:(CGSize){width,CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGSize size = rect.size;
    
    return size.height + 47.0f;
}

/**
 Cell이 선택되었을 때는 document View 창으로 이동한다.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PostItem *item = [self.bookMarkPosts objectAtIndex:indexPath.row];
    DocumentViewController *documentVC =
    [[DocumentViewController alloc] initWithNibName:@"DocumentViewController" bundle:nil];
    [documentVC setPost:item];
    [self.navigationController pushViewController:documentVC animated:YES];
}

@end
