//
//  PostCacheWorker.h
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 26..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PostItem.h"

/**
 문서(Post) 캐싱을 담당하는 모듈
 */
@interface PostCacheWorker : NSObject

/**
 해당 post를 캐싱한다. 캐싱 할 때에는 이미지를 다운 받고 저장하고 하는 과정을 포함한다. 
 또한 이미지가 웹 주소가 아닌 로컬 주소로 바뀌어야 하기 때문에 바뀐 content를 return 한다.
 */
- (PostItem*)cachePost:(PostItem*)post;

@end
