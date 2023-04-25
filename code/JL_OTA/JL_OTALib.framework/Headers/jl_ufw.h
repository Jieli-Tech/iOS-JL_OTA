/**
 * Des: 
 * author: Bob
 * date: 2022/11/29
 * Copyright: Jieli Technology
 */

#ifndef NATIVEAPPLICATION_JL_UFW_H
#define NATIVEAPPLICATION_JL_UFW_H


#include <stdio.h>
#include <string.h>
#include <stdlib.h>
//#include <android/log.h>
//#include <jni.h>
//
//#define tag "myJNI"
//#define logi(TAG, ...)  ((void)__android_log_print(ANDROID_LOG_INFO, TAG, __VA_ARGS__))
//#define logw(TAG, ...)  ((void)__android_log_print(ANDROID_LOG_WARN, TAG, __VA_ARGS__))
//#define loge(TAG, ...)  ((void)__android_log_print(ANDROID_LOG_ERROR, TAG, __VA_ARGS__))

int parse_fw_info(const char *data, int size, uint8_t *resultBuff, uint32_t buffSize);
#define     BIT(n)	            (1 << n)

// for FW file
enum eFW_FILE_TYPE {

    FILE_TYPE_FW_FLASH_BIN = 0,     // FLASH文件，第一块FLASH数据
    FILE_TYPE_FW_OTP_BIN = 1,       // OTP文件
    FILE_TYPE_FW_INFO_LOG = 2,      // FW文件中保存的描述信息
    FILE_TYPE_FW_BURN_CFG = 3,      // 烧写器配置文件
    FILE_TYPE_FW_SCRIPT_DATA = 4,   // 烧写器打包烧写器下载文件时，需要执行的脚本数据
    FILE_TYPE_FW_SRC = 5,           // 需要保存在FW文件中的代码文件, FW文件查看/编辑器都不能显示这些数据
    FILE_TYPE_FW_NAME_BIN = 6,      // 升级名字用的FW文件，已经废除
    FILE_TYPE_FW_OTP_VER_BIN = 7,   // OTP maskrom版本
    FILE_TYPE_FW_OTPCFG_BIN = 8,    // OTP配置信息
    FILE_TYPE_FW_OTP_CHIP_CONTROL_BIN = 9,  // OTP芯片控制信息

    FILE_TYPE_FW_OTP_MINI_UBOOT = 0xA,      // 烧写到OTP的MINI UBOOT文件
    FILE_TYPE_FW_OTP_FIX_UBOOT = 0xB,       // 烧写到OTP的FIX UBOOT文件
    FILE_TYPE_FW_FLASH_2_BIN = 0xC,         // 第二块FLASH数据
    FILE_TYPE_FW_BR18_EFUSE_CONFIG_BIN = 0xD,   // BR18 24BIT EFUSE配置数据
    FILE_TYPE_FW_RESOURCE_FILE = 0xE,           // 资源文件
    FILE_TYPE_FW_2018KEY_INFO = 0xF,        // 2018年的新KEY信息

    FILE_TYPE_FW_BURNER_CUSTOMER_DATA = 0x10,       // 一拖八烧写器用户信息
    FILE_TYPE_FW_BURNER_DV15_FLASH_BIN = 0x11,         // 一拖八烧写器第一块FLASH数据
    FILE_TYPE_FW_BURNER_APP_FLASH_BIN = 0x12,         // 一拖八烧写器第二块FLASH数据
    FILE_TYPE_FW_BURNER_DATA_FLASH_BIN = 0x13,         // 一拖八烧写器第三块FLASH数据
    FILE_TYPE_FW_BURNER_BR21_FLASH_BIN = 0x14,         // 一拖八烧写器第四块FLASH数据

    FILE_TYPE_FW_FLASH_BIN_2 = 0x20,        // 下载到第一块FLASH的文件，下载工具根据条件要么下载FILE_TYPE_FW_FLASH_BIN，要么下载FILE_TYPE_FW_FLASH_BIN_2
    FILE_TYPE_FW_FLASH_BIN_3,
    FILE_TYPE_FW_FLASH_BIN_4,

    FILE_TYPE_FW_LOADER_BIN = 0x31,   // 打包的LOADER程序代码

    FILE_TYPE_FW_TEST_BOX_OTA_BIN = 0x64,   // 测试盒使用的ota.bin

    FILE_TYPE_FW_3RD_DATA_FILE = 0x71, // 第三方烧写数据

    FILE_TYPE_FW_OTA_TARGET_DEVICE_INFO = 0xA0,
    FILE_TYPE_FW_BURN_COUNT_LIMIT = 0xA1,   // 烧写授权信息

    FILE_TYPE_FW_ADDITIONAL_FILE = 0xEE,  // 附加文件，由烧写器根据名字决定用途
    FILE_TYPE_FW_PASSTHROUGH_DATA = 0xEF,  // AC691X BTIF数据
    // 仅存在于FW文件中的数据
    FILE_TYPE_FW_HIDDEN_CFG_BIN = 0xFA,
    FILE_TYPE_FW_INVISIBLE_DATA = 0xFB,    // 保存在FW文件中的隐藏数据,FW文件查看/编辑器都不能显示这些数据
    FILE_TYPE_FW_VISIBLE_DATA = 0xFE,   // 仅保存在FW文件中的HEX数据

    FILE_TYPE_FW_TAIL = 0xFF,           // FW文件尾部标识
};

typedef struct U16BIT
{
    unsigned char b0 : 1;
    unsigned char b1 : 1;
    unsigned char b2 : 1;
    unsigned char b3 : 1;
    unsigned char b4 : 1;
    unsigned char b5 : 1;
    unsigned char b6 : 1;
    unsigned char b7 : 1;
    unsigned char b8 : 1;
    unsigned char b9 : 1;
    unsigned char b10 : 1;
    unsigned char b11 : 1;
    unsigned char b12 : 1;
    unsigned char b13 : 1;
    unsigned char b14 : 1;
    unsigned char b15 : 1;

} U16BIT;
typedef union UBIT16
{
    U16BIT bits;
    uint16_t val;
} UBIT16;

typedef struct stRES_FILE_HEAD {
    uint32_t u32Tag;
    uint16_t u16Crc;
    uint16_t u16CrcOfItems;
    uint32_t u32Len;
    uint16_t u16Count;
    uint16_t u16Res;
    uint8_t u8Res16[16];
}RES_FILE_HEAD;

typedef struct stRES_CONFIG_ITEM {
    uint16_t u16Index;
    uint16_t u16Type;
    uint32_t u32Addr;
    uint32_t u32Len;
    uint16_t u16CrcOfData;
    uint16_t u16Res;
    char szName[16];
}RES_CONFIG_ITEM;
static uint16_t m_u16ChipKey = 0xFFFF;
static uint16_t m_u16DefaultKey = 0xFFFF;


#pragma pack(1)
#define JL_FILE_ITEM_NAME_MAX_LEN 16
#define JL_CHIP_KEY_ENC_LENGTH 32

typedef struct stUFW_SYD_HEAD_V1 {
    uint16_t u16Crc;          // crc16 for this struct
    uint16_t u16CrcOfSydFileHead;
    uint32_t u32FileLength;  // file length
    uint16_t u16FileCount;   // 此FW文件中包含的子文件个数
    uint16_t u16Version;
    uint32_t u32Res;
    char    szChipName[16]; // 此FW文件对应的芯片类型，如AC690X，AC691X
    uint32_t u32Res2[4];
    uint32_t u32Res3[4];
}UFW_SYD_HEAD_V1;

typedef struct stUFW_FILE_HEAD_V1 {
    uint8_t u8FileType;              // 文件类型
    uint8_t u8Res;                   // 保留
    uint16_t u16Index;               // 文件索引号
    uint16_t u16Crc;                 // 明文数据的校验码
    uint16_t u16Version;             // 本结构体版本
    uint32_t u32Addr;                // 地址
    uint32_t u32Length;              // 数据长度
    uint32_t u32AllLength;           // 数据长度+尾部对齐的数据长度
    uint32_t u32EncryptedAddr;       // 加密数据的地址偏移（相对u32Addr的地址）
    uint32_t u32EncryptedLength;     // 加密的数据长度
    uint32_t u32Res;                 // 保留
    uint32_t u64Res1[4];             // 保留
    uint32_t u64Res2[4];             // 保留
    char name[JL_FILE_ITEM_NAME_MAX_LEN];

}UFW_FILE_HEAD_V1;

typedef struct stJL_FILE_TAIL {
    char    szChipKey[JL_CHIP_KEY_ENC_LENGTH];      // 32   // 固定位置
    uint16_t u16ChipKeyCRC16;    // 34           // 固定位置
    uint8_t  u8Magic[6];         // 40           // 固定位置
    uint8_t  u8Res8[8];          // 48
    char    szTailChipName[6];      // 54           // 固定位置
    uint8_t  u8Reserv10[10];     // 64
}JL_FILE_TAIL;

typedef struct {
    char szName[3];
    char szVersion[3];
    uint8_t  u8Flag;
    uint8_t u8Res;
    uint32_t u32Crc;
    uint16_t u16Crc;
    uint16_t u16Res;
}JL_FLASH_BIN_TAIL;

typedef UFW_SYD_HEAD_V1 jl_ufw_syd_head;
typedef UFW_FILE_HEAD_V1 jl_ufw_file_head;
typedef JL_FILE_TAIL jl_ufw_tail;

typedef struct stJL_BR22_FLASH_HEAD {
    uint16_t u16Crc;             // 结构体自身校验码
    uint8_t  u8SizeForBurner;    // 为烧写器保留的空间大小
    uint8_t  u8Version;          // FLASH FS版本号
    char vid[4];                // 4byte的vid
    uint32_t u32FlashSize;       // FLASH大小,由isd_download计算得出
    uint8_t u8FsVersion;            // 类型:br18/br22
    uint8_t u8BlockAlingnModulus;      // 对齐系数
    uint8_t u8Res;        // 保留，以后有可能会用于存放顶层目录的偏移和文件目录内偏移信息
    uint8_t u8SpecialOptFlag;    // 用于标记是否需要生成2种flash格式的标记位，目前只用1位，以后如果需要特殊操作需要标记，再用其他位
    char pid[16];               // 16byte的pid
}JL_BR22_FLASH_HEAD;










#pragma pack()


#endif //NATIVEAPPLICATION_JL_UFW_H
