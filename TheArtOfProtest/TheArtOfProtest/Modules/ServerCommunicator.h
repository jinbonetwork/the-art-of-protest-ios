//
//  ServerCommunicator.h
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 12..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuJsonParser.h"
#import "AFNetworking.h"

/**
 Server와의 Communication을 담당하는 모듈
 */
@interface ServerCommunicator : NSObject

/**
 Server Commucator의 싱글톤 객체를 반환한다.
 */
+ (id)sharedCommunicator;

/**
 전체 document 목록을 비동기로 받아온다.
 */
- (void)getDocumentListAsync:(void (^)(NSArray *docList))success
                         failure:(void (^)(NSError *error))failure;

@end
