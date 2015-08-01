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
#import "PostCacheWorker.h"

#define USER_DEFAULT_KEY_APP_INITED      @"user_default_key_app_inited"
#define USER_DEFAULT_KEY_CONTENTS_INITED @"user_default_key_contents_inited"
#define USER_DEFAULT_KEY_LAST_MODIFIED   @"user_default_key_last_modified"

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
- (void)sortCategoryAndPosts;

@end

@implementation AOPContentsManager

@synthesize lastModified = _lastModified;

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
    [self.fileManager copyBundleFilesToAppSupportDir];

    // 레지스트리값 저장
    NSUserDefaults *sud = [NSUserDefaults standardUserDefaults];
    [sud setBool:YES forKey:USER_DEFAULT_KEY_APP_INITED];
    [sud synchronize];
}


/**
 콘텐츠가 최초 한번이라도 초기화 되었는지 확인한다.
 */
- (BOOL)isContentInitialized {
    NSUserDefaults *sud = [NSUserDefaults standardUserDefaults];
    return [sud boolForKey:USER_DEFAULT_KEY_CONTENTS_INITED];
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
        [self cachePosts];
        [self saveCategoryAndPosts];
        
        NSUserDefaults *sud = [NSUserDefaults standardUserDefaults];
        [sud setBool:YES forKey:USER_DEFAULT_KEY_CONTENTS_INITED];
        [sud synchronize];
        self.initContentsSuccess();
    } failure:^(NSError *error) {
        self.initContentsFailure(error);
    }];
}

/**
 카테고리 메뉴 목록과 Post(문서) 목록을 앱에서 사용할 수 있도록 정제한다.
 */
- (void)rectifyCategoryAndPosts {
    
    // Category 가 가지고 있는 첫번째 Post의 Menu Order를 Category Order로 정한다.
    for (CategoryMenuItem *category in self.categoryMenuList) {
        for (PostItem *post in self.postList) {
            if(post.categoryId == category.categoryID) {
                category.categoryOrder = post.menuOrder;
                break;
            }
        }
    }
    
    // post와 category를 정렬한다.
    [self sortCategoryAndPosts];
    
    // HTML로 부터 plain 문자열을 얻는다.
    for (PostItem *post in self.postList) {
        post.excerpt = [[[NSAttributedString alloc]
                        initWithData:
                        [post.excerpt dataUsingEncoding:NSUTF8StringEncoding]
                        options:@{
                                  NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                  NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]}
                        documentAttributes:nil error:nil] string];
    }
}

/**
 카테고리와 Post 목록을 정렬한다.
 */
- (void)sortCategoryAndPosts {
    
    // post 들을 Menu Order 순으로 정렬한다.
    NSSortDescriptor *postSortDescriptor =
    [NSSortDescriptor sortDescriptorWithKey:@"menuOrder" ascending:YES];
    self.postList = [self.postList
                     sortedArrayUsingDescriptors:@[postSortDescriptor]];

    // category 들을 Cetegory Order 순으로 정렬한다.
    NSSortDescriptor *categorySortDescriptor =
    [NSSortDescriptor sortDescriptorWithKey:@"categoryOrder" ascending:YES];
    self.categoryMenuList = [self.categoryMenuList
                             sortedArrayUsingDescriptors:@[categorySortDescriptor]];
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
        // lastModified 값이 더 크면 갱신
        if (self.lastModified == nil || [post.modified compare:self.lastModified] == NSOrderedDescending) {
            self.lastModified = post.modified;
        }
    }
}

/**
 문서들을 캐싱한다.
 */
- (void)cachePosts {
    
    PostCacheWorker *worker = [[PostCacheWorker alloc] init];
    
    for (PostItem* post in self.postList) {
        NSString *newContent = [worker cachePost:post];
        post.content = newContent;
    }
}

/**
 카테고리와 메뉴 목록을 DB로 부터 불러온다.
 */
- (void) loadCategoryAndPosts {
    self.categoryMenuList = [self.coreDataManager getAllCategoryMenu];
    self.postList = [self.coreDataManager getAllPosts];
    [self sortCategoryAndPosts];
}

/**
 특정 keyword를 가진 post 목록을 가져온다
 */
- (NSArray*)searchPostsWithKeyword:(NSString*)keyword {
    return [self.coreDataManager searchPostsWithKeyword:keyword];
}

/**
 해당 postId에 BookMark를 설정한다.
 */
- (void)setBookMark:(NSInteger)postId isBookMakred:(BOOL)isBookMarked {
    for (PostItem *post in self.postList) {
        if (post.postId == postId) {
            post.isBookMarked = isBookMarked;
            [self.coreDataManager insertPost:post];
            break;
        }
    }
}

/**
 문서 및 카테고리 전체의 최신 수정 날짜를 가져온다. 이를 통해 업데이트 여부를 판별
 */
- (NSString*)lastModified {
    if (_lastModified == nil) {
        NSUserDefaults *sud = [NSUserDefaults standardUserDefaults];
        _lastModified = [sud valueForKey:USER_DEFAULT_KEY_LAST_MODIFIED];
    }
    return _lastModified;
}

/**
 문서 및 카테고리 전체의 최신 수정 날짜를 설정한다. 이를 통해 업데이트 여부를 판별
 */
- (void)setLastModified:(NSString*)lastModified {
    if (lastModified != _lastModified && lastModified != nil) {
        NSUserDefaults *sud = [NSUserDefaults standardUserDefaults];
        [sud setValue:lastModified forKey:USER_DEFAULT_KEY_LAST_MODIFIED];
        [sud synchronize];
    }
    _lastModified = lastModified;
}

@end


