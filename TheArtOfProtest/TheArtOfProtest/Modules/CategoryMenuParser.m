//
//  MenuParser.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 23..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "CategoryMenuParser.h"

@implementation CategoryMenuParser

- (NSArray*)parse:(NSDictionary *)json {
    NSArray *categories = [json valueForKey:TAG_CATMENU_CATEGORIES];
    if (categories == nil)
        return nil;
    
    NSMutableArray *list = [NSMutableArray array];
    for (NSDictionary* category in categories) {
        CategoryMenuItem *item = [self parseCategoryItem:category];
        if (item!=nil) {
            [list addObject:item];
        }
    }
    
    return list;
}

/**
 하나의 Category menu Item을 parsing한다.
 */
- (CategoryMenuItem*)parseCategoryItem:(NSDictionary*)data {
    NSInteger parentId = [[data valueForKey:TAG_CATMENU_PARENT] integerValue];
    // parentId가 2인 경우에만 문서 목록에서 사용되는 상위 메뉴이다.
    if (parentId != 2) {
        return nil;
    }
    
    CategoryMenuItem *item = [[CategoryMenuItem alloc] init];
    item.name = [data valueForKey:TAG_CATMENU_NAME];
    item.categoryID = [[data valueForKey:TAG_CATMENU_ID] integerValue];
    
    return item;
}

@end
