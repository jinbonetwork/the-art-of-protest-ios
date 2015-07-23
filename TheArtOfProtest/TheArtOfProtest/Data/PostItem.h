//
//  PostItem.h
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 24..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 워드프레스에서 page형태 POST로 되어있는 문서 목록을 저장하는 데이터 아이템
 */
@interface PostItem : NSObject
@property (nonatomic, assign) NSInteger postId;
@property (nonatomic, copy) NSString *modified;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, assign) NSInteger categoryId;
@end
