//
//  VersionJsonParser.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 8. 1..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "VersionParser.h"

@implementation VersionParser

- (NSString *)parse:(NSDictionary*)json {
    NSArray *postsArray = [json valueForKey:VERSION_JSON_POSTS];
    NSDictionary *modifiedDic = [postsArray objectAtIndex:0];
    NSString *modified = [modifiedDic valueForKey:VERSION_JSON_MODIFIED];
    return modified;
}

@end
