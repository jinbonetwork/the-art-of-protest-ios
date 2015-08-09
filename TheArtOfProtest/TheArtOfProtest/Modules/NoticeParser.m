//
//  NoticeParser.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 8. 9..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "NoticeParser.h"

@implementation NoticeParser
- (NoticeItem*)parse:(NSDictionary*)json {
    NSInteger found = [[json objectForKey:NOTICE_JSON_FOUND] integerValue];
    if (found == 0) { // Notice가 없을 경우
        return nil;
    }
    
    NSString *latestDate = nil;
    NoticeItem *latestNotice = nil;
    NSArray* noticeList = [json valueForKey:NOTICE_JSON_POSTS];
    
    for(NSDictionary *notice in noticeList)
    {
        NoticeItem *item = [self parseNotice:notice];
        if (latestDate == nil || [item.date compare:latestDate] == NSOrderedDescending) {
            latestDate = item.date;
            latestNotice = item;
        }
    }
    
    return latestNotice;
}

- (NoticeItem*)parseNotice:(NSDictionary*)json {
    NoticeItem *item = [[NoticeItem alloc] init];
    
    item.title = [json valueForKey:NOTICE_JSON_TITLE];
    item.date = [json valueForKey:NOTICE_JSON_DATE];
    item.content = [json valueForKey:NOTICE_JSON_CONTENT];
    
    return item;
}
@end
