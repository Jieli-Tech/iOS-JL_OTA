//
//  JLOtaAdv.h
//  JL_AdvParse
//
//  Created by EzioChan on 2023/12/12.
//  Copyright © 2023 www.zh-jieli.com. All rights reserved.
//

#import <JL_AdvParse/JL_AdvParse.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLOtaAdv : JLDevicesAdv

/// ble address before
@property(nonatomic,strong)NSString *BleAddrBefore;

//MARK: - Version 1
/// battery
@property(nonatomic,assign)uint8_t battery;


@end

NS_ASSUME_NONNULL_END
