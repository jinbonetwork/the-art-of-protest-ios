//
//  FileManager.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 12..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

/**
 이 앱에서 사용할 파일 시스템을 초기화한다.
 */
- (void)initFileSystem {
    NSString* rootPath = [self getAppSupportRoot];
    [[NSFileManager defaultManager]
        createDirectoryAtPath:rootPath withIntermediateDirectories:YES attributes: nil error:nil];
}

/**
 Menu Json 파일을 저장한다.
 */
- (BOOL)saveMenuJson:(NSDictionary*)json {
    NSString* path = [self getMenuJsonPath];
    NSError* error=nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:json
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        return NO;
    }
    
    error = nil;
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    [jsonString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    return (error == nil);
}

/**
 Menu Json 경로를 얻어온다.
 */
- (NSString*)getMenuJsonPath {
    return [NSString pathWithComponents:@[[self getAppSupportRoot],FILE_NAME_MENU_JSON]];
}


/**
 메인 번들에 포함되어있는 필요한 파일들 ~/Library/Application Support/ 폴더로 복사하는 작업을 진행한다.
 */
- (void)copyBundleFilesToAppSupportDir {
    NSString* bundleCSS = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
    [[NSFileManager defaultManager] copyItemAtPath:bundleCSS toPath:[self getContentCssFilePath] error:nil];
    
    // home_resource 폴더 생성
    [[NSFileManager defaultManager]
     createDirectoryAtPath:[self getHomeResourcesDirPath]
     withIntermediateDirectories:YES attributes: nil error:nil];
    
    // home.html 복사
    NSString* homeHtmlPath = [[NSBundle mainBundle] pathForResource:@"home" ofType:@"html"];
    [[NSFileManager defaultManager] copyItemAtPath:homeHtmlPath toPath:[self getHomeHtmlFilePath] error:nil];
    
    // home-style.css 복사
    NSString* homeCssPath = [[NSBundle mainBundle] pathForResource:@"home-style" ofType:@"css"];
    [[NSFileManager defaultManager] copyItemAtPath:homeCssPath toPath:[self getHomeStyleCssFilePath] error:nil];
    
    // home.html에서 사용되는 이미지들 복사
    int imgCount = 4;
    for(int i=1; i <= imgCount; i++) {
        NSString *idx = [NSString stringWithFormat:@"%d",i];
        NSString *imgPath = [[NSBundle mainBundle] pathForResource:idx ofType:@"png"];
        [[NSFileManager defaultManager] copyItemAtPath:imgPath toPath:[self getHomeImagePathOfidx:idx] error:nil];
    }
}

/**
 postId의 폴더 경로를 가지고 온다.
 */
- (NSString*)getDirOfPostId:(NSInteger)postId {
    NSString *idStr = [NSString stringWithFormat:@"%ld", (long)postId];
    return [NSString pathWithComponents:@[[self getAppSupportRoot], idStr]];
}

/**
 해당 ID를 가지고 있는 Post의 폴더를 생성한다.
 */
- (void)makePostDir:(NSInteger)postId {
       [[NSFileManager defaultManager]
     createDirectoryAtPath:[self getDirOfPostId:postId]
        withIntermediateDirectories:YES attributes: nil error:nil];
}

/**
 ~/Library/Application Support/style.css 파일. 문서 콘텐츠에 사용되는 css 파일
 */
- (NSString*)getContentCssFilePath {
    return [NSString pathWithComponents:@[[self getAppSupportRoot], FILE_NAME_STYLE_CSS]];
}

/**
  ~/Library/Application Support/home_resource 디렉토리 경로. 홈 화면 웹뷰에 사용되는 파일들
 */
- (NSString*)getHomeResourcesDirPath {
    return [NSString pathWithComponents:@[[self getAppSupportRoot], DIR_NAME_HOME_RESOURCES]];
}

/**
 ~/Library/Application Support/home_resource 디렉토리의 html 파일 경로
 */
- (NSString*)getHomeHtmlFilePath {
    return [NSString pathWithComponents:@[[self getHomeResourcesDirPath], FILE_NAME_HOME_HTML]];
}

/**
 ~/Library/Application Support/home_resource 디렉토리의 css 파일 경로
 */
- (NSString*)getHomeStyleCssFilePath {
    return [NSString pathWithComponents:@[[self getHomeResourcesDirPath], FILE_NAME_HOME_STYLE_CSS]];
}

/**
 ~/Library/Application Support/home_resource 디렉토리의 이미지 파일 경로
 */
- (NSString*)getHomeImagePathOfidx:(NSString*)idxStr {
    return [[NSString pathWithComponents:@[[self getHomeResourcesDirPath], idxStr]] stringByAppendingPathExtension:@"png"];
}

/**
 앱 자료를 저장하는 기본 루트인 ~/Library/Application Supprt/ 경로를 얻어온다.
 */
- (NSString*)getAppSupportRoot {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSApplicationSupportDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    return [paths firstObject];
}

@end
