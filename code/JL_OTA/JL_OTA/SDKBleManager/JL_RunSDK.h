//
//  JL_RunSDK.h
//  JL_OTA_InnerBle
//
//  Created by 凌煊峰 on 2021/10/9.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JL_BLEKit.h>

#define SMALL_V @"v"

#define BIG_V   @"V"

#define kJL_AGRESS_PROTOCOL @"agress_protocol"

#define KEY_COMMIT_PROTOCOL  @"commit_protocol"

#define kJL_HeightNavBar ([UIApplication sharedApplication].delegate.window.safeAreaInsets.top+44.0)


NS_ASSUME_NONNULL_BEGIN

@protocol JL_RunSDKOtaDelegate <NSObject>

@required
/**
 *  ota升级过程状态回调
 */
- (void)otaProgressWithOtaResult:(JL_OTAResult)result withProgress:(float)progress;

@end

@interface JL_RunSDK : NSObject

@property (strong, nonatomic) JL_BLEMultiple *mBleMultiple;
@property (weak, nonatomic) JL_EntityM *__nullable mBleEntityM;
@property (weak, nonatomic) id<JL_RunSDKOtaDelegate> otaDelegate;

/**
 * 单例
 */
+ (instancetype)sharedInstance;

+ (NSString *)textEntityStatus:(JL_EntityM_Status)status;
- (JL_EntityM *)getEntity:(NSString *)uuid;

#pragma mark - 杰理蓝牙库OTA流程相关业务

typedef void(^GET_DEVICE_CALLBACK)(BOOL needForcedUpgrade);


-(void)startLoopConnect:(NSString *)uuid;

/**
 *  获取已连接的蓝牙设备信息
 */
- (void)getDeviceInfo:(GET_DEVICE_CALLBACK _Nonnull)callback;

/**
 *  OTA升级
 */
- (void)otaFuncWithFilePath:(NSString *)otaFilePath;

+(double)getWidthWithString:(NSString*)str font:(UIFont*)font;

+(NSAttributedString *)getAttributeWith:(id)sender string:(NSString *)string orginFont:(CGFloat)orginFont orginColor:(UIColor *)orginColor attributeFont:(CGFloat)attributeFont attributeColor:(UIColor *)attributeColor;

@end

NS_ASSUME_NONNULL_END
