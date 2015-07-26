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
- (void)insertPost:(PostItem*)post {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *postObj = [NSEntityDescription insertNewObjectForEntityForName:@"Posts" inManagedObjectContext:context];

    [postObj setValue:[NSNumber numberWithInteger:post.postId] forKey:@"categoryId"];
    [postObj setValue:post.categoryName forKey:@"categoryName"];
    [postObj setValue:post.content forKey:@"content"];
    [postObj setValue:post.excerpt forKey:@"excerpt"];
    [postObj setValue:[NSNumber numberWithBool:post.isBookMarked] forKey:@"isBookMarked"];
    [postObj setValue:[NSNumber numberWithInteger:post.menuOrder] forKey:@"menuOrder"];
    [postObj setValue:post.modified forKey:@"modified"];
    [postObj setValue:[NSNumber numberWithInteger:post.postId] forKey:@"postId"];
    [postObj setValue:post.title forKey:@"title"];
    
    NSError *error = nil;
    [context save:&error];
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
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *categoryObj = [NSEntityDescription insertNewObjectForEntityForName:@"CategoryMenus" inManagedObjectContext:context];
    
    [categoryObj setValue:[NSNumber numberWithInteger:categoryMenu.categoryID] forKey:@"categoryId"];
    [categoryObj setValue:[NSNumber numberWithInteger:categoryMenu.categoryOrder] forKey:@"categoryOrder"];
    [categoryObj setValue:categoryMenu.name forKey:@"name"];
    
    NSError *error = nil;
    [context save:&error];
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

#pragma mark - private methods
- (NSManagedObjectContext*) managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


@end