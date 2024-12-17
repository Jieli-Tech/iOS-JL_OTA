//
//  UpdateStatusCell.m
//  JL_OTA
//
//  Created by EzioChan on 2022/11/30.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "UpdateStatusCell.h"
#import "BroadcastThread.h"
#import "ToolsHelper.h"
#import "DeviceManager.h"



@interface UpdateStatusCell()<OtaUpdatePtl>

@property(nonatomic,strong)NSString *errorReason;
@property(nonatomic,strong)NSTimer *checkStatusTimer;
@property(nonatomic,assign)NSTimeInterval countTime;
@property(nonatomic,assign)NSTimeInterval maxTime;
@end

@implementation UpdateStatusCell


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _maxTime = 20;
        _countTime = 0;
        _mainLab = [UILabel new];
        _mainLab.font = [UIFont systemFontOfSize:14];
        _mainLab.textColor = [UIColor colorFromHexString:@"#242424"];
        [self addSubview:_mainLab];
        
        _progress = [UIProgressView new];
        _progress.trackTintColor = [UIColor colorFromHexString:@"#D8D8D8"];
        _progress.tintColor = [UIColor colorFromHexString:@"#398BFF"];
        _progress.progress = 0;
        _progress.layer.cornerRadius = 1.5;
        _progress.layer.masksToBounds = true;
        [self addSubview:_progress];
        
        _proLab = [UILabel new];
        _proLab.font = [UIFont systemFontOfSize:15];
        _proLab.textColor = [UIColor colorFromHexString:@"#398BFF"];
        [self addSubview:_proLab];
        
        _statusBtn = [UIButton new];
        [_statusBtn addTarget:self action:@selector(statusBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_statusBtn setImage:[UIImage imageNamed:@"icon_success_24_nol"] forState:UIControlStateNormal];
        [self addSubview:_statusBtn];
        
        [_statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self);
            make.left.equalTo( self).inset(24);
            make.height.width.offset(24);
        }];
        
        [_statusBtn setHidden:YES];
        
        [_mainLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top).offset(12);
            make.left.equalTo( self.mas_left).offset(24);
            make.height.offset(20);
        }];
        
        [_progress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo( self.mas_bottom).offset(-12);
            make.left.equalTo( self).inset(24);
            make.right.equalTo(_proLab.mas_left).offset(-16);
            make.height.offset(3);
        }];
        
        [_proLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo( self).inset(16);
            make.left.equalTo(_progress.mas_right).offset(16);
            make.height.offset(20);
            make.bottom.equalTo( self.mas_bottom).offset(-4);
        }];
        
        [[BroadcastThread share] addDelegate:self];
        
       
        self.progress.progress = 0.0;
        self.proLab.text = [NSString stringWithFormat:@"%d%%",(int)(0.0*100.0)];
    }
    return self;
}

-(void)setDeviceName:(NSString *)deviceName{
    _deviceName = deviceName;
    _mainLab.text = [NSString stringWithFormat:@"%@：%@",self.deviceName,self.updateName];
}

-(void)setUpdateName:(NSString *)updateName{
    _updateName = updateName;
    _mainLab.text = [NSString stringWithFormat:@"%@：%@",self.deviceName,self.updateName];
}


-(void)startTimer{
    _countTime = 0;
    if(self.checkStatusTimer == nil){
        [self.checkStatusTimer invalidate];
        self.checkStatusTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkTime) userInfo:nil repeats:true];
        [self.checkStatusTimer fire];
//        kJLLog(JLLOG_DEBUG, @"timer start:%@",self);
    }
}

-(void)checkTime{
    _countTime++;
    if(_countTime>_maxTime){
        [self status:JL_OTAResultFailCmdTimeout];
    }
//    kJLLog(JLLOG_DEBUG, @"timer add:%@",self);
}


-(void)endTimer{
    [self.checkStatusTimer invalidate];
    _countTime = 0;
//    kJLLog(JLLOG_DEBUG, @"timer end:%@",self);
}


-(void)status:(JL_OTAResult)status{
    
    if([self isFinish:status]){
        [_statusBtn setHidden:NO];
        self.progress.hidden = YES;
        self.proLab.hidden = YES;
        [_mainLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo( self);
            make.left.equalTo(_statusBtn.mas_right).offset(8);
            make.height.offset(20);
        }];
    }else{
        [_statusBtn setHidden:YES];
        self.progress.hidden = NO;
        self.proLab.hidden = NO;
        [_mainLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo( self.mas_top).offset(12);
            make.left.equalTo( self.mas_left).offset(24);
            make.height.offset(20);
        }];
    }
}


-(void)statusBtnAction{
    if([_delegate respondsToSelector:@selector(update)]){
        [_delegate updateStatusDidFinishWithCbp:self.mainCbp];
    }
}




-(void)otaResult:(CBPeripheral *)cbp Status:(JL_OTAResult)result Progress:(float) progress{
    if([_mainCbp.identifier.UUIDString isEqualToString:cbp.identifier.UUIDString]){
        _mainLab.text = [NSString stringWithFormat:@"%@：%@",self.deviceName,self.updateName];
        self.progress.progress = progress;
        self.proLab.text = [NSString stringWithFormat:@"%d%%",(int)(progress*100.0)];
        [self status:result];
        
    }
}
-(void)otaResult:(CBPeripheral *)cbp Old:(CBPeripheral *)oldCbp Status:(JL_OTAResult)result Progress:(float) progress{
    if([_mainCbp.identifier.UUIDString isEqualToString:oldCbp.identifier.UUIDString]){
        _mainLab.text = [NSString stringWithFormat:@"%@：%@",self.deviceName,self.updateName];
        self.progress.progress = progress;
        self.proLab.text = [NSString stringWithFormat:@"%d%%",(int)(progress*100.0)];
        [self status:result];
        
    }
    
}

- (void)otaResultIsBegin:(CBPeripheral *)cbp{
    if([_mainCbp.identifier.UUIDString isEqualToString:cbp.identifier.UUIDString]){
        [self startTimer];
    }
}


-(BOOL)isFinish:(JL_OTAResult)result{
    switch (result) {
        case JL_OTAResultSuccess:
            [_statusBtn setImage:[UIImage imageNamed:@"icon_success_24_nol"] forState:UIControlStateNormal];
            [self endTimer];
            _mainLab.text = [NSString stringWithFormat:@"%@",self.deviceName];
            return true;
            break;
        case JL_OTAResultReconnect:
            return false;
            break;
        case JL_OTAResultReboot:
            [_statusBtn setImage:[UIImage imageNamed:@"icon_success_24_nol"] forState:UIControlStateNormal];
            _mainLab.text = [NSString stringWithFormat:@"%@",self.deviceName];
            [[BroadcastThread share] next];
            [[BroadcastThread share] removeDelegate:self];
            if([_delegate respondsToSelector:@selector(updateStatusDidFinishWithCbp:)]){
                [_delegate updateStatusDidFinishWithCbp:self.mainCbp];
            }
            [self endTimer];
            return true;
            break;
        case JL_OTAResultPreparing:
            _mainLab.text = [NSString stringWithFormat:@"%@(%@)",self.deviceName,kJL_TXT("verify_file_ing")];
            _countTime = 0;
            return false;
            break;
        case JL_OTAResultPrepared:
            [_statusBtn setImage:[UIImage imageNamed:@"icon_fail_24_nol"] forState:UIControlStateNormal];
            
            return false;
            break;
        case JL_OTAResultReconnectWithMacAddr:
            _mainLab.text = [NSString stringWithFormat:@"%@:%@",self.mainCbp.name,kJL_TXT("reconnecting_back")];
            _countTime = 0;
            return false;
            break;
        case JL_OTAResultUpgrading:
            [_statusBtn setImage:[UIImage imageNamed:@"icon_success_24_nol"] forState:UIControlStateNormal];
            _countTime = 0;
            _mainLab.text = [NSString stringWithFormat:@"%@(%@)",self.deviceName,kJL_TXT("updateing")];
            
            return false;
            break;
        case JL_OTAResultFailVerification:
        case JL_OTAResultFail:
        case JL_OTAResultDataIsNull:
        case JL_OTAResultCommandFail:
        case JL_OTAResultSeekFail:
        case JL_OTAResultInfoFail:
        case JL_OTAResultLowPower:
        case JL_OTAResultEnterFail:
        case JL_OTAResultFailCompletely:
        case JL_OTAResultFailKey:
        case JL_OTAResultFailErrorFile:
        case JL_OTAResultFailUboot:
        case JL_OTAResultFailLenght:
        case JL_OTAResultFailFlash:
        case JL_OTAResultFailCmdTimeout:
        case JL_OTAResultFailSameVersion:
        case JL_OTAResultFailTWSDisconnect:
        case JL_OTAResultFailNotInBin:
        case JL_OTAResultUnknown:
            [_statusBtn setImage:[UIImage imageNamed:@"icon_fail_24_nol"] forState:UIControlStateNormal];
            _mainLab.text = [NSString stringWithFormat:@"%@:error code:0x%hhx",self.deviceName,result];
            if([_delegate respondsToSelector:@selector(updateStatusDidFinishWithCbp:)]){
                [_delegate updateStatusDidFinishWithCbp:self.mainCbp];
            }
            [[BroadcastThread share] next];
            [[BroadcastThread share] removeDelegate:self];
            [self endTimer];
            return false;
            break;
    }
    return false;
}

-(void)dealloc{
    kJLLog(JLLOG_DEBUG, @"dealloc %@",self);
}

@end
