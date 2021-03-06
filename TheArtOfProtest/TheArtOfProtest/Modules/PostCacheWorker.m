//
//  PostCacheWorker.m
//  TheArtOfProtest
//
//  Created by HwangKyuman on 2015. 7. 26..
//  Copyright (c) 2015년 JinboNet. All rights reserved.
//

#import "PostCacheWorker.h"
#import "FileManager.h"

#define HOME_HTML_URL @"http://theartofprotest.jinbo.net/home.html"
#define HOME_CSS_URL @"http://theartofprotest.jinbo.net/home-style.css"

@interface PostCacheWorker()

@property (nonatomic, strong) FileManager *fileManager;

@end

@implementation PostCacheWorker

/**
 해당 post를 캐싱한다. 캐싱 할 때에는 이미지를 다운 받고 저장하고 하는 과정을 포함한다.
 또한 이미지가 웹 주소가 아닌 로컬 주소로 바뀌어야 하기 때문에 바뀐 content를 return 한다.
 */
- (NSString*)cachePost:(PostItem*)post {
    
    NSArray *urlList = [self getImgUrlList:post.content];

    // 캐싱해야 할 것이 없으면 걍 리턴한다.
    if (urlList == nil)
        return post.content;
    
    [self createPostDir:post.postId];
    
    [self saveImages:urlList withPostId:post.postId];
    
    post.content = [self changeContentStr:post.content ofUrl:urlList withPostId:post.postId];
    
    return post.content;
}

/**
 홈 화면 WebView에 들어갈 자료들을 Caching한다.
 */
- (void)cacheHomePage {
    self.fileManager = [[FileManager alloc] init];
    
    NSURL *htmlURL = [NSURL URLWithString:HOME_HTML_URL];
    NSString *homeHtmlStr =
        [NSString stringWithContentsOfURL:htmlURL encoding:NSUTF8StringEncoding error:nil];
    
    // 홈화면 이미지 캐싱하고 이미지 주소를 로컬형태로 변환
    NSArray *urlList = [self getImgUrlList:homeHtmlStr];
    if (urlList != nil) {
        [self saveImagesForHome:urlList];
        homeHtmlStr = [self changeHomeStr:homeHtmlStr ofUrl:urlList];
    }
    
    // 홈화면 html 파일 저장
    [homeHtmlStr writeToFile:[self.fileManager getHomeHtmlFilePath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    // 홈화면 css 파일 저장
    NSURL *cssUrl = [NSURL URLWithString:HOME_CSS_URL];
    NSString *homeCssStr =
        [NSString stringWithContentsOfURL:cssUrl encoding:NSUTF8StringEncoding error:nil];
    [homeCssStr writeToFile:[self.fileManager getHomeStyleCssFilePath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

/**
 콘텐츠에 포함되어 있는 이미지 리스트를 가져 온다.
 */
- (NSArray*)getImgUrlList:(NSString*)originString {
    NSMutableArray *urlList = [NSMutableArray array];
    NSString *str = originString;
    NSString *url = nil;
    while (true) {
        NSRange ranges,rangesForUrl;
        ranges = [str rangeOfString:@"<img"];
        if (ranges.location == NSNotFound)
            break;
        url = [str substringFromIndex:ranges.location];
        ranges = [url rangeOfString:@"src=\""];
        url = [url substringFromIndex:ranges.location+5];
        
        // 앞에 <img src= 를 잘라낸 후 다음 url을 찾기 위해 str에 url을 대입한다.
        str=url;
        
        rangesForUrl = [url rangeOfString:@"\""];
        rangesForUrl.length = rangesForUrl.location;
        rangesForUrl.location = 0;
        
        url = [url substringWithRange:rangesForUrl];
        
        [urlList addObject:url];
    }
    return urlList;
}

/**
 post 디렉토리를 생성한다.
 */
- (void)createPostDir:(NSInteger)postId {
    self.fileManager = [[FileManager alloc] init];
    [self.fileManager makePostDir:postId];
}

/**
 이미지들을 저장해 놓는다.
 */
- (void)saveImages:(NSArray*)urlList withPostId:(NSInteger)postId {
    int count = 0;
    for (NSString* url in urlList) {
        NSString *directory = [self.fileManager getDirOfPostId:postId];
        NSString *extension = [url pathExtension];
        UIImage *image = [self getImageFromURL:url];
        NSString *imageName = [NSString stringWithFormat:@"%d",count];
        
        [self saveImage:image withFileName:imageName ofType:extension inDirectory:directory];
        
        ++count;
    }
}

/**
 Home html 파일에 필요한 이미지들을 저장한다.
 */
- (void)saveImagesForHome:(NSArray*)urlList {
    int count = 0;
    for (NSString* url in urlList) {
        NSString *directory = [self.fileManager getHomeResourcesDirPath];
        NSString *extension = [url pathExtension];
        UIImage *image = [self getImageFromURL:url];
        NSString *imageName = [NSString stringWithFormat:@"%d",count];
        
        [self saveImage:image withFileName:imageName ofType:extension inDirectory:directory];
        
        ++count;
    }
}

/**
 Content 문자열의 주소들을 로컬 주소로 변경한다.
 */
- (NSString*)changeContentStr:(NSString*)content
                   ofUrl:(NSArray*)urlList
              withPostId:(NSInteger)postId {
    int cnt = 0;
    for (NSString* url in urlList) {
        NSString *localPath = [NSString
                              stringWithFormat:@"%d/%d.%@",postId,cnt,[url pathExtension]];
        content = [content stringByReplacingOccurrencesOfString:url withString:localPath];
        ++cnt;
    }
    
    return content;
}

/**
 Home html파일들의 주소를 바꾼다.
 */
- (NSString*)changeHomeStr:(NSString*)content ofUrl:(NSArray*)urlList {
    int cnt = 0;
    for (NSString* url in urlList) {
        NSString *localPath = [NSString
                               stringWithFormat:@"%d.%@",cnt,[url pathExtension]];
        content = [content stringByReplacingOccurrencesOfString:url withString:localPath];
        ++cnt;
    }
    return content;
}

/**
 파일 URL로 부터 IMAGE를 얻는다.
 */
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}

/**
 이미지를 저장한다.
 */
-(void) saveImage:(UIImage *)image
     withFileName:(NSString *)imageName
           ofType:(NSString *)extension
      inDirectory:(NSString *)directoryPath {
    
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    }
}

@end


