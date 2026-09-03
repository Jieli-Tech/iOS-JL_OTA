//
//  JLDeviceConfigAIGlasses.h
//  JL_BLEKit
//
//  Created by EzioChan on 2026/7/13.
//  Copyright © 2026 www.zh-jieli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JL_BLEKit/JLDeviceConfigFuncModel.h>

NS_ASSUME_NONNULL_BEGIN

//MARK: - 芯片信息 
/// 智能眼镜芯片信息
@interface JLGlassesChipInfo : NSObject

/// 芯片标识
@property (nonatomic, assign) uint32_t chipFlag;

/// 芯片名称
@property (nonatomic, copy) NSString *chipName;

-(instancetype)initWithData:(NSData *)data;

@end

//MARK: - 翻译功能 
/// 智能眼镜翻译功能配置
@interface JLGlassesTranslationFunc : NSObject

/// 原始配置值
@property (nonatomic, assign) uint8_t cfgValue;

/// 是否支持翻译功能 
@property (nonatomic, assign) BOOL supported;

/// 是否使用 A2DP 播报 
@property (nonatomic, assign) BOOL useA2DP;

/// 是否支持通话翻译 OPUS 立体声 
@property (nonatomic, assign) BOOL supportOpusStereo;

/// 音视频翻译是否下发报文音频
@property (nonatomic, assign) BOOL sendAudioWithText;

/// 是否支持同声翻译 
@property (nonatomic, assign) BOOL supportSimultaneous;

-(instancetype)initWithData:(NSData *)data;

@end

//MARK: - 视频功能
/// 智能眼镜视频功能配置
@interface JLGlassesVideoFunc : NSObject

/// 原始配置值
@property (nonatomic, assign) uint8_t cfgValue;

/// 是否支持视频功能(前置条件)
@property (nonatomic, assign) BOOL supported;

/// 是否支持拍照功能 
@property (nonatomic, assign) BOOL supportPhoto;

/// 是否支持录像功能 
@property (nonatomic, assign) BOOL supportRecord;

/// 是否支持流媒体功能 
@property (nonatomic, assign) BOOL supportStreamMedia;

-(instancetype)initWithData:(NSData *)data;

@end

//MARK: - 音频功能
/// 智能眼镜音频功能配置
@interface JLGlassesAudioFunc : NSObject

/// 配置区1 原始值
@property (nonatomic, assign) uint8_t cfgValue1;

/// 配置区2 原始值
@property (nonatomic, assign) uint8_t cfgValue2;

// --- 配置区1 ---
/// 是否支持音频功能(前置条件)
@property (nonatomic, assign) BOOL supported;

/// 是否支持音效调节(EQ) 
@property (nonatomic, assign) BOOL supportEQ;

/// 是否支持录音功能 
@property (nonatomic, assign) BOOL supportRecord;

/// 是否支持魔音(卡拉OK) 
@property (nonatomic, assign) BOOL supportKaraoke;

/// 是否支持降噪(ANC) 
@property (nonatomic, assign) BOOL supportANC;

/// 是否支持辅听功能 
@property (nonatomic, assign) BOOL supportHearingAssist;

/// 是否支持自适应ANC 
@property (nonatomic, assign) BOOL supportAutoANC;

// --- 配置区2 ---
/// 是否支持智能免摘功能 
@property (nonatomic, assign) BOOL supportSmartPickFree;

/// 是否支持场景降噪功能 
@property (nonatomic, assign) BOOL supportSceneNoiseReduction;
    
/// 是否支持风噪检测功能 
@property (nonatomic, assign) BOOL supportWindNoiseDetection;

/// 是否支持人声增强模式 
@property (nonatomic, assign) BOOL supportVocalBoost;

/// 是否支持多场景调音功能 
@property (nonatomic, assign) BOOL supportMultiSceneTuning;

/// 是否支持录音文件功能
@property (nonatomic, assign) BOOL supportRecordFile;

-(instancetype)initWithData:(NSData *)data;

@end

//MARK: - 大数据传输功能
/// 智能眼镜大数据传输功能配置
@interface JLGlassesBigDataFunc : NSObject

/// 原始配置值
@property (nonatomic, assign) uint8_t cfgValue;

/// 是否支持大数据传输功能
@property (nonatomic, assign) BOOL supported;

/// 是否支持读取设备描述信息
@property (nonatomic, assign) BOOL supportReadDeviceDesc;

-(instancetype)initWithData:(NSData *)data;

@end

//MARK: - AI功能
/// 智能眼镜 AI 功能配置
@interface JLGlassesAIFunc : NSObject

/// 原始配置值
@property (nonatomic, assign) uint8_t cfgValue;

/// 是否支持 AI 功能(前置条件)
@property (nonatomic, assign) BOOL supported;

/// 是否支持 AI 云服务功能
@property (nonatomic, assign) BOOL supportCloud;

/// 是否支持 AI 表盘功能
@property (nonatomic, assign) BOOL supportDial;

/// 是否支持 AI 对话功能
@property (nonatomic, assign) BOOL supportChat;

-(instancetype)initWithData:(NSData *)data;

@end

//MARK: - 文件管理功能 
/// 智能眼镜文件管理功能配置
@interface JLGlassesFileManagerFunc : NSObject

/// 原始配置值
@property (nonatomic, assign) uint8_t cfgValue;

/// 是否支持文件管理功能 
@property (nonatomic, assign) BOOL supported;

/// 是否支持文件浏览功能 
@property (nonatomic, assign) BOOL supportFileBrowse;

/// 是否支持读取 LRC 歌词 
@property (nonatomic, assign) BOOL supportReadLrc;

/// 是否支持大文件传输 
@property (nonatomic, assign) BOOL supportLargeFileTransfer;

/// 是否支持小文件传输 
@property (nonatomic, assign) BOOL supportSmallFileTransfer;

/// 是否支持资源更新 
@property (nonatomic, assign) BOOL supportResourceUpdate;

/// 是否支持提示音替换 
@property (nonatomic, assign) BOOL supportReplaceTipsVoice;

-(instancetype)initWithData:(NSData *)data;

@end

//MARK: - 智能眼镜配置信息数据结构
/// 智能眼镜配置信息数据结构 
@interface JLDeviceConfigAIGlasses : JLDeviceConfigBasic

/// 翻译功能 
@property (nonatomic, strong, nullable) JLGlassesTranslationFunc *translationFunc;

/// 芯片信息 
@property (nonatomic, strong, nullable) JLGlassesChipInfo *chipInfo;

/// 视频功能 
@property (nonatomic, strong, nullable) JLGlassesVideoFunc *videoFunc;

/// 音频功能 
@property (nonatomic, strong, nullable) JLGlassesAudioFunc *audioFunc;

/// 文件管理功能 
@property (nonatomic, strong, nullable) JLGlassesFileManagerFunc *fileManagerFunc;

/// 大数据传输功能
@property (nonatomic, strong, nullable) JLGlassesBigDataFunc *bigDataFunc;

/// AI 功能
@property (nonatomic, strong, nullable) JLGlassesAIFunc *aiFunc;

@end

NS_ASSUME_NONNULL_END
