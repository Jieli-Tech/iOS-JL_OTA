//
//  JLModel_ANC.h
//  JL_BLEKit
//
//  Created by 杰理科技 on 2021/10/15.
//  Copyright © 2021 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(UInt8,JL_AncMode) {
    JL_AncMode_Normal               = 0,    //普通模式
    JL_AncMode_NoiseReduction       = 1,    //降噪模式
    JL_AncMode_Transparent          = 2,    //通透模式
};

@interface JLModel_ANC : NSObject
@property(assign,nonatomic)JL_AncMode       mAncMode;               //耳机降噪模式
@property(assign,nonatomic) uint16_t        mAncMax_L;              //左耳最大增益
@property(assign,nonatomic) uint16_t        mAncCurrent_L;          //左耳当前增益
@property(assign,nonatomic) uint16_t        mAncMax_R;              //右耳最大增益
@property(assign,nonatomic) uint16_t        mAncCurrent_R;          //右耳当前增益
-(NSData*)dataModel;
@end



/// 手机名/经典蓝牙地址信息
@interface JLTWSAddrNameInfo : NSObject

/// 是否被绑定
@property(nonatomic,assign)uint8_t isBind;

/// 手机蓝牙地址
@property(nonatomic,strong)NSData *phoneEdrAddr;

/// 手机名称
@property(nonatomic,strong)NSString *phoneName;

/// 初始化数据成对象
/// - Parameter data: 数据内容
+(NSArray<JLTWSAddrNameInfo *>*)dataBeObjc:(NSData *)data;

@end
NS_ASSUME_NONNULL_END
