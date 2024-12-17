//
//  PopoverView.m
//  JL_OTA
//
//  Created by EzioChan on 2022/11/4.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "PopoverView.h"
#import "Masonry.h"
#import "PopoverViewCell.h"

@interface PopoverView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIImageView *bgView;


@end

static NSString *reusreIdentifier = @"UITableViewCellStyleDefault";

@implementation PopoverView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.itemList = @[kJL_TXT("app_share"),kJL_TXT("computer_share"),kJL_TXT("scan_to_download")];
        self.imageList = @[@"icon_phone",@"icon_computer",@"icon_scan"];
        self.type = PopoverTypeAdd;
        _popBgImg = [UIImage imageNamed:@"popout_bg"];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self initUI];
}


- (void)setPopBgImg:(UIImage *)popBgImg{
    _popBgImg = popBgImg;
    _bgView.image = _popBgImg;
}


-(void)initUI{
    _bgView = [UIImageView new];
    _bgView.image = self.popBgImg;
    [self addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _listTable = [UITableView new];
    _listTable.backgroundColor = [UIColor clearColor];
    _listTable.delegate = self;
    _listTable.dataSource = self;
    _listTable.tableFooterView = [UIView new];
    _listTable.layer.cornerRadius = 6;
    _listTable.layer.masksToBounds = YES;
    _listTable.rowHeight = 45;
    _listTable.scrollEnabled = false;
    _listTable.separatorInset=UIEdgeInsetsMake(0,10, 0, 10);
    _listTable.separatorColor= [UIColor colorWithRed:1 green:1 blue:1 alpha:0.22];
    if (@available(iOS 15.0, *)) {
        _listTable.sectionHeaderTopPadding = 0.0;
    }
    if (self.type == PopoverTypeAdd){
        [_listTable registerClass:[UITableViewCell self] forCellReuseIdentifier:reusreIdentifier];
    }else{
        [_listTable registerClass:[PopoverViewCell self] forCellReuseIdentifier:@"broadcastCell"];
    }
    [self addSubview:_listTable];
    [_listTable mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(6);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(self.mas_top).offset(6);
        }
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.type == PopoverTypeAdd){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusreIdentifier forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:self.imageList[indexPath.row]];
        cell.textLabel.text = self.itemList[indexPath.row];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.font = FontMedium(14);
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }else{
        PopoverViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"broadcastCell" forIndexPath:indexPath];
        if(cell == nil){
            cell = [[PopoverViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"broadcastCell"];
        }
        cell.mainLabel.text = self.itemList[indexPath.row];
        if(indexPath.row == self.selectIndex){
            cell.rightImgv.image = [UIImage imageNamed:@"icon_choose_whtie"];
            cell.rightImgv.hidden = false;
        }else{
            cell.rightImgv.hidden = true;
        }
            
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    self.selectIndex = indexPath.row;
    
}

@end
