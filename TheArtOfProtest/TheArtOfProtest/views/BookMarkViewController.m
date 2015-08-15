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
    
    UIImage *image;
    if(changeBookMarked) {
        image = [UIImage imageNamed:@"bookmarked"];
    } else {
        image = [UIImage imageNamed:@"bookmark_removed"];
    }
    [sender setImage:image forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    CGFloat width = self.view.frame.size.width - 50;
    UIFont *font = [UIFont systemFontOfSize:15.0f];
    NSAttributedString *attributeText = [[NSAttributedString alloc] initWithString:str
                                                                        attributes:@{NSFontAttributeName: font}];
    CGRect rect = [attributeText boundingRectWithSize:(CGSize){width,CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGSize size = rect.size;
    
    return size.height + 45.0f;
}

@end
