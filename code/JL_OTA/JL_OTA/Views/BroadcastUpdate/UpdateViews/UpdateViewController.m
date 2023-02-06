//
//  UpdateViewController.m
//  JL_OTA
//
//  Created by EzioChan on 2022/11/28.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "UpdateViewController.h"
#import "UpdateTableViewCell.h"
#import "BroadcastBleManager.h"
#import "UfwSelectView.h"
#import "UpdateStatusView.h"



@interface UpdateViewController ()<UITableViewDelegate,UITableViewDataSource,updateTableCellDelegate,UfwSelectPtl>

@property(nonatomic,strong)UITableView *subTable;
@property(nonatomic,strong)UIButton *updateBtn;
@property(nonatomic,strong)UfwSelectView *ufwView;
@property(nonatomic,strong)UpdateStatusView *statusView;
@property(nonatomic,strong)NSMutableArray <UpdateObjc*>*itemArray;
@property(nonatomic,strong)UIImageView *nullImgv;
@property(nonatomic,strong)UILabel *nullLab;

@end

@implementation UpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kJL_TXT("update");
    [self initData];
    [self initUI];
}

-(void)initUI{
    
    
    self.nullImgv = [UIImageView new];
    self.nullImgv.image = [UIImage imageNamed:@"update_img"];
    [self.view addSubview:self.nullImgv];
    [self.nullImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(136);
        make.centerX.equalTo(self.view);
        make.width.offset(180);
        make.height.offset(164);
    }];
    self.nullLab = [UILabel new];
    self.nullLab.text = [NSString stringWithFormat:@"%@%@",kJL_TXT("device"),kJL_TXT("not_connect")];
    self.nullLab.textAlignment = NSTextAlignmentCenter;
    self.nullLab.font = FontMedium(14);
    self.nullLab.textColor = [UIColor colorFromHexString:@"#AEAEAE"];
    [self.view addSubview:self.nullLab];
    [self.nullLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nullImgv.mas_bottom).offset(14);
        make.left.right.equalTo(self.view).inset(40);
        make.height.offset(35);
    }];

    
    _subTable = [UITableView new];
    _subTable.dataSource = self;
    _subTable.delegate = self;
    _subTable.rowHeight = 98;
    _subTable.backgroundColor = [UIColor clearColor];
    _subTable.tableFooterView = [UIView new];
    _subTable.allowsSelection = false;
    _subTable.scrollEnabled = true;
    _subTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_subTable registerClass:[UpdateTableViewCell self] forCellReuseIdentifier:@"UpdateTableViewCell"];
    [self.view addSubview:_subTable];
    
    _updateBtn = [UIButton new];
    [_updateBtn setBackgroundColor:[UIColor colorFromHexString:@"#398BFF"]];
    [_updateBtn setTitle:kJL_TXT("update") forState:UIControlStateNormal];
    [_updateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_updateBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_updateBtn addTarget:self action:@selector(updateBtnAction) forControlEvents:UIControlEventTouchUpInside];
    _updateBtn.layer.cornerRadius = 24;
    _updateBtn.layer.masksToBounds = true;
    [self.view  addSubview:_updateBtn];
    
    
    
    [_updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_subTable.mas_bottom).offset(35);
        make.left.right.equalTo(self.view).inset(16);
        make.height.offset(48);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).inset(40);
    }];
    
    [_subTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(5);
        make.left.right.equalTo(self.view).inset(0);
        make.bottom.equalTo(_updateBtn.mas_top).offset(-35);
    }];
    
    UIWindow *window = [[UIApplication sharedApplication] windows].firstObject;
    _ufwView = [[UfwSelectView alloc] init];
    _ufwView.delegate = self;
    [window addSubview:_ufwView];
    [_ufwView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    _ufwView.hidden = true;
    
    _statusView = [[UpdateStatusView alloc] init];
    [window addSubview:_statusView];
    [_statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    _statusView.hidden = true;
    [self changeUpdateBtnStatus];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.itemArray.count>0){
        self.nullLab.hidden = YES;
        self.nullImgv.hidden = YES;
        _updateBtn.hidden = NO;
    }else{
        _updateBtn.hidden = YES;
        self.nullLab.hidden = NO;
        self.nullImgv.hidden = NO;
    }
}

-(void)updateBtnAction{
  
    NSArray *array = [self changeUpdateBtnStatus];
    
    self.statusView.itemArray = array;
    self.statusView.hidden = false;
    [[BroadcastThread share] startOta:array];
    
}

-(NSArray *)changeUpdateBtnStatus{
    NSMutableArray *array = [NSMutableArray new];
    for (UpdateObjc *objc in self.itemArray) {
        if(objc.selected){
            BroadcastOtaInfo *info = [[BroadcastOtaInfo alloc] init];
            info.cbp = objc.info.entity.mPeripheral;
            info.updatePath = objc.updatePath;
            [array addObject:info];
        }
    }
    if(array.count>0){
        [_updateBtn setBackgroundColor:[UIColor colorFromHexString:@"#398BFF"]];
        [_updateBtn setUserInteractionEnabled:true];
      
    }else{
        [_updateBtn setBackgroundColor:[UIColor colorFromHexString:@"#D7DADD"]];
        [_updateBtn setUserInteractionEnabled:NO];
    }
    return array;
}

-(void)initData{
   
    self.itemArray = [NSMutableArray new];
    for (JLDeviceInfo *info in [DeviceManager share].devices) {
        UpdateObjc * objc = [[UpdateObjc alloc] init];
        objc.info = info;
        objc.selected = false;
        if([info.manager getDeviceModel].otaStatus == JL_OtaStatusForce){
            objc.needUpdate = true;
        }else{
            objc.needUpdate = false;
        }
        objc.updatePath = @"";
        [self.itemArray addObject:objc];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allNotiAction:) name:nil object:nil];
}

-(void)allNotiAction:(NSNotification *)note{
    NSString *name = note.name;
    if([name isEqualToString:kBDM_BLE_PAIRED]){
        CBPeripheral *cbp = note.object;
        BOOL shouldAdd = true;
        for (UpdateObjc * objc in self.itemArray) {
            if([objc.info.entity.mPeripheral isEqual:cbp]){
                shouldAdd = false;
                break;
            }
        }
        if(shouldAdd){
            JLDeviceInfo *info = [[DeviceManager share] checkoutWith:cbp];
            UpdateObjc * objc = [[UpdateObjc alloc] init];
            objc.info = info;
            objc.selected = false;
            if([info.manager getDeviceModel].otaStatus == JL_OtaStatusForce){
                objc.needUpdate = true;
            }else{
                objc.needUpdate = false;
            }
            objc.updatePath = @"";
            [self.itemArray addObject:objc];
        }
        [self changeUpdateBtnStatus];
        [self.subTable reloadData];
        [self.subTable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(98*self.itemArray.count);
        }];
    }
    
    if([name isEqualToString:kBDM_BLE_DISCONNECTED]){
        CBPeripheral *cbp = note.object;
        for (UpdateObjc * objc in self.itemArray) {
            if([objc.info.entity.mPeripheral isEqual:cbp]){
                [self.itemArray removeObject:objc];
                break;
            }
        }
        [self.subTable reloadData];
        [self.subTable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(98*self.itemArray.count);
        }];
        [self changeUpdateBtnStatus];
    }
    
}




//MARK: - Tableview Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _itemArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UpdateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UpdateTableViewCell" forIndexPath:indexPath];
    if(cell == nil){
        cell = [[UpdateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UpdateTableViewCell"];
    }
    cell.delegate = self;
    UpdateObjc *item = self.itemArray[indexPath.row];
    cell.index = indexPath.row;
    cell.mainLab.text = [NSString stringWithFormat:@"%@：%@",kJL_TXT("device"),item.info.entity.mName];
    if(item.selected){
        [cell.chooseBtn setImage:[UIImage imageNamed:@"icon_choose_02_sel"] forState:UIControlStateNormal];
    }else{
        [cell.chooseBtn setImage:[UIImage imageNamed:@"icon_choose_02_nol"] forState:UIControlStateNormal];
    }
    if(item.needUpdate){
        cell.statusImgv.image = [UIImage imageNamed:@"icon_tips"];
        cell.detailLab.text = kJL_TXT("device_need_update");
    }else{
        cell.statusImgv.image = [UIImage imageNamed:@"icon_file_02"];
        if ([item.updatePath isEqualToString:@""]){
            cell.detailLab.text = kJL_TXT("need_select_file");
        }else{
            cell.detailLab.text = [item.updatePath lastPathComponent];
        }
    }
    return cell;
}


//MARK: - Cell delegate
-(void)updateDidStartSelectUfw:(NSInteger)index{
    
    UpdateObjc *item = self.itemArray[index];
    [self.ufwView setEntity:item.info.entity];
    [self.ufwView setUpdatePath:item.updatePath];
    self.ufwView.hidden = false;
    
}

-(void)updateDidSelectWithIndex:(NSInteger)index{
    UpdateObjc *item = self.itemArray[index];
    if(item.selected){
        item.selected = !item.selected;
    }else{
        if([item.updatePath isEqualToString:@""]){
            [DFUITools showText:kJL_TXT("need_select_file") onView:self.view delay:2];
        }else{
            item.selected = !item.selected;
        }
    }
    [self changeUpdateBtnStatus];
    [_subTable reloadData];
}

//MARK: - select delegate
-(void)ufwSelectViewDelegate:(UfwSelectView *)ufwSwr{
    for (UpdateObjc *item in self.itemArray) {
        if([item.info.entity.mPeripheral.identifier.UUIDString isEqualToString:ufwSwr.entity.mPeripheral.identifier.UUIDString]){
            item.updatePath = ufwSwr.updatePath;
            break;
        }
    }
    [_subTable reloadData];
}





@end
