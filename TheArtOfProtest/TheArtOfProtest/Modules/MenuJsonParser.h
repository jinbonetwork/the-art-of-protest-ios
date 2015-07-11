//
//  MenuJsonParser.h
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 12..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MENU_JSON_MENU_ITEMS    @"menu_items"
#define MENU_JSON_DOCUMENT_ID   @"document_id"
#define MENU_JSON_TITLE         @"title"
#define MENU_JSON_FOLDED        @"folded"
#define MENU_JSON_CONTENT       @"content"
#define MENU_JSON_SUBMENUS      @"submenus"


/**
 /menu API를 파싱하는 모듈
 */
@interface MenuJsonParser : NSObject

- (NSArray *)parse:(NSDictionary*)json;
@end
