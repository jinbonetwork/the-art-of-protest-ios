//
//  AOPContentsManager.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 24..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "AOPContentsManager.h"

@implementation AOPContentsManager

/**
 AOPContents Manager의 싱글톤 객체를 반환한다.
 */
+ (id)sharedManager {
    static AOPContentsManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

@end
