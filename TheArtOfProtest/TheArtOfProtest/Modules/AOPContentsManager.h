//
//  AOPContentsManager.h
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 24..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerCommunicator.h"
#import "CoreDataManager.h"
#import "FileManager.h"
#import "PostCacheWorker.h"


/**
 * 이 앱의 전반적인 콘텐츠를 관리하는 모듈 추가
 */
@interface AOPContentsManager : NSObject

@property (nonatomic, strong) NSArray *postList;
@property (nonatomic, strong) NSArray *categoryMenuList;
@property (nonatomic, strong) NoticeItem *notice;
@property (nonatomic, strong) NSString *lastModified;
@property (nonatomic, strong) NSString *homeVersion;

/**
 AOPContents Manager의 싱글톤 객체를 반환한다.
 */
+ (id)sharedManager;

/**
 앱의 기본 내용들이 초기화 되었는지 확인한다. ex)필요한 리소스 파일들 Application Support 폴더로 옮기기 등
 */
- (BOOL)isAppInitialized;

/**
 콘텐츠가 최초 한번이라도 초기화 되었는지 확인한다.
 */
- (BOOL)isContentInitialized;

/**
 앱의 기본 내용들 초기화 한다.
 */
- (void)initApp;

/**
 최초로 콘텐츠를 초기화 한다.
 */
- (void)initContents:(void(^)(void))success
            progress:(void(^)(NSInteger percent))progress
             failure:(void(^)(NSError *error))failure;

/**
 콘텐츠 업데이트가 필요한지 확인한다.
 */
- (void)checkUpdate:(void(^)(BOOL needUpdate, NSString* modifiedDate))done;

/**
 콘텐츠를 업데이트 한다.
 */
- (void)updateContents:(void(^)(void))success
               failure:(void(^)(NSError *error))failure;

/**
 홈 화면 webView에 들어갈 내용이 업데이트 할 필요가 있으면 업데이트한다.
 */
- (void)checkAndUpdateHomePage:(void(^)(void))finish;

/**
 저장된 콘텐츠들을 불러온다.
 */
- (void)loadCategoryAndPosts;

/**
 특정 keyword를 가진 post 목록을 가져온다
 */
- (NSArray*)searchPostsWithKeyword:(NSString*)keyword;

/**
 해당 postId에 BookMark를 설정한다.
 */
- (void)setBookMark:(NSInteger)postId isBookMakred:(BOOL)isBookMarked;

/**
 북마크된 콘텐츠 목록을 가져온다.
 */
- (NSArray*)getBookMarkedPost;

/**
 공지를 불러온다.
 */
- (void)loadNotice:(void(^)(void))finish;

/**
 CSS파일 업그레이드가 필요하면 업그레이드 한다 (번들에서 APP Support Dir로 Copy)
 */
- (void)updateCSSIfNeeded;

@end
