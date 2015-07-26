//
//  AOPContentsManager.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 24..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "AOPContentsManager.h"
#import "ServerCommunicator.h"
#import "CoreDataManager.h"
#import "FileManager.h"

#define USER_DEFAULT_KEY_APP_INITED      @"user_default_key_app_inited"
#define USER_DEFAULT_KEY_CONTENTS_INITED @"user_default_key_contents_inited"

@interface AOPContentsManager ()

// 서버, DB, 파일 시스템과 통신하기 위한 모듈들
@property (nonatomic, strong) ServerCommunicator *serverCommunicator;
@property (nonatomic, strong) CoreDataManager *coreDataManager;
@property (nonatomic, strong) FileManager *fileManager;

// block 구문들을 나중에 호출하기 위하여 property에 기억시켜 놓는다.
@property (copy) void (^initContentsSuccess)(void);
@property (copy) void (^initContentsProgress)(NSInteger percent);
@property (copy) void (^initContentsFailure)(NSError *error);


// private method들. 주석은 implementation 된 곳에서 볼 수 이따고 한다.
- (void)getPostsFromServerForInit;
- (void)rectifyCategoryAndPosts;
- (void)saveCategoryAndPosts;

@end

@implementation AOPContentsManager

/**
 AOPContents Manager의 싱글톤 객체를 반환한다.
 */
+ (id)sharedManager {
    static AOPContentsManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

/**
 객체 초기화
 */
- (id)init {
    if (self = [super init]) {
        _serverCommunicator = [[ServerCommunicator alloc] init];
        _coreDataManager = [[CoreDataManager alloc] init];
        _fileManager = [[FileManager alloc] init];
    }
    return self;
}

/**
 앱의 기본 내용들이 초기화 되었는지 확인한다. ex)필요한 리소스 파일들 Application Support 폴더로 옮기기 등
 */
- (BOOL)isAppInitialized {
    NSUserDefaults *sud = [NSUserDefaults standardUserDefaults];
    return [sud boolForKey:USER_DEFAULT_KEY_APP_INITED];
}

/**
 앱의 기본 내용들 초기화 한다.
 */
- (void)initApp {
    // 파일 시스템 초기화
    [self.fileManager initFileSystem];

    // 레지스트리값 저장
    NSUserDefaults *sud = [NSUserDefaults standardUserDefaults];
    [sud setBool:YES forKey:USER_DEFAULT_KEY_APP_INITED];
    [sud synchronize];
}


/**
 최초로 콘텐츠를 초기화 한다.  
 1) 카테고리 메뉴 API 호출
 2) Posts(문서) API 호출
 3) 카테고리 및 Posts 정제
 4) DB 삽입
 5) 이미지 및 리소스 캐싱
 */
- (void)initContents:(void(^)(void))success
            progress:(void(^)(NSInteger percent))progress
             failure:(void(^)(NSError *error))failure {

    self.initContentsSuccess = success;
    self.initContentsProgress = progress;
    self.initContentsFailure = failure;
    
    [self.serverCommunicator getCategoryMenusAsync:^(NSArray *categoryMenuList) {
        self.categoryMenuList = categoryMenuList;
        [self getPostsFromServerForInit];
    } failure:^(NSError *error) {
        self.initContentsFailure(error);
    }];
}

/**
 서버로 부터 Post 문서목록들을 받아온다
 */
- (void)getPostsFromServerForInit {
    [self.serverCommunicator getPostsAsync:^(NSArray *postList) {
        self.postList = postList;
        [self rectifyCategoryAndPosts];
        [self saveCategoryAndPosts];
    } failure:^(NSError *error) {
        self.initContentsFailure(error);
    }];
}

/**
 카테고리 메뉴 목록과 Post(문서) 목록을 앱에서 사용할 수 있도록 정제한다.
 */
- (void)rectifyCategoryAndPosts {
    
    // post 들을 Menu Order 순으로 정렬한다.
    NSSortDescriptor *postSortDescriptor =
        [NSSortDescriptor sortDescriptorWithKey:@"menuOrder" ascending:YES];
    self.postList = [self.postList
                     sortedArrayUsingDescriptors:@[postSortDescriptor]];
    
    
    // Category 가 가지고 있는 첫번째 Post의 Menu Order를 Category Order로 정한다.
    for (CategoryMenuItem *category in self.categoryMenuList) {
        for (PostItem *post in self.postList) {
            if(post.categoryId == category.categoryID) {
                category.categoryOrder = post.menuOrder;
                break;
            }
        }
    }
    
    // category 들을 Cetegory Order 순으로 정렬한다.
    NSSortDescriptor *categorySortDescriptor =
        [NSSortDescriptor sortDescriptorWithKey:@"categoryOrder" ascending:YES];
    self.categoryMenuList = [self.categoryMenuList
                             sortedArrayUsingDescriptors:@[categorySortDescriptor]];
    
    int debug = 1;
}

/**
 카테고리와 메뉴 목록을 DB에 저장한다.
 */
- (void)saveCategoryAndPosts {
    for (CategoryMenuItem *category in self.categoryMenuList) {
        [self.coreDataManager insertCategoryMenu:category];
    }
    for (PostItem *post in self.postList) {
        [self.coreDataManager insertPost:post];
    }
    self.initContentsSuccess();
}
@end




