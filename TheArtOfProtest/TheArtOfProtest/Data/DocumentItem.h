//
//  DocumentItem.h
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 12..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 문서 하나를 나타내는 Docuemt 데이터 객체
 */
@interface DocumentItem : NSObject
@property (nonatomic, copy) NSString *documentId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@end
