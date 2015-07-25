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

/**
 앱의 기본 내용들이 초기화 되었는지 확인한다. ex)필요한 리소스 파일들 Application Support 폴더로 옮기기 등
 */
- (BOOL)isAppInitialized;

/**
 콘텐츠가 최초 한번이라도 초기화 되었는지 확인한다.
 */
- (BOOL)isContentInitialized;

/**
 앱의 기본 내용들 초기화 한다.
 */
- (void)initApp;

/**
 최초로 콘텐츠를 초기화 한다.
 */
- (void)initContents;

/**
 콘텐츠 업데이트가 필요한지 확인한다.
 */
- (BOOL)checkUpdate;

/**
 콘텐츠를 업데이트 한다.
 */
- (void)updateContents;



@end
