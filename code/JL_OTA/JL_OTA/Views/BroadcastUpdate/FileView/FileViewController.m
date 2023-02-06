//
//  FileViewController.m
//  JL_OTA
//
//  Created by EzioChan on 2022/11/28.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "FileViewController.h"
#import "NoFileView.h"
#import "UfwFileCell.h"
#import "PopoverView.h"
#import "JLShareFileViewController.h"
#import "TipsComputerView.h"

@interface FileViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NoFileView *noFileView;
@property(nonatomic,strong)UITableView *subTable;
@property (strong, nonatomic) PopoverView *popView;
@property (strong, nonatomic) UIView *popViewBg;
@property(nonatomic,strong)TipsComputerView *transportComputerView;

//MARK: - data
@property(nonatomic,strong)NSArray *itemArray;

@end

@implementation FileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePreFile:) name:@"REFRESH_FILE" object:nil];
    [self initUI];
}


-(void)initUI{
    
    self.title = kJL_TXT("file");
    _noFileView = [NoFileView new];
    [self.view addSubview:_noFileView];
    [_noFileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view).offset(-50);
        make.left.right.equalTo(self.view).inset(10);
        make.height.offset(220);
    }];
    _noFileView.hidden = true;
    
    _subTable = [UITableView new];
    _subTable.delegate = self;
    _subTable.dataSource = self;
    _subTable.rowHeight = 65;
    _subTable.tableFooterView = [UIView new];
    _subTable.backgroundColor = [UIColor clearColor];
    _subTable.separatorColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
    [_subTable registerNib:[UINib nibWithNibName:NSStringFromClass(UfwFileCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(UfwFileCell.class)];
    [self.view addSubview:_subTable];
    [_subTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(8);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    [self addRightBtn];
    [self addToWindows];
}
//MARK: - RightBtnActions
-(void)addRightBtn{
    UIImage *image = [[UIImage imageNamed:@"icon_add"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction)];
    self.navigationItem.rightBarButtonItem = right;
}


-(void)rightBtnAction{
    self.popViewBg.hidden = false;
    self.popView.hidden = false;
}

-(void)addToWindows{
    UIWindow *window = [[UIApplication sharedApplication] windows].firstObject;
    _transportComputerView = [TipsComputerView new];
    [window addSubview:_transportComputerView];
    [_transportComputerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    
    self.popViewBg = [UIView new];
    self.popViewBg.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDismissPop)];
    [self.popViewBg addGestureRecognizer:tap];
    [window addSubview:self.popViewBg];
    
    [self.popViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    
    self.popView = [[PopoverView alloc] init];
    [self.popView addObserver:self forKeyPath:@"selectIndex" options:NSKeyValueObservingOptionNew context:nil];
    [window addSubview:self.popView];
    self.popView.popBgImg = [UIImage imageNamed:@"popout_bg_02"];
    [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(window.mas_safeAreaLayoutGuideTop).offset(38);
        make.right.equalTo(window.mas_right).offset(-8);
        make.width.offset(125);
        make.height.offset(98);
    }];
    
    
    _transportComputerView.hidden = true;
    [self tapToDismissPop];
}

-(void)tapToDismissPop{
    self.popViewBg.hidden = true;
    self.popView.hidden = true;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"selectIndex"]){
        int v =  [change[NSKeyValueChangeNewKey] intValue];
        if(v == 0){
            JLShareFileViewController *vc = [[JLShareFileViewController alloc] init];
            [vc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:vc animated:true];
        }
        if(v == 1){
            self.transportComputerView.hidden = NO;
        }
        [self tapToDismissPop];
    }
}


//MARK: - tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UfwFileCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UfwFileCell.class)];
    cell.mainLab.text = _itemArray[indexPath.row];
    cell.detailLab.text = @"../Document/upgrade";
    cell.selectedImgv.hidden = true;
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kJL_TXT("delete");
}

- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //在这里实现删除操作
    NSString *path = [DFFile listPath:NSDocumentDirectory MiddlePath:@"upgrade" File:self.itemArray[indexPath.row]];
    [DFFile removePath:path];
    [self reflashFileArray];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (void)reflashFileArray {
    // 获取沙盒升级文件
    NSString *docPath = [DFFile listPath:NSDocumentDirectory MiddlePath:@"upgrade" File:nil];
    _itemArray = [DFFile subPaths:docPath];
    if(_itemArray.count>0){
        self.noFileView.hidden = YES;
    }else{
        self.noFileView.hidden = NO;
    }
    [self.subTable reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self reflashFileArray];

}


-(void)handlePreFile:(NSNotification *)note{
    
    [self reflashFileArray];
    
}


@end
