//
//  JL_MSG_Weather.h
//  JL_BLEKit
//
//  Created by EzioChan on 2021/5/13.
//  Copyright © 2021 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : uint8_t {
    ///晴天
    WEATHER_Sunny = 0x00,
    ///少云
    WEATHER_CloudLess,
    ///晴间多云
    WEATHER_PartlyCloudy,
    ///多云
    WEATHER_Cloudiness,
    ///阴天
    WEATHER_OvercastSky,
    ///有风/和风/清风/微风
    WEATHER_Breeze,
    ///平静
    WEATHER_CalmWind,
    ///大风/强风/劲风/疾风
    WEATHER_HighWind,
    ///飓风/狂爆风
    WEATHER_Hurricane,
    ///热带风暴/风暴
    WEATHER_TropicalStorm,
    ///霾/中度霾/重度霾/严重霾
    WEATHER_Haze,
    ///阵雨
    WEATHER_Shower,
    ///雷阵雨
    WEATHER_ThunderShower,
    ///雷阵雨并伴有冰雹
    WEATHER_HallThunderShower,
    ///雨/小雨/毛毛雨/细雨/小雨-中雨
    WEATHER_LightRain,
    ///中雨/中雨-大雨
    WEATHER_ModerateRain,
    ///大雨/大雨-暴雨
    WEATHER_HeavyRain,
    ///暴雨/暴雨-大暴雨
    WEATHER_Downpour,
    ///大暴雨/大暴雨-特大暴雨
    WEATHER_ExtraordinaryRainstorm,
    ///特大暴雨
    WEATHER_HeavyDownpour,
    ///强阵雨
    WEATHER_StrongRainShower,
    ///强雷阵雨
    WEATHER_StrongThunderShower,
    ///极端降雨
    WEATHER_ExtremeRainfall,
    ///雨夹雪/阵雨夹雪/冻雨/雨雪天气
    WEATHER_RainySnowy,
    ///雪
    WEATHER_Snowy,
    ///阵雪
    WEATHER_SnowShower,
    ///小雪/小雪-中雪
    WEATHER_LightSnow,
    ///中雪/中雪-大雪
    WEATHER_ModerateSnow,
    ///大雪/大雪-暴雪
    WEATHER_HeavySnow,
    ///暴雪
    WEATHER_Snowstorm,
    ///浮尘
    WEATHER_Dust,
    ///扬沙
    WEATHER_blowingSand,
    ///沙尘暴
    WEATHER_dustStorm,
    ///强沙尘暴
    WEATHER_SevereSandstorm,
    ///龙卷风
    WEATHER_Tornado,
    ///雾/轻雾/浓雾/强浓雾/特强浓雾
    WEATHER_Fog,
    ///未知
    WEATHER_Unknow,
    ///冷
    WEATHER_Cold,
    ///未知2
    WEATHER_Unknown1,
    
} WeatherType;


typedef enum : NSUInteger {
    ///无风向
    wDirection_None,
    ///东风
    wDirection_East,
    ///南风
    wDirection_South,
    ///西风
    wDirection_West,
    ///北风
    wDirection_North,
    ///东南风
    wDirection_EastSouth,
    ///东北风
    wDirection_EastNorth,
    ///西北风
    wDirection_WestNorth,
    ///西南风
    wDirection_WestSouth,
    ///旋转不定
    wDirection_Unknow
    
} WDirectionType;

@interface JL_MSG_Weather : NSObject

/// 省份
@property(nonatomic,strong)NSString *province;
///城市
@property(nonatomic,strong)NSString *city;
///天气编码
@property(nonatomic,assign)WeatherType code;
///温度
@property(nonatomic,assign)NSInteger temperature;
///湿度
@property(nonatomic,assign)NSInteger humidity;
///风向编码
@property(nonatomic,assign)WDirectionType direction;
///风力
@property(nonatomic,assign)NSInteger wind;
/// 时间
@property(nonatomic,strong)NSDate *date;


-(NSData *)beData;


@end

NS_ASSUME_NONNULL_END
