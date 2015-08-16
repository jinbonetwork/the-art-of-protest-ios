//
//  AOPUtils.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 8. 16..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "AOPUtils.h"

@implementation AOPUtils

/**
 Toast 메시지에 사용할 View를 얻는다.
 */
+ (UIView*)getToastView:(NSString*)str {
    UIFont *font = [UIFont systemFontOfSize:17.0f];
    NSAttributedString *attributeText = [[NSAttributedString alloc] initWithString:str
                                                                        attributes:@{NSFontAttributeName: font}];
    CGRect rect = [attributeText boundingRectWithSize:(CGSize){CGFLOAT_MAX,CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width+40, 40)];
    [label.layer setCornerRadius:6.0f];
    label.clipsToBounds = true;
    [label setNumberOfLines:1];
    [label setFont:[UIFont systemFontOfSize:17.0f]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:str];
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[AOPUtils getThemeColor]];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width+40, 110)];
    [view addSubview:label];

    return view;
}

/**
 해당 앱의 테마 칼라를 얻는다.
 */
+ (UIColor*)getThemeColor {
    return [UIColor colorWithRed:1.0f green:114/255.0f blue:0.0f alpha:1.0f];
}
@end
