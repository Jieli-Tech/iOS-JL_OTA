//
//  JL_LightManager.h
//  JL_BLEKit
//
//  Created by 李放 on 2021/12/16.
//  Modify by EzioChan on 2023/03/16
//  Copyright © 2021 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JL_FunctionBaseManager.h>
#import <JL_BLEKit/JL_TypeEnum.h>
#import <JL_BLEKit/JL_Tools.h>


NS_ASSUME_NONNULL_BEGIN

@class JL_LightManager;

@protocol JLLightStatusPtl <NSObject>

-(void)jlLightStatus:(JL_LightManager *)lightManager;

@end


@interface JL_LightManager : JL_FunctionBaseManager

/// 当前设备是否支持灯光设置
@property(nonatomic,assign)BOOL isSupportLight;

/// 0:关闭 1：打开 2：设置模式(彩色/闪烁/情景)
@property (assign,nonatomic) JL_LightState      lightState;

// 0：彩色 1:闪烁 2: 情景
@property (assign,nonatomic) JL_LightMode       lightMode;

/// 灯光红色
@property (assign,nonatomic) uint8_t            lightRed;

/// 灯光绿色
@property (assign,nonatomic) uint8_t            lightGreen;

/// 灯光蓝色
@property (assign,nonatomic) uint8_t            lightBlue;

/// 闪烁模式Index
@property (assign,nonatomic) JL_LightFlashModeIndex lightFlashIndex;

/// 闪烁频率Index
@property (assign,nonatomic) JL_LightFlashModeFrequency lightFrequencyIndex;

/// 情景模式Index
@property (assign,nonatomic) JL_LightSceneMode  lightSceneIndex;

// 色调，范围0-360
@property (assign,nonatomic) uint16_t           lightHue;

// 饱和度，0-100
@property (assign,nonatomic) uint8_t            lightSat;

// 亮度，0-100
@property (assign,nonatomic) uint8_t            lightLightness;

/// 状态更新代理委托
@property (weak,nonatomic)id<JLLightStatusPtl> delegate;


/// 获取灯光设置，通过代理返回
-(void)cmdGetLightStatus;
/**
 *  设置灯光
 *  @param lightState 灯光状态
 *  @param lightMode 灯光模式
 *  @param red 红色色值
 *  @param green 绿色色值
 *  @param blue 蓝色色值
 *  @param flashIndex 闪烁模式index
 *  @param flashFreqIndex 闪烁频率
 *  @param sceneIndex 情景模式
 *  @param hue 色调，范围0-360
 *  @param saturation 饱和度，0-100
 *  @param lightness 亮度，0-100
 */
-(void)cmdSetState:(JL_LightState)lightState
              Mode:(JL_LightMode)lightMode
               Red:(uint8_t)red
             Green:(uint8_t)green
              Blue:(uint8_t)blue
         FlashInex:(JL_LightFlashModeIndex)flashIndex
         FlashFreq:(JL_LightFlashModeFrequency)flashFreqIndex
        SceneIndex:(JL_LightSceneMode)sceneIndex
               Hue:(uint16_t)hue
        Saturation:(uint8_t)saturation
         Lightness:(uint8_t)lightness;

@end

NS_ASSUME_NONNULL_END
