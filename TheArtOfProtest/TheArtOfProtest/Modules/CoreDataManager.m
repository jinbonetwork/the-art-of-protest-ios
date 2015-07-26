//
//  CoreDataManager.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 12..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager

/**
 CoreData Manager의 싱글톤 객체를 반환한다.
 */
+ (id)sharedManager {
    static CoreDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

/**
 문서(Post) 하나를 DB에 삽입한다.
 */
- (void)inserPost:(PostItem*)post {
}

/**
 전체 문서(Post)를 받아온다.
 */
- (NSArray*)getAllPosts {
    return [NSArray array];
}

/**
 특정 Id를 가진 Post를 가져온다.
 */
- (PostItem*)getPostWithId:(NSInteger)docId {
    return [[PostItem alloc] init];
}

/**
 카테고리 메뉴 하나를 DB에 삽입한다.
 */
- (void)insertCategoryMenu:(CategoryMenuItem*)categoryMenu {
    
}

/**
 전체 카테고리 메뉴를 가져온다.
 */
- (NSArray*)getAllCategoryMenu {
    return [NSArray array];
}

/**
 특정 ID를 가진 Cateory 메뉴를 가져온다.
 */
- (CategoryMenuItem*)getCategoryMenuItemWithId:(NSInteger)categoryId {
    return [[CategoryMenuItem alloc] init];
}


@end
