//
//  ServerCommunicator.h
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 12..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuJsonParser.h"
#import "CategoryMenuParser.h"
#import "AFNetworking.h"

#define BASE_CMS_URI @"https://public-api.wordpress.com/rest/v1.1/sites/theartofprotest.jinbo.net"
#define REST_API_CATEGORIES @"categories"
#define REST_API_DOCUMENTS @"documents"

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
- (void)getCategoryMenusAsync:(void (^)(NSArray *docList))success
                      failure:(void (^)(NSError *error))failure;


@end
