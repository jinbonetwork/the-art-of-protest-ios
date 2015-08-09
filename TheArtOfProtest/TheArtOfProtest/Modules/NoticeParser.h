//
//  NoticeParser.h
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 8. 9..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeItem.h"

#define NOTICE_JSON_FOUND   @"found"
#define NOTICE_JSON_POSTS   @"posts"
#define NOTICE_JSON_TITLE   @"title"
#define NOTICE_JSON_CONTENT @"content"
#define NOTICE_JSON_DATE    @"date"

@interface NoticeParser : NSObject
- (NoticeItem*)parse:(NSDictionary*)json;
@end
