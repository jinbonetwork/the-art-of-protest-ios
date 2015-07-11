//
//  DocItem.h
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 11..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 문서 하나를 나타내는 Docuemt 데이터 객체
 */
@interface DocItem : NSObject
@property (nonatomic, copy) NSString *documentId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL folded;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSMutableArray *submenus;
@end
