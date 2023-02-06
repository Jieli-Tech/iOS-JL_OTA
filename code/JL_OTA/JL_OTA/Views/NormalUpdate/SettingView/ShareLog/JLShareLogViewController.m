//
//  JLShareLogViewController.m
//  JL_OTA
//
//  Created by EzioChan on 2022/10/17.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "JLShareLogViewController.h"
#import "TipsDeleteView.h"
#import "JLShareDetailViewController.h"

@interface JLShareLogViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *contentTable;
@property(nonatomic,strong)NSMutableArray *itemArray;
@property(nonatomic,strong)TipsDeleteView *deleteView;


@end

static NSString *logIdentify = @"log_cell_Identify";

@implementation JLShareLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    
}

-(void)initData{
    self.itemArray = [NSMutableArray new];
    NSString *basicPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [fileManager contentsOfDirectoryAtPath:basicPath error:nil];
    for (NSString *path in files) {
        if([path hasSuffix:@".txt"]){
            NSString *newPath = [NSString stringWithFormat:@"%@/%@",basicPath,path];
            [self.itemArray addObject:newPath];
        }
    }
}

-(void)initUI{
    self.title = kJL_TXT("log_file");
    UIImage *img = [[UIImage imageNamed:@"icon_return_nol"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStyleDone target:self action:@selector(backBtnAction)];
    leftBtn.tintColor = [UIColor grayColor];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    UIImage *imgRight = [[UIImage imageNamed:@"icon_delete"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:imgRight style:UIBarButtonItemStyleDone target:self action:@selector(removeAllLog)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    
    _contentTable = [UITableView new];
    _contentTable.tableFooterView = [UIView new];
    _contentTable.delegate = self;
    _contentTable.dataSource = self;
    [_contentTable registerClass:[UITableViewCell self] forCellReuseIdentifier:logIdentify];
    _contentTable.rowHeight = 50;
    _contentTable.backgroundColor = [UIColor clearColor];
    _contentTable.separatorColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
    [self.view addSubview:_contentTable];
    
    [_contentTable mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-10);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(self.view.mas_top).offset(10);
            make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        }
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
    }];
    
    
    UIWindow *windows = [[UIApplication sharedApplication] keyWindow];
    _deleteView = [TipsDeleteView new];
    [windows addSubview:_deleteView];
    [_deleteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(windows.mas_top).offset(0);
        make.bottom.equalTo(windows.mas_bottom).offset(0);
        make.left.equalTo(windows.mas_left).offset(0);
        make.right.equalTo(windows.mas_right).offset(0);
    }];
    _deleteView.hidden = YES;
    
    [self.deleteView addObserver:self forKeyPath:@"hidenStatus" options:NSKeyValueObservingOptionNew context:nil];
}


-(void)backBtnAction{
    [self.navigationController popViewControllerAnimated:true];
}

-(void)removeAllLog{
    _deleteView.hidden = NO;
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"hidenStatus"]){
        [self initData];
        [self.contentTable reloadData];
    }
}

//MARK: - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:logIdentify forIndexPath:indexPath];
    cell.textLabel.text = [self.itemArray[indexPath.row] lastPathComponent];
    cell.textLabel.textColor = [UIColor colorFromHexString:@"242424"];
    cell.backgroundColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    JLShareDetailViewController *vc = [[JLShareDetailViewController alloc] init];
    vc.path = self.itemArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
