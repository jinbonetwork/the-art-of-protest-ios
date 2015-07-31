//
//  CoreDataManager.h
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 12..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DocumentItem.h"
#import "PostItem.h"
#import "CategoryMenuItem.h"
#import "AppDelegate.h"

/**
 문서들을 저장해 놓는 DB인 Core Data와의 통신을 담당하는 모듈
 */
@interface CoreDataManager : NSObject

/**
 문서(Post) 하나를 DB에 삽입한다.
 */
- (void)insertPost:(PostItem*)post;

/**
 전체 문서(Post)를 받아온다.
 */
- (NSArray*)getAllPosts;

/**
 특정 Id를 가진 Post를 가져온다.
 */
- (PostItem*)getPostWithId:(NSInteger)docId;

/**
 특정 Keyword를 가진 Post를 검색한다.
 */
- (NSArray*)searchPostsWithKeyword:(NSString*)keyword;

/**
 카테고리 메뉴 하나를 DB에 삽입한다.
 */
- (void)insertCategoryMenu:(CategoryMenuItem*)categoryMenu;

/**
 전체 카테고리 메뉴를 가져온다.
 */
- (NSArray*)getAllCategoryMenu;

/**
 특정 ID를 가진 Cateory 메뉴를 가져온다.
 */
- (CategoryMenuItem*)getCategoryMenuItemWithId:(NSInteger)categoryId;

@end
