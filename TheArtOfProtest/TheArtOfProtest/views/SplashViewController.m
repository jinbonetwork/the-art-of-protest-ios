//
//  SplashViewController.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 25..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "SplashViewController.h"
#import "AOPContentsManager.h"

@interface SplashViewController (){
    double mStartTime;
}
@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initialize];
    mStartTime = CACurrentMediaTime();
}

- (void)initUI {
    NSString *imageName = @"";
    if (IS_IPHONE_6P) {
        imageName = @"SplashImage_ip6p";
    } else if (IS_IPHONE_6) {
        imageName = @"SplashImage_ip6";
    } else if (IS_IPHONE_5) {
        imageName = @"SplashImage_ip5";
    } else {
        imageName = @"SplashImage";
    }
    
    [self.progressMessage.layer setCornerRadius:6.0f];
    self.progressMessage.clipsToBounds = true;
    [self.splashImage setImage:[UIImage imageNamed:imageName]];
}

- (void)initialize {
    AOPContentsManager *contentsManager = [AOPContentsManager sharedManager];
    
    //  앱의 기본 내용이 초기화가 안되어 있으면 초기화
    if (![contentsManager isAppInitialized]) {
        [contentsManager initApp];
    } else {
        // 초기화가 되어있을 경우 CSS업데이트가 필요한지만 판단한다.
        [contentsManager updateCSSIfNeeded];
    }
    
    // 콘텐츠를 초기화 하거나 업데이트 한다.
    if ([contentsManager isContentInitialized]) {
        [self loadAndUpdateContents];
    } else {
        [self initializeContents];
    }
}

/**
 최초로 콘텐츠를 초기화 한다.
 */
- (void)initializeContents {
    [self.progressMessage setText:@"카테고리 초기화 중..."];
    
    AOPContentsManager *contentsManager = [AOPContentsManager sharedManager];
    [contentsManager initContents:^{
        [self.progressMessage setText:@"업데이트 확인 중..."];
        [self loadNotice];
    } progress:^(NSInteger percent) {
        if (percent == -1) {
            [self.progressMessage setText:@"콘텐츠를 받아오는 중..."];
        } else if (percent == -2) {
            [self.progressMessage setText:@"콘텐츠 초기화 중... 0%"];
        } else {
            [self.progressMessage setText:[NSString stringWithFormat:@"콘텐츠 초기화 중... %d%@",percent,@"%"]];
        }
    } failure:^(NSError *error) {
        [self loadNotice];
    }];
}

/**
 최초 초기화가 된 경우 호출되는 메소드. DB에서 콘텐츠를 불러오고 업데이트가 필요할 경우 업데이트 한다.
 */
- (void)loadAndUpdateContents {
    AOPContentsManager *contentsManager = [AOPContentsManager sharedManager];
    [contentsManager loadCategoryAndPosts];
    [self.progressMessage setText:@"업데이트 확인 중..."];
    [contentsManager checkUpdate:^(BOOL needUpdate, NSString* modifiedDate) {
        // 업데이트 필요 여부를 확인하는데만 3.5초 이상이 걸리면 네트워크가 느린 것이라 판단하여 바로 홈화면으로 간다.
        double timeElapsed = CACurrentMediaTime() - mStartTime;
        if (timeElapsed > 3.5) {
            [self.appInitDelegate checkAndInitAppDone];
            return;
        }
        if (needUpdate) {
            [self.progressMessage setText:@"업데이트 중..."];
            [contentsManager updateContents:^{
                [self loadNotice];
            } failure:^(NSError *error) {
                [self loadNotice];
            }];
        } else {
            [self loadNotice];
        }
    }];
}

/**
공지를 가져온다. 공지가져오기까지 끝나면 필요할 경우 홈 화면 업데이트를 한다.
 */
- (void)loadNotice {
    AOPContentsManager *contentsManager = [AOPContentsManager sharedManager];
    [contentsManager loadNotice:^{
        [self checkAndUpdateHomePage];
    }];
}

/**
 홈 화면의 업데이트가 필요하면 업데이트를 진행한다. 이 작업이 끝나면 스플래쉬 화면을 벗어난다.
 */
- (void)checkAndUpdateHomePage {
    AOPContentsManager *contentsManager = [AOPContentsManager sharedManager];
    [contentsManager checkAndUpdateHomePage:^{
        [self.appInitDelegate checkAndInitAppDone];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
