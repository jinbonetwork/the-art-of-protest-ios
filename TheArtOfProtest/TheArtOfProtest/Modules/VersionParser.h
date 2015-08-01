//
//  VersionJsonParser.h
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 8. 1..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VERSION_JSON_POSTS    @"posts"
#define VERSION_JSON_MODIFIED @"modified"

/**
 POST나 PAGE의 최신 변경 날짜를 주는 API를 파싱한다.
 */
@interface VersionParser : NSObject
- (NSString *)parse:(NSDictionary*)json;
@end
