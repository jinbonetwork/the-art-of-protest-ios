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
