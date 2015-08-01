//
//  CoreDataManager.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 12..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "CoreDataManager.h"

#define CATEGORY_MENU_ENTITY_NAME @"CategoryMenus"
#define POST_MENU_ENTITY_NAME     @"Posts"

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
 문서(Post) 하나를 DB에 삽입한다. 있더 문서의 경우에는 업데이트한다.
 */
- (void)insertPost:(PostItem*)post {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *postObj;

    // 일단 해당 postId를 가진 오브젝트가 있으면 가져온다.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:POST_MENU_ENTITY_NAME];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"postId == %d",post.postId];
    [fetchRequest setPredicate:predicate];
    NSArray *ary = [context executeFetchRequest:fetchRequest error:nil];

    if (ary == nil || ary.count == 0) { // DB에 없던 데이터인 경우 새로 삽입
        postObj = [NSEntityDescription insertNewObjectForEntityForName:POST_MENU_ENTITY_NAME
                                                inManagedObjectContext:context];
    }
    else { // DB에 있는 데이터인 경우에는 update
        postObj = [ary objectAtIndex:0];
    }
    
    [postObj setValue:[NSNumber numberWithInteger:post.categoryId] forKey:@"categoryId"];
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
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]
                                    initWithEntityName:POST_MENU_ENTITY_NAME];
    NSArray *ary = [context executeFetchRequest:fetchRequest error:nil];
    NSMutableArray *posts = [NSMutableArray array];
    for (NSManagedObject* obj in ary) {
        [posts addObject:[self convertObjectToPost:obj]];
    }
    return posts;
}

/**
 특정 Id를 가진 Post를 가져온다.
 */
- (PostItem*)getPostWithId:(NSInteger)docId {
    return [[PostItem alloc] init];
}

/**
 특정 Keyword를 가진 Post를 검색한다.
 */
- (NSArray*)searchPostsWithKeyword:(NSString*)keyword {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]
                                    initWithEntityName:POST_MENU_ENTITY_NAME];
    NSPredicate *predicate = [NSPredicate
                                 predicateWithFormat:@"(title CONTAINS[cd] %@) OR (content CONTAINS[cd] %@)",keyword, keyword];
    [fetchRequest setPredicate:predicate];
    
    NSArray *ary = [context executeFetchRequest:fetchRequest error:nil];
    NSMutableArray *posts = [NSMutableArray array];
    for (NSManagedObject* obj in ary) {
        [posts addObject:[self convertObjectToPost:obj]];
    }
    return posts;
}

/**
 카테고리 메뉴 하나를 DB에 삽입한다.
 */
- (void)insertCategoryMenu:(CategoryMenuItem*)categoryMenu {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *categoryObj = [NSEntityDescription insertNewObjectForEntityForName:CATEGORY_MENU_ENTITY_NAME
                                                                 inManagedObjectContext:context];
    
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
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CATEGORY_MENU_ENTITY_NAME];
    
    NSArray *ary = [context executeFetchRequest:fetchRequest error:nil];
    NSMutableArray *categories = [NSMutableArray array];
    for (NSManagedObject* obj in ary) {
        [categories addObject:[self convertObjectToCategoryMenu:obj]];
    }
    return categories;
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

/**
 managed object를 포스트 아이템으로 전환한다.
 */
- (PostItem *)convertObjectToPost:(NSManagedObject*)object {
    PostItem *item = [[PostItem alloc] init];

    item.categoryId = [[object valueForKey:@"categoryId"] integerValue];
    item.categoryName = [object valueForKey:@"categoryName"];
    item.content = [object valueForKey:@"content"];
    item.excerpt = [object valueForKey:@"excerpt"];
    item.isBookMarked = [[object valueForKey:@"isBookMarked"] boolValue];
    item.menuOrder = [[object valueForKey:@"menuOrder"] integerValue];
    item.modified = [object valueForKey:@"modified"];
    item.postId = [[object valueForKey:@"postId"] integerValue];
    item.title = [object valueForKey:@"title"];
    
    return item;
}

/**
 managed object를 카테고리 메뉴 아이템으로 전환한다.
 */
- (CategoryMenuItem*)convertObjectToCategoryMenu:(NSManagedObject*)object {
    CategoryMenuItem *item = [[CategoryMenuItem alloc] init];

    item.categoryID = [[object valueForKey:@"categoryId"] integerValue];
    item.name = [object valueForKey:@"name"];
    item.categoryOrder = [[object valueForKey:@"categoryOrder"] integerValue];
    
    return item;
}


@end