//
//  MenuParser.h
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 23..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryMenuItem.h"

#define TAG_CATMENU_CATEGORIES @"categories"
#define TAG_CATMENU_ID         @"ID"
#define TAG_CATMENU_NAME       @"name"
#define TAG_CATMENU_PARENT     @"parent"

/**
 워드프레스에서 카테고리 형태로 되어있는 문서들의 상위 menu API를 파싱하는 모듈
 */
@interface CategoryMenuParser : NSObject
- (NSArray *)parse:(NSDictionary*)json;
@end
