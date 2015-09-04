//
//  ServerCommunicator.h
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 12..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryMenuParser.h"
#import "PostParser.h"
#import "VersionParser.h"
#import "NoticeParser.h"
#import "AFNetworking.h"

#define HOME_PAGE_VERSION_URL  @"http://theartofprotest.jinbo.net/home_version.php"
#define BASE_CMS_URI        @"https://public-api.wordpress.com/rest/v1.1/sites/theartofprotest.jinbo.net"
#define REST_API_CATEGORIES @"categories"
#define REST_API_WHOLE_DOCS @"posts/?category=manual&type=page&status=publish&number=100"
#define REST_API_VERSION    @"posts/?order_by=modified&status=publish&number=1&fields=modified&type=page"
#define REST_API_NOTICE     @"posts/?category=notice&status=publish"

/**
 Server와의 Communication을 담당하는 모듈
 */
@interface ServerCommunicator : NSObject

/**
 Server Commucator의 싱글톤 객체를 반환한다.'
 */
+ (id)sharedCommunicator;

/**
 전체 document 목록을 비동기로 받아온다.
 */
- (void)getDocumentListAsync:(void (^)(NSArray *docList))success
                     failure:(void (^)(NSError *error))failure;
/**
 Category 형태의 상위 메뉴 목록을 받아온다.
 */
- (void)getCategoryMenusAsync:(void (^)(NSArray *categoryMenuList))success
                      failure:(void (^)(NSError *error))failure;

/**
 전체 문서 목록을 받아온다.
 */
- (void)getPostsAsync:(void (^)(NSArray *postList))success
              failure:(void (^)(NSError *error))failure;

/**
 Version (최종 수정 일시 문자열)을 받아온다.
 */
- (void)getVersionAsync:(void (^)(NSString *modified))success
                failure:(void (^)(NSError *error))failure;

/**
 공지를 받아온다. 공지가 없을 경우 success에서 주는 notice 값은 nil이다.
 */
- (void)getNoticeAsync:(void (^)(NoticeItem *notice))success
               failure:(void (^)(NSError *error))failure;

/**
 홈 페이지 버전을 얻어온다.
 */
- (void)getHomePageVersionAsync:(void (^)(NSString *version))finish;
@end
