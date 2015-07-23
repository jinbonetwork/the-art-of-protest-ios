//
//  AOPContentsManager.h
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 24..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 이 앱의 전반적인 콘텐츠를 관리하는 모듈 추가
 */
@interface AOPContentsManager : NSObject

@property (nonatomic, strong) NSArray *postList;
@property (nonatomic, strong) NSArray *categoryMenuList;

/**
 AOPContents Manager의 싱글톤 객체를 반환한다.
 */
+ (id)sharedManager;

@end
