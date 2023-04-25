//
//  ZL3DWebView.h
//  3DWebView
//
//  Created by luokan on 2022/1/17.
//

#import <UIKit/UIKit.h>
#import "ZL3DWebViewTools.h"

// 回调: 方法名+进度 + 显示的车型
typedef void (^ZLMessageCallBackBlock)(NSString *,id,ZKR3DCarDisplay);

NS_ASSUME_NONNULL_BEGIN

@interface ZL3DWebView : UIView

@property (nonatomic,strong) ZKR3DCarDisplay dispayCar; /// 当前显示的车型

@property (nonatomic,copy) ZLMessageCallBackBlock messageCallBack;

-(void) switchCar:(ZKR3DCarDisplay)cartype withParams:(NSDictionary *)params;

-(void) startLoad001ResourceWithParams:(NSDictionary *)params;

-(void) startLoad009ResourceWithParams:(NSDictionary *)params;

-(void) changeColor:(ZKR3DCarColor)color isSame:(BOOL)isSame isTrim:(BOOL) isTrim;

/// 切换轮毂
/// @param wheelName 轮毂名
-(void) changeWheel:(ZKR3DCarWheelName)wheelName;

/// 切换tab刷新
-(void) onTabChange:(NSString *)flag;

/// 修改loading的背景色
-(void) changeLoadingBgColor:(NSString *)bgColor;

/// 重置视觉
-(void) resetPerspective;

-(void) forceUpdateObjects;

/// 切换缩放比
/// @param scale 0~1  0:为模型最大状态  1：模型最小状态
-(void) setModelScale:(float)scale;

/// 切换内饰
/// @param color 内饰颜色
-(void) changeInner:(ZKR3DCarColor)color;

/// 切换金属饰条
/// @param chrome 金属饰条
-(void) changeChrome:(NSString *)chrome;

/// 切换视觉动画
/// 1: 格栅视觉  2: 轮毂视觉
-(void) toEntityAnimation:(NSString *)animation;

@end

NS_ASSUME_NONNULL_END
