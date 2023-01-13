//
//  UfwSelectView.m
//  JL_OTA
//
//  Created by EzioChan on 2022/11/29.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "UfwSelectView.h"
#import "PopoverViewCell.h"
#import "UfwConfig.h"

@interface UfwSelectView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *contentView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UITableView *subTable;

@property(nonatomic,strong)UIImageView *noFileView;
@property(nonatomic,strong)UILabel *noFileLab;

//Data
@property(nonatomic,strong)NSMutableArray <NSString*>*itemArray;
@property(nonatomic,strong)UfwConfig *configMgr;
@end

@implementation UfwSelectView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _configMgr = [[UfwConfig alloc] init];
        self.itemArray = [NSMutableArray new];
        self.backgroundColor = [UIColor clearColor];
        self.bgView = [UIView new];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.4;
        [self addSubview:_bgView];
        UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toDisMiss)];
        [_bgView addGestureRecognizer:tapges];
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 16;
        _contentView.layer.masksToBounds = true;
        [self addSubview:_contentView];
        
        _titleLab = [UILabel new];
        _titleLab.font = FontMedium(18);
        _titleLab.textColor = [UIColor colorFromHexString:@"#333333"];
        _titleLab.text = kJL_TXT("select_file");
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [_contentView addSubview:_titleLab];
        
        _subTable = [UITableView new];
        _subTable.delegate = self;
        _subTable.dataSource = self;
        _subTable.rowHeight = 48;
        _subTable.tableFooterView = [UIView new];
        [_subTable registerClass:[PopoverViewCell self] forCellReuseIdentifier:@"PopoverViewCell"];
        _subTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _subTable.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:_subTable];
        
        self.noFileView = [UIImageView new];
        self.noFileView.image = [UIImage imageNamed:@"icon_fail_nol"];
        [_contentView addSubview:self.noFileView];
        
        self.noFileLab = [UILabel new];
        self.noFileLab.text = kJL_TXT("no_ufw_file");
        self.noFileLab.textAlignment = NSTextAlignmentCenter;
        self.noFileLab.textColor = [UIColor colorFromHexString:@"#242424"];
        self.noFileLab.font = FontMedium(14);
        [_contentView addSubview:self.noFileLab];
        
        
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.right.equalTo(self).inset(16);
            make.height.offset(246);
        }];
        
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_contentView);
            make.top.equalTo(_contentView.mas_top).offset(22);
            make.height.offset(30);
        }];
        
        [_subTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLab.mas_bottom).offset(11);
            make.left.right.equalTo(_contentView).inset(8);
            make.bottom.equalTo(_contentView.mas_bottom);
        }];
        
        self.noFileLab.hidden = YES;
        self.noFileView.hidden = YES;
        
        [_noFileView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentView).inset(32);
            make.height.width.offset(36);
            make.centerX.equalTo(_contentView);
        }];
        [_noFileLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_noFileView.mas_bottom).offset(16);
            make.left.right.equalTo(_contentView).inset(6);
            make.height.offset(22);
        }];
        

    }
    return self;
}


-(void)toDisMiss{
    self.hidden = true;
}

-(void)setEntity:(JLBleEntity *)entity{
    _entity  = entity;
    [self.itemArray setArray:[_configMgr checkWithPid:entity.pid Uid:entity.uid]];
    [_subTable reloadData];
    if(self.itemArray.count == 0){
        self.noFileLab.hidden = NO;
        self.noFileView.hidden = NO;
        _titleLab.hidden = YES;
        _subTable.hidden = YES;
        [_contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.width.offset(146);
            make.height.offset(120);
            make.centerX.equalTo(self);
        }];
    }else{
        self.noFileLab.hidden = YES;
        self.noFileView.hidden = YES;
        _titleLab.hidden = NO;
        _subTable.hidden = NO;
        [_contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.right.equalTo(self).inset(16);
            make.height.offset(246);
        }];
    }
}

-(void)setUpdatePath:(NSString *)updatePath{
    _updatePath = updatePath;
    [_subTable reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PopoverViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PopoverViewCell" forIndexPath:indexPath];
    if(cell == nil){
        cell = [[PopoverViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PopoverViewCell"];
    }
    cell.mainLabel.font = FontMedium(16);
    cell.mainLabel.textColor = [UIColor colorFromHexString:@"#242424"];
    cell.mainLabel.text = [self.itemArray[indexPath.row] lastPathComponent];
    cell.rightImgv.image = [UIImage imageNamed:@"icon_choose"];
    if([[self.itemArray[indexPath.row] lastPathComponent] isEqualToString:[_updatePath lastPathComponent]]){
        cell.rightImgv.hidden = false;
    }else{
        cell.rightImgv.hidden = true;
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    self.updatePath = self.itemArray[indexPath.row];
    if([_delegate respondsToSelector:@selector(ufwSelectViewDelegate:)]){
        [_delegate ufwSelectViewDelegate:self];
    }
    [self toDisMiss];
}




@end
