//
//  PostParsrer.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 24..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "PostParser.h"

@implementation PostParser

/**
 * 문서 목록을 파싱한다.
 */
- (NSArray *)parsePostList:(NSDictionary*)json {
    NSArray *posts = [json valueForKey:TAG_POST_POSTS];
    if (posts == nil)
        return nil;
    
    NSMutableArray *list = [NSMutableArray array];
    for (NSDictionary* post in posts) {
        PostItem *item = [self parsePost:post];
        if (item != nil) {
            [list addObject:item];
        }
    }
    
    return list;
}

/**
 * 문서 하나를 파싱한다. 집회시위 문서가 아니면 nil을 return 한다.
 */
- (PostItem *)parsePost:(NSDictionary*)json {
    PostItem *item = [[PostItem alloc] init];

    item.postId = [[json valueForKey:TAG_POST_ID] integerValue];
    item.menuOrder = [[json valueForKey:TAG_POST_MENU_ORDER] integerValue];
    
    item.title = [json valueForKey:TAG_POST_TITLE];
    item.modified = [json valueForKey:TAG_POST_MODIFIED];
    item.excerpt = [json valueForKey:TAG_POST_EXCERPT];
    item.content = [json valueForKey:TAG_POST_CONTENT];
    
    NSDictionary *categories = [json valueForKey:TAG_POST_CATEGORIES];
    for (NSString* key in categories) {
        NSDictionary *category = [categories valueForKey:key];
        NSInteger parentId = [[category valueForKey:TAG_POST_PARENT] integerValue];
        if (parentId == 2) { // "메뉴얼"이 부모일 경우. 즉 문서목록의 상위메뉴일 경우.
            item.categoryId = [[category valueForKey:TAG_POST_ID] integerValue];
            item.categoryName = [category valueForKey:TAG_POST_NAME];
        }
    }
    
    // 위 로직에서 카테고리 찾기에 실패한 경우는 집회시위 문서가 아니다
    if (item.categoryName == nil) {
        return nil;
    }
    
    return item;
}

@end
