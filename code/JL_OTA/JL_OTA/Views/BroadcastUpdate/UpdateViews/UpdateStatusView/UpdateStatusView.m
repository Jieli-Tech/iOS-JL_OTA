//
//  UpdateStatusView.m
//  JL_OTA
//
//  Created by EzioChan on 2022/11/30.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "UpdateStatusView.h"
#import "UpdateStatusCell.h"
#import "BroadcastThread.h"
#import "BroadcastBleManager.h"


@interface UpdateStatusView()<UpdateStateCellPtl>

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *contentView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIView *subContent;
@property(nonatomic,strong)UILabel *bottomLab;
@property(nonatomic,assign)NSInteger finishIndex;
@property(nonatomic,strong)UITapGestureRecognizer *disTaps;

@property(nonatomic,strong)NSMutableArray *cellArray;

@end

@implementation UpdateStatusView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellArray = [NSMutableArray new];
        self.backgroundColor = [UIColor clearColor];
        self.bgView = [UIView new];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.4;
        [self addSubview:_bgView];
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 16;
        _contentView.layer.masksToBounds = true;
        [self addSubview:_contentView];
        
        _titleLab = [UILabel new];
        _titleLab.font = FontMedium(18);
        _titleLab.textColor = [UIColor colorFromHexString:@"#333333"];
        _titleLab.text = kJL_TXT("updateing");
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [_contentView addSubview:_titleLab];
        
        _subContent = [UIView new];
        _subContent.backgroundColor = [UIColor whiteColor];
        [_contentView addSubview:_subContent];
        
        _bottomLab = [UILabel new];
        _bottomLab.font = [UIFont systemFontOfSize:14];
        _bottomLab.textColor = [UIColor colorFromHexString:@"#919191"];
        _bottomLab.text = kJL_TXT("while_update_please_keep_open_ble_and_network");
        _bottomLab.textAlignment = NSTextAlignmentCenter;
        _bottomLab.numberOfLines = 0;
        [_contentView addSubview:_bottomLab];
        
        
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-10);
            make.left.right.equalTo(self).inset(12);
            make.height.offset(300);
        }];
        
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_contentView);
            make.top.equalTo(_contentView.mas_top).offset(22);
            make.height.offset(30);
        }];
        
        [_subContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLab.mas_bottom).offset(10);
            make.left.right.equalTo(_contentView).inset(0);
            make.bottom.equalTo(_bottomLab.mas_top).offset(-10);
        }];
        
        [_bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_subContent.mas_bottom).offset(10);
            make.left.right.equalTo(_contentView).inset(8);
            make.bottom.equalTo(_contentView.mas_bottom).offset(-20);
        }];
        
        [[BroadcastThread share] addDelegate:self];
        
        _disTaps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapgesAction)];
    }
    return self;
}

-(void)initData{
    
}



-(void)setItemArray:(NSArray *)itemArray{
    _itemArray = itemArray;
    _finishIndex = 0;
    [_contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-10);
        make.left.right.equalTo(self).inset(12);
        make.height.offset(136+56*itemArray.count);
    }];
    _titleLab.text = kJL_TXT("updateing");
    
    for (UIView *view in self.cellArray) {
        [view removeFromSuperview];
    }
    [self.cellArray removeAllObjects];
    
    for (BroadcastOtaInfo *item in self.itemArray) {
        UpdateStatusCell *cell = [UpdateStatusCell new];
        cell.mainCbp = item.cbp;
        cell.deviceName = item.cbp.name;
        cell.updateName = [item.updatePath lastPathComponent];
        cell.delegate = self;
        [_subContent addSubview:cell];
        [self.cellArray addObject:cell];
    }
    if(self.cellArray.count>1){
        [self.cellArray mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
        [_cellArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_subContent).inset(0);
            make.height.offset(56);
        }];
    }else if(_cellArray.count>0){
        UIView *view = [self.cellArray firstObject];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_subContent).inset(8);
        }];
    }
    
}




//MARK: - cell delegates
- (void)updateStatusDidFinishWithCbp:(CBPeripheral *)cbp{
    _finishIndex+=1;
    if(_finishIndex == self.itemArray.count){
        [_bgView addGestureRecognizer:_disTaps];
        _titleLab.text = kJL_TXT("update_finish_end");
    }
    
}

-(void)updateStatusDidShowErrorMsg:(NSString *)msg{
    [DFUITools showText:msg onView:self delay:3];
}


-(void)tapgesAction{
    self.hidden = YES;
    [_bgView removeGestureRecognizer:_disTaps];
}


@end
