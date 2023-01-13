//
//  JLShareDetailViewController.m
//  JL_OTA
//
//  Created by EzioChan on 2022/10/17.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "JLShareDetailViewController.h"

@interface JLShareDetailViewController ()

@property(nonatomic,strong)UITextView *textView;

@end

@implementation JLShareDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

-(void)initUI{
    self.title = [self.path lastPathComponent];
    UIImage *img = [[UIImage imageNamed:@"icon_return_nol"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStyleDone target:self action:@selector(backBtnAction)];
    leftBtn.tintColor = [UIColor grayColor];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    UIImage *imgRight = [[UIImage imageNamed:@"icon_share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:imgRight style:UIBarButtonItemStyleDone target:self action:@selector(shareLog)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    _textView = [UITextView new];
    NSData *data = [NSData dataWithContentsOfFile:self.path];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    _textView.text = str;
    _textView.font = FontMedium(14);
    _textView.backgroundColor = [UIColor clearColor];
    _textView.textColor = [UIColor colorFromHexString:@"#606060"];
    _textView.editable = NO;
    [self.view addSubview:_textView];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(16);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-16);
        } else {
            make.top.equalTo(self.view.mas_top).offset(16);
            make.bottom.equalTo(self.view.mas_bottom).offset(-16);
        }
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];
}

-(void)backBtnAction{
    [self.navigationController popViewControllerAnimated:true];
}

-(void)shareLog{
    
    NSArray *arrayItems = @[self.textView.text];
    UIActivityViewController *activeVc = [[UIActivityViewController alloc] initWithActivityItems:arrayItems applicationActivities:nil];
    [self presentViewController:activeVc animated:true completion:nil];
    activeVc.completionWithItemsHandler = ^(UIActivityType _Nullable activityType,BOOL completed,NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        
    };
}


@end
