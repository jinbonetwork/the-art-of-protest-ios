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
 Server Commucator의 싱글톤 객체를 반환한다.'
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
- (void)getCategoryMenusAsync:(void (^)(NSArray *docList))success
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
- (void)getPostsAsync:(void (^)(NSArray *docList))success
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

- (void)getDocumentListAsync:(void (^)(NSArray *docList))success
                         failure:(void (^)(NSError *error))failure {
    
    AFHTTPRequestOperation *operation =
        [self createBaseOperation:@"http://108.61.183.202/jinbonet/aop/menu.json"];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject) {
         MenuJsonParser *parser = [[MenuJsonParser alloc] init];
         NSArray *result = [parser parse:(NSDictionary*)responseObject];
         success(result);
         
         FileManager *manager = [[FileManager alloc] init];
         [manager saveMenuJson:(NSDictionary*)responseObject];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         failure(error);
     }];
    
    [operation start];
}

/**
 AFHTTPRequestOperation GET을 위한 기본 객체 생성
 */
- (AFHTTPRequestOperation*)createBaseOperation:(NSString*)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    return operation;
}

@end
