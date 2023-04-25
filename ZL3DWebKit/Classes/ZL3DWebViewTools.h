//
//  ZL3DWebViewTools.h
//  ZL3DWebKit
//
//  Created by luokan on 2022/9/13.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ZLCarColor) {
    ZLCarColor_White, // 极昼白
    ZLCarColor_Black, // 碳素黑
    ZLCarColor_Grey,  // 镭射灰
    ZLCarColor_Blue,  // 电光蓝
    ZLCarColor_Red,  //  星尘红
    ZLCarColor_Purple,// 极光紫
    ZLCarColor_Brown,//  钛棕
};

typedef NSString *ZKR3DCarColor NS_STRING_ENUM;
typedef NSString *ZKR3DCarWheelName NS_STRING_ENUM;
typedef NSString *ZKR3DCarDisplay NS_STRING_ENUM;

/*********************** 车身颜色 **********************************/
FOUNDATION_EXPORT ZKR3DCarColor const ZKR3DCarColorWhite; // 极昼白
FOUNDATION_EXPORT ZKR3DCarColor const ZKR3DCarColorBlack; // 碳素黑
FOUNDATION_EXPORT ZKR3DCarColor const ZKR3DCarColorGrey;  // 镭射灰
FOUNDATION_EXPORT ZKR3DCarColor const ZKR3DCarColorGray;  // 银色
FOUNDATION_EXPORT ZKR3DCarColor const ZKR3DCarColorBlue;  // 电光蓝
FOUNDATION_EXPORT ZKR3DCarColor const ZKR3DCarColorRed;   //  星尘红
FOUNDATION_EXPORT ZKR3DCarColor const ZKR3DCarColorPurple; // 极光紫
FOUNDATION_EXPORT ZKR3DCarColor const ZKR3DCarColorBrown; //  钛棕

/*********************** 车系 **********************************/
FOUNDATION_EXPORT ZKR3DCarDisplay const ZKR3DCarDisplay001; //  001 车型
FOUNDATION_EXPORT ZKR3DCarDisplay const ZKR3DCarDisplay009; //  009 车型


/*********************** 轮毂 **********************************/
FOUNDATION_EXPORT ZKR3DCarWheelName const ZKR3DCarWheelName_22InchEnergySmoothBladeHubWithFourPistonCaliper; //22英寸能量光刃轮毂带四活塞卡钳
FOUNDATION_EXPORT ZKR3DCarWheelName const ZKR3DCarWheelName_21InchAirSwirlHub; //21英寸空气涡流轮毂

FOUNDATION_EXPORT ZKR3DCarWheelName const ZKR3DCarWheelName_21InchArcPhantomHubWithFourPistonCaliper; //21英寸弧光幻影轮毂带四活塞卡钳
    
FOUNDATION_EXPORT ZKR3DCarWheelName const ZKR3DCarWheelName_21InchMultiSpokeHubWithFourPistonCaliper; //21英寸多幅射线轮毂带四活塞卡钳
    
FOUNDATION_EXPORT ZKR3DCarWheelName const ZKR3DCarWheelName_19Inch5SpokeLightAluminumAlloyWheelHub;//19英寸5幅轻铝合金轮毂
    

NS_ASSUME_NONNULL_BEGIN

@interface ZL3DWebViewTools : NSObject

@end

NS_ASSUME_NONNULL_END
