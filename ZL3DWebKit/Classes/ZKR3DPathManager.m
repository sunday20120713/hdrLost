//
//  ZKR3DPathManager.m
//  ZL3DWebKit
//
//  Created by luokan on 2022/9/10.
//

#import "ZKR3DPathManager.h"

@implementation ZKR3DPathManager

#pragma mark - 001
+ (NSString *)jsBundle001Path {
    static NSString *jsBundlePath = nil;
    if(jsBundlePath == nil){
        NSBundle *curBundle = [JKSandBoxManager bundleWithBundleName:@"ZL3DWebKit"];
        jsBundlePath = [curBundle pathForResource:@"ZL3DWeb" ofType:@"bundle"];
    }
    return jsBundlePath;
}

+ (NSString *)index001HtmlFile {
    NSString *path = [[ZKR3DPathManager web3DData001Path] stringByAppendingPathComponent:@"index.html"];
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
        return path;
    }
    return nil;
}

+ (NSString *)web3DData001Path {
    NSString *path = [[ZKR3DPathManager cacheFile001Path] stringByAppendingPathComponent:zip001Name];
    return path;
}

#pragma mark - 009
+ (NSString *)jsBundle009Path {
    static NSString *jsBundlePath = nil;
    if(jsBundlePath == nil){
        NSBundle *curBundle = [JKSandBoxManager bundleWithBundleName:@"ZL3DWebKit"];
        jsBundlePath = [curBundle pathForResource:@"ZL3DWeb009" ofType:@"bundle"];
    }
    return jsBundlePath;
}

+ (NSString *)index009HtmlFile {
    NSString *path = [[ZKR3DPathManager web3DData009Path] stringByAppendingPathComponent:@"index.html"];
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
        return path;
    }
    return nil;
}

+ (NSString *)web3DData009Path {
    NSString *path = [[ZKR3DPathManager cacheFile009Path] stringByAppendingPathComponent:zip009Name];
    return path;
}

#pragma mark 公用
+ (NSString*)cacheFile001Path {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths.firstObject;
}

+ (NSString*)cacheFile009Path {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = paths.firstObject;
    basePath = [basePath stringByAppendingPathComponent:@"009"];
    return basePath;
}

@end
