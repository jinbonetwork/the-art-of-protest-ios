//
//  AOPUtils.h
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 8. 16..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AOPUtils : NSObject
/**
 Toast 메시지에 사용할 View를 얻는다.
 */
+ (UIView*)getToastView:(NSString*)str;

/**
 해당 앱의 테마 칼라를 얻는다. 
 */
+ (UIColor*)getThemeColor;
@end
