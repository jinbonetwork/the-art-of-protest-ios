//
//  ServerCommunicator.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 12..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "ServerCommunicator.h"
#import "FileManager.h"

@implementation ServerCommunicator

/**
 Server Commucator의 싱글톤 객체를 반환한다.
 */
+ (id)sharedCommunicator {
    static ServerCommunicator *communicator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        communicator = [[self alloc] init];
    });
    return communicator;
}

/**
 Category 형태의 상위 메뉴 목록을 받아온다.
 */
- (void)getCategoryMenusAsync:(void (^)(NSArray *categoryMenuList))success
                      failure:(void (^)(NSError *error))failure {
    AFHTTPRequestOperation *operation =
        [self createBaseOperation:[NSString pathWithComponents:@[BASE_CMS_URI,REST_API_CATEGORIES]]];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject) {
         CategoryMenuParser *parser = [[CategoryMenuParser alloc] init];
         NSArray *result = [parser parse:(NSDictionary*)responseObject];
         success(result);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         failure(error);
     }];

    [operation start];
}


/**
 전체 문서 목록을 받아온다.
 */
- (void)getPostsAsync:(void (^)(NSArray *postList))success
              failure:(void (^)(NSError *error))failure {
    AFHTTPRequestOperation *operation =
    [self createBaseOperation:[NSString pathWithComponents:@[BASE_CMS_URI,REST_API_WHOLE_DOCS]]];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject) {
         PostParser *parser = [[PostParser alloc] init];
         NSArray *result = [parser parsePostList:(NSDictionary*)responseObject];
         success(result);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         failure(error);
     }];
    
    [operation start];
}

/**
 Version (최종 수정 일시 문자열)을 받아온다.
 */
- (void)getVersionAsync:(void (^)(NSString *modified))success
                failure:(void (^)(NSError *error))failure {
    AFHTTPRequestOperation *operation =
    [self createBaseOperation:[NSString pathWithComponents:@[BASE_CMS_URI,REST_API_VERSION]]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        VersionParser *parser = [[VersionParser alloc] init];
        NSString *result = [parser parse:(NSDictionary*)responseObject];
        success(result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
    [operation start];
}

/**
 공지를 받아온다. 공지가 없을 경우 success에서 주는 notice 값은 nil이다.
 */
- (void)getNoticeAsync:(void (^)(NoticeItem *notice))success
               failure:(void (^)(NSError *error))failure {
    AFHTTPRequestOperation *operation =
    [self createBaseOperation:[NSString pathWithComponents:@[BASE_CMS_URI,REST_API_NOTICE]]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NoticeParser *parser = [[NoticeParser alloc] init];
        NoticeItem *result = [parser parse:(NSDictionary*)responseObject];
        success(result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
    [operation start];
}

/**
 홈 페이지 버전을 얻어온다.
 */
- (void)getHomePageVersionAsync:(void (^)(NSString *version))finish {
    AFHTTPRequestOperation *operation =
    [self createBaseOperation:HOME_PAGE_VERSION_URL];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = (NSDictionary*)responseObject;
        long versionNum = [[dic objectForKey:@"version"] longValue];
        NSString *version = [NSString stringWithFormat:@"%ld",versionNum];
        finish(version);        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        finish(nil);
    }];
    
    [operation start];
}

/**
 AFHTTPRequestOperation GET을 위한 기본 객체 생성
 */
- (AFHTTPRequestOperation*)createBaseOperation:(NSString*)url {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setTimeoutInterval:7];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    return operation;
}

@end
