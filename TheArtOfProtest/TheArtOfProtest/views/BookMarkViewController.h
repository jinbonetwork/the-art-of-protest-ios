//
//  BookMarkViewController.h
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 8. 2..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookMarkViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
