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

    self.bookMarkPosts = [[AOPContentsManager sharedManager] getBookMarkedPost];
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
    return cell;
}

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
