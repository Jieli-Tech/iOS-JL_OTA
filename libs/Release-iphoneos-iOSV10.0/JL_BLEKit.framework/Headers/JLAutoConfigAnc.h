//
//  JLAutoConfigAnc.h
//  JL_BLEKit
//
//  Created by EzioChan on 2022/10/28.
//  Copyright © 2022 www.zh-jieli.com. All rights reserved.
//


#import "ECOneToMorePtl.h"

NS_ASSUME_NONNULL_BEGIN

@class JL_ManagerM;

typedef void(^AutoConfigResult)(BOOL status);

@protocol JLAutoConfigAncPtl <NSObject>


/// 设备正在重新检测自适应降噪
-(void)autoConfigDidConfiging;
///设置自适应降噪失败了
-(void)autoConfigDidFailed;
///设置自适应降噪成功了
-(void)autoConfigDidSucceed;
///关闭自适应降噪
-(void)autoConfigDidClose;

@end


/// 自适应降噪处理类
@interface JLAutoConfigAnc : ECOneToMorePtl

/// 设备开启/关闭自适应降噪的状态
@property (assign,nonatomic)BOOL status;

/// 开启设备自适应降噪
/// 这里只是进入了设备开始适配降噪的命令过程
/// 适配成功与否需要添加协议JLAutoConfigAncPtl进行监听
/**
 interface testView : UIView<JLAutoConfigAncPtl>
 
 @end
 
 -(void)initData{
    JLAutoConfigAnc *anc = [[JLAutoConfigAnc alloc] init];
    [anc addDelegate:self];
 }
 
 -(void)autoConfigDidFailed{
    //设置自适应降噪失败了
 }
 -(void)autoConfigDidSucceed{
    //设置自适应降噪成功了
 }
 -(void)autoConfigDidClose{
    //关闭自适应降噪
 }
*/
/// - Parameter manager: manager
-(void)atAncStartAutoConfigWithManager:(JL_ManagerM*)manager;


/// 打开设备自适应降噪
/// 设备默认有一套已在运行的降噪算法
/// 打开后设备会进入降噪模式，不会经历检测启动自适应的时间，相当于是即时生效
/// - Parameter result: 这里回调的是一个设备命令处理的结果
/// - Parameter manager: manager
-(void)atAncOpenAutoConfigResult:(JL_CMD_RESPOND)result Manager:(JL_ManagerM*)manager;

/// 用户关闭设备的自适应降噪模式算法
/// - Parameter result: 命令处理结果，不代表命令处理成功
/// - Parameter manager: manager
-(void)atAncCloseAutoConfigResult:(JL_CMD_RESPOND)result Manager:(JL_ManagerM*)manager;

/// 获取设备是否开启了自适应降噪
/// - Parameter result: 这里处理的结果是，设备实际是否开启了的结果，无需从代理中获得结果
/// - Parameter manager: manager
-(void)atAncGetAutoConfigResult:(AutoConfigResult)result Manager:(JL_ManagerM*)manager;

          
@end
          

NS_ASSUME_NONNULL_END
