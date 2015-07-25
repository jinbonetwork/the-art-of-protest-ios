//
//  FileManager.h
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 12..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FILE_NAME_MENU_JSON @"menu.json"

/**
 로컬에 저장되는 파일을 관리하는 모듈
 */
@interface FileManager : NSObject

/**
 이 앱에서 사용할 파일 시스템을 초기화한다.
 */
- (void)initFileSystem;

/**
 Menu Json 파일을 저장한다. 성공여부 반환.
 */
- (BOOL)saveMenuJson:(NSDictionary*)json;

/**
 Menu Json 경로를 얻어온다.
 */
- (NSString*)getMenuJsonPath;

/**
 앱 자료를 저장하는 기본 루트인 ~/Library/Application Supprt/ 경로를 얻어온다.
 */
- (NSString*)getAppSupportRoot;
@end
