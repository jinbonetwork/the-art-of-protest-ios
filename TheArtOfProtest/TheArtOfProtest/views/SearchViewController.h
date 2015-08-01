//
//  SearchViewController.h
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 8. 1..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISearchBar *searchBar;
@end
