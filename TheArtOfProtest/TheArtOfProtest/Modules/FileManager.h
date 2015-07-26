//
//  FileManager.h
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 12..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FILE_NAME_MENU_JSON @"menu.json"
#define FILE_NAME_STYLE_CSS @"style.css"

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
 메인 번들에 포함되어있는 필요한 파일들 ~/Library/Application Support/ 폴더로 복사하는 작업을 진행한다.
 */
- (void)copyBundleFilesToAppSupportDir;

/**
 postId의 폴더 경로를 가지고 온다.
 */
- (NSString*)getDirOfPostId:(NSInteger)postId;

/**
 해당 ID를 가지고 있는 Post의 폴더를 생성한다.
 */
- (void)makePostDir:(NSInteger)postId;

/**
 ~/Library/Application Support/style.css 파일. 문서 콘텐츠에 사용되는 css 파일
 */
- (NSString*)getContentCssFilePath;

/**
 앱 자료를 저장하는 기본 루트인 ~/Library/Application Supprt/ 경로를 얻어온다.
 */
- (NSString*)getAppSupportRoot;
@end
