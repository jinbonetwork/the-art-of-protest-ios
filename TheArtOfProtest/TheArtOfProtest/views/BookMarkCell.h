//
//  BookMarkCell.h
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 8. 2..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookMarkCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *excerptLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnBookMark;

@end 