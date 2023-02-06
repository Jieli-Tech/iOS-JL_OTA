//
//  JLShareFileViewController.m
//  JL_OTA
//
//  Created by EzioChan on 2022/10/14.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "JLShareFileViewController.h"

@interface JLShareFileViewController ()

@property(nonatomic,strong)UILabel *firstLab;
@property(nonatomic,strong)UILabel *detailLab;
@property(nonatomic,strong)UIImageView *showImgv;

@end

@implementation JLShareFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

-(void)initUI{
    self.title = kJL_TXT("file_share");
    UIImage *img = [[UIImage imageNamed:@"icon_return_nol"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStyleDone target:self action:@selector(backBtnAction)];
    leftBtn.tintColor = [UIColor grayColor];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    
    _firstLab = [UILabel new];
    _firstLab.font = FontMedium(20);
    _firstLab.text = kJL_TXT("share_ufw_file");
    _firstLab.textAlignment = NSTextAlignmentCenter;
    _firstLab.textColor = [UIColor colorFromHexString:@"#242424"];
    [self.view addSubview:_firstLab];
    
    [_firstLab mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(24);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(self.view.mas_top).offset(24);
        }
        make.left.equalTo(self.view.mas_left).offset(24);
        make.right.equalTo(self.view.mas_right).offset(-24);
        make.height.offset(35);
    }];
    
    
    _detailLab = [UILabel new];
    _detailLab.font = [UIFont systemFontOfSize:16];
    _detailLab.text = kJL_TXT("share_ufw_file_tips");
    _detailLab.textAlignment = NSTextAlignmentCenter;
    _detailLab.numberOfLines = 0;
    _detailLab.textColor = [UIColor colorFromHexString:@"#919191"];
    [self.view addSubview:_detailLab];
    [_detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firstLab.mas_bottom).offset(8);
        make.left.equalTo(self.view.mas_left).offset(24);
        make.right.equalTo(self.view.mas_right).offset(-24);
        make.height.offset(50);
    }];
    
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"file_share" withExtension:@".gif"];
    CGImageSourceRef gif = CGImageSourceCreateWithURL((CFURLRef)fileUrl, NULL);
    size_t frameCount = CGImageSourceGetCount(gif);
    NSMutableArray *frames = [NSMutableArray new];
    for (size_t i = 0; i<frameCount; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gif, i, NULL);
        UIImage *imageName = [UIImage imageWithCGImage:imageRef];
        [frames addObject:imageName];
        CGImageRelease(imageRef);
    }
    
    _showImgv = [UIImageView new];
    _showImgv.animationImages = frames;
    _showImgv.animationDuration = 5;
    _showImgv.contentMode = UIViewContentModeScaleAspectFit;
    [_showImgv startAnimating];
    [self.view  addSubview:_showImgv];
    
    [_showImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_detailLab.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(40);
        make.right.equalTo(self.view.mas_right).offset(-40);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-60);
        } else {
            // Fallback on earlier versions
            make.bottom.equalTo(self.view.mas_bottom).offset(-40);
        }
    }];
    
    
}


-(void)backBtnAction{
    [self.navigationController popViewControllerAnimated:true];
}






@end
