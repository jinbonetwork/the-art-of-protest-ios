//
//  CoreDataManager.h
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 12..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DocumentItem.h"

/**
 문서들을 저장해 놓는 DB인 Core Data와의 통신을 담당하는 모듈
 */
@interface CoreDataManager : NSObject

/**
CoreData Manager의 싱글톤 객체를 반환한다.
 */
+ (id)sharedManager;

/**
 Document Item을 Insert한다. 이미 존재하는 documentId에 대해서는 업데이트 한다.
 */
- (void)insertDoc:(DocumentItem*)doc;

/**
 해당 document ID를 가진 document item을 반환한다. 없을 경우 nil을 반환
 */
- (DocumentItem*)getDocWithId:(NSString*)docId;

/**
 제목이나 내용에 keyword를 포함한 document 목록을 반환한다. 검색시 사용. 없을 경우 empty array 반환
 */
- (NSArray*)searchDocWithKeyword:(NSString*)keyword;

@end
