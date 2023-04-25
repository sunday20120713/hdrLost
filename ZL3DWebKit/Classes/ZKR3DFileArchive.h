//
//  ZKR3DFileArchive.h
//  ZL3DWebKit
//
//  Created by atme on 2022/7/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZKR3DFileArchive : NSObject

/// 解压缩，返回成功后的文件路径
+ (NSString *)unzip001Soure;

+ (NSString *)unzip009Soure;

/// 是否有素材显示3D模型 （001）
+ (BOOL) have001MaterialDisplay3D;

/// 是否有素材显示3D模型 （009）
+ (BOOL) have009MaterialDisplay3D;

@end

NS_ASSUME_NONNULL_END
