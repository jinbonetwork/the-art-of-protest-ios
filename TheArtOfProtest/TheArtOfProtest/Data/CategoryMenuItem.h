//
//  CategoryMenuItem.h
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 23..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
  워드프레스에서 카테고리 형태로 되어있는 문서들의 상위 menu Item을 나타내는 데이터
 */
@interface CategoryMenuItem : NSObject
@property (nonatomic, assign) NSInteger categoryID;
@property (nonatomic, copy) NSString *name;
@end
