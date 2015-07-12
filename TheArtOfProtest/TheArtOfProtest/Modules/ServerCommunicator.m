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

+ (id)sharedCommunicator {
    static ServerCommunicator *communicator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        communicator = [[self alloc] init];
    });
    return communicator;
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
