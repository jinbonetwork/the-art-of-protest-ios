//
//  AOPContentsManager.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 24..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "AOPContentsManager.h"


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

@property (nonatomic, strong) NSString* lastModifiedRemote;

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
        [self saveCategoryMenuList];
        [self savePosts];
        
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
        post.excerpt = [self getPlainStringFromHtmlString:post.excerpt];
    }
}

/**
 HTML 문자열로 부턴 Plain Text만 얻어낸다.
 */
- (NSString*) getPlainStringFromHtmlString:(NSString*)htmlString {
    return [[[NSAttributedString alloc]
             initWithData:
             [htmlString dataUsingEncoding:NSUTF8StringEncoding]
             options:@{
                       NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                       NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]}
             documentAttributes:nil error:nil] string];
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
 카테고리 목록을 DB에 저장한다.
 */
- (void)saveCategoryMenuList {
    for (CategoryMenuItem *category in self.categoryMenuList) {
        [self.coreDataManager insertCategoryMenu:category];
    }
}

/**
 포스트를 DB에 저장하고 필요한 자료들을 Caching 한다.
 */
- (void)savePosts {
    
    PostCacheWorker *worker = [[PostCacheWorker alloc] init];
    
    for (PostItem *post in self.postList) {
        // Caching
        NSString *newContent = [worker cachePost:post];
        post.content = newContent;
        
        // DB 삽입
        [self.coreDataManager insertPost:post];
        
        // lastModified 값이 더 크면 갱신
        if (self.lastModified == nil || [post.modified compare:self.lastModified] == NSOrderedDescending) {
            self.lastModified = post.modified;
        }
    }
}

/**
 콘텐츠 업데이트가 필요한지 확인한다.
 */
- (void)checkUpdate:(void(^)(BOOL needUpdate, NSString *modifiedDate))done {
    [self.serverCommunicator getVersionAsync:^(NSString *modified) {
        BOOL needUpdate = (self.lastModified == nil || [modified compare:self.lastModified] == NSOrderedDescending);
        self.lastModifiedRemote = modified;
        done(needUpdate,modified);
    } failure:^(NSError *error) {
        done(NO,nil); // 버전체크에 실패한 경우는 일단 후에 요청도 실패할 확률이 높으므로 스킵하도록 한다.
    }];
}

/**
 콘텐츠를 업데이트 한다.
 */
- (void)updateContents:(void(^)(void))success
               failure:(void(^)(NSError *error))failure {
    
    [self loadCategoryAndPosts];
    
    [self.serverCommunicator getPostsAsync:^(NSArray *postList) {
        
        PostCacheWorker *cacheWorker = [[PostCacheWorker alloc] init];
        for (PostItem *currPost in postList) {
            
            BOOL isUpdatedPost = YES;
            PostItem *prevPost = [self getPostHasId:currPost.postId];
            if (prevPost != nil) {
                if([currPost.modified isEqualToString:prevPost.modified]) {
                    isUpdatedPost = NO;
                }
                currPost.isBookMarked = prevPost.isBookMarked;
            }
            
            if (isUpdatedPost) { // 새 포스트(업데이트 또는 새로추가) 의 경우에는 필요한 작업들을 해준다.
                currPost.excerpt = [self getPlainStringFromHtmlString:currPost.excerpt];
                [cacheWorker cachePost:currPost];
                [self.coreDataManager insertPost:currPost];
            }
        }
        
        //기존 postList에 새 postList 대입하고 다시 정렬을 한 번 해준다.
        self.postList = postList;
        [self sortCategoryAndPosts];
        
        //최종 업데이트 날짜 수정
        if (self.lastModifiedRemote != nil) {
            [self setLastModified:self.lastModifiedRemote];
        }
        success();
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/**
 해당 ID를 가진 post를 가져온다.
 */
- (PostItem*)getPostHasId:(NSInteger)postId {
    for (PostItem* post in self.postList) {
        if (post.postId == postId)
            return post;
    }
    return nil;
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
 북마크된 콘텐츠 목록을 가져온다.
 */
- (NSArray*)getBookMarkedPost {
    return [self.coreDataManager getBookMarkedPost];
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

/**
 공지를 불러온다.
 */
- (void)loadNotice:(void(^)(void))finish {
    [self.serverCommunicator getNoticeAsync:^(NoticeItem *notice) {
        self.notice = notice;
        finish();
    } failure:^(NSError *error) {
        self.notice = nil;
        finish();
    }];
}

@end


