//
//  MenuJsonParser.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 12..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "MenuJsonParser.h"
#import "MenuItem.h"

@implementation MenuJsonParser

- (NSArray*)parse:(NSDictionary *)json {
    NSArray *itemListData = [json valueForKey:MENU_JSON_MENU_ITEMS];
    if (itemListData == nil)
        return nil;
    
    NSMutableArray *list = [NSMutableArray array];
    for (NSDictionary* data in itemListData) {
        [list addObject:[self parseItem:data]];
    }
    
    return list;
}

/**
 하나의 document Item을 parsing한다.
 */
- (MenuItem*)parseItem:(NSDictionary*)data {
    MenuItem *item = [[MenuItem alloc] init];
    item.documentId = [data valueForKey:MENU_JSON_DOCUMENT_ID];
    item.title = [data valueForKey:MENU_JSON_TITLE];
    item.folded = [[data valueForKey:MENU_JSON_FOLDED] boolValue];
    item.content = [data valueForKey:MENU_JSON_CONTENT];
    
    NSArray *subMenusData = [data valueForKey:MENU_JSON_SUBMENUS];
    if (subMenusData != nil && [subMenusData count] > 0) {
        NSMutableArray *subMenus = [NSMutableArray array];
        for (NSDictionary* subData in subMenusData) {
            [subMenus addObject:[self parseItem:subData]];
        }
        item.submenus = [subMenus copy];
    }
    
    return item;
}

@end
