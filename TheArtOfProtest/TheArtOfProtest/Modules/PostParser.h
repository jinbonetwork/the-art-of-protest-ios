//
//  PostParsrer.h
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 24..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostItem.h"

#define TAG_POST_POSTS      @"posts"
#define TAG_POST_ID         @"ID"
#define TAG_POST_TITLE      @"title"
#define TAG_POST_MENU_ORDER @"menu_order"
#define TAG_POST_MODIFIED   @"modified"
#define TAG_POST_EXCERPT    @"excerpt"
#define TAG_POST_CONTENT    @"content"
#define TAG_POST_CATEGORIES @"categories"
#define TAG_POST_PARENT     @"parent"
#define TAG_POST_NAME       @"name"

/**
 * 워드프레스에서 page 형태의 POST로 주어지는 문서 목록 및 문서를 파싱하는 모듈
 */
@interface PostParser : NSObject

/**
 * 문서 목록을 파싱한다.
 */
- (NSArray *)parsePostList:(NSDictionary*)json;
/**
 * 문서 하나를 파싱한다.
 */
- (PostItem *)parsePost:(NSDictionary*)json;
@end
