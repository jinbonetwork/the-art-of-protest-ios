//
//  ManualViewController.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 6..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "ManualViewController.h"
#import "ContentViewController.h"

@interface ManualViewController ()

@end

@implementation ManualViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goToNext:(id)sender {
    ContentViewController *vc = [[ContentViewController alloc] initWithNibName:@"ContentViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
@end