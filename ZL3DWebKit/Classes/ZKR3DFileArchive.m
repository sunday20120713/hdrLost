//
//  ZKR3DFileArchive.m
//  ZL3DWebKit
//
//  Created by atme on 2022/7/28.
//

#import "ZKR3DFileArchive.h"
#import <SSZipArchive/SSZipArchive.h>
#import "ZKR3DPathManager.h"

@implementation ZKR3DFileArchive

/// 是否有素材显示3D模型
+ (BOOL) have001MaterialDisplay3D{
    NSString *path = [ZKR3DPathManager index001HtmlFile];
    if(path && path.length > 0){
        return YES;
    }
    return NO;
}

/// 是否有素材显示3D模型 （009）
+ (BOOL) have009MaterialDisplay3D{
    NSString *path = [ZKR3DPathManager index009HtmlFile];
    if(path && path.length > 0){
        return YES;
    }
    return NO;
}

#pragma mark - 解压缩
+ (NSString *)unzip001Soure {
    @try { // disk full maybe  crash
        NSString *webPath = [ZKR3DPathManager web3DData001Path];
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:webPath];
        if (isExist) {
            [[NSFileManager defaultManager]removeItemAtPath:webPath error:nil];
        }
        NSString *path = [ZKR3DPathManager cacheFile001Path];
        NSString *bundlePath = [[ZKR3DPathManager jsBundle001Path] stringByAppendingPathComponent:[zip001Name stringByAppendingString:@".zip"]];
        BOOL succ = [SSZipArchive unzipFileAtPath:bundlePath toDestination:path];
        NSLog(@"[001资源解压] ====== %@",succ?@"YES":@"NO");
    } @catch (NSException *exception) {
        
    } @finally {
        return [ZKR3DPathManager index001HtmlFile];
    }
}

+ (NSString *)unzip009Soure{
    @try { // disk full maybe  crash
        NSString *webPath = [ZKR3DPathManager web3DData009Path];
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:webPath];
        if (isExist) {
            [[NSFileManager defaultManager]removeItemAtPath:webPath error:nil];
        }
        NSString *path = [ZKR3DPathManager cacheFile009Path];
        NSString *bundlePath = [[ZKR3DPathManager jsBundle009Path] stringByAppendingPathComponent:[zip009Name stringByAppendingString:@".zip"]];
        BOOL succ = [SSZipArchive unzipFileAtPath:bundlePath toDestination:path];
        NSLog(@"[009资源解压] ====== %@",succ?@"成功":@"失败");
    } @catch (NSException *exception) {
        
    } @finally {
        return [ZKR3DPathManager index009HtmlFile];
    }
}

@end
