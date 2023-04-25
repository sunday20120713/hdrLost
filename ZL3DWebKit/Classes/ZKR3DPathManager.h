//
//  ZKR3DPathManager.h
//  ZL3DWebKit
//
//  Created by luokan on 2022/9/10.
//

#import <Foundation/Foundation.h>
#import <JKSandBoxManager/JKSandBoxManager.h>
NS_ASSUME_NONNULL_BEGIN

static NSString *zip001Name = @"ZKRThridWebData";

static NSString *zip009Name = @"ZKRThridWebData";

@interface ZKR3DPathManager : NSObject

#pragma mark - 001
/// indexHtml文件，可用来判断是否解压成功过
+ (NSString *)index001HtmlFile;

+ (NSString *)jsBundle001Path;

+ (NSString *)web3DData001Path;

+ (NSString*)cacheFile001Path;

#pragma mark - 009
+ (NSString *)jsBundle009Path;

/// indexHtml文件，可用来判断是否解压成功过
+ (NSString *)index009HtmlFile;

+ (NSString *)web3DData009Path;


+ (NSString*)cacheFile009Path;

#pragma mark 公用




@end

NS_ASSUME_NONNULL_END
