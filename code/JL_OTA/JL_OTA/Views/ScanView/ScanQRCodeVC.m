//
//  ScanQRCodeVC.h
//  JL_OTA
//
//  Created by EzioChan on 2023/4/24.
//  Copyright © 2023 Zhuhia Jieli Technology. All rights reserved.
//

#import "ScanQRCodeVC.h"
#import "SGQRCode.h"

@interface ScanQRCodeVC ()<SGScanCodeDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    SGScanCode *scanCode;
    UIButton *leftBtn;
    UIButton *rightBtn;
    UILabel *titleLab;
    BOOL isDownload;
}
@property (nonatomic, strong) SGScanView *scanView;
@property (nonatomic, strong) UILabel *promptLabel;

@end

@implementation ScanQRCodeVC

- (void)dealloc {
    kJLLog(JLLOG_DEBUG, @"dealloc");
    [self stop];
}

- (void)start {
    [scanCode startRunning];
    [self.scanView startScanning];
}

- (void)stop {
    [scanCode stopRunning];
    [self.scanView stopScanning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor blackColor];
    
    isDownload = false;
    
    [[SGQRCodeLog sharedQRCodeLog] setLog:YES];
    
    [self permissionGet];
    
    [self configureUI];
    
    [self configureQRCode];
    
    [self configureNav];
    
    
}

-(void)permissionGet{
    [SGPermission permissionWithType:SGPermissionTypeCamera completion:^(SGPermission * _Nonnull permission, SGPermissionStatus status) {
        if (status == SGPermissionStatusNotDetermined) {
            [permission request:^(BOOL granted) {
                if (granted) {
                    kJLLog(JLLOG_DEBUG, @"第一次授权成功");
                } else {
                    kJLLog(JLLOG_DEBUG, @"第一次授权失败");
                }
            }];
        } else if (status == SGPermissionStatusAuthorized) {
            kJLLog(JLLOG_DEBUG, @"SGPermissionStatusAuthorized");
        
        } else if (status == SGPermissionStatusDenied) {
            kJLLog(JLLOG_DEBUG, @"SGPermissionStatusDenied");
            [self failed];
        } else if (status == SGPermissionStatusRestricted) {
            kJLLog(JLLOG_DEBUG, @"SGPermissionStatusRestricted");
        }

    }];
}
- (void)failed {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:kJL_TXT("Tips") message:kJL_TXT("allow_access") preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:kJL_TXT("confirm") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertC addAction:alertA];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertC animated:YES completion:nil];
    });
}

- (void)configureUI {
    [self.view addSubview:self.scanView];
    [self.view addSubview:self.promptLabel];
}

- (void)configureQRCode {
    scanCode = [SGScanCode scanCode];
    scanCode.preview = self.view;
    scanCode.delegate = self;
    CGFloat w = 1.0;
    CGFloat x = 0.5 * (1 - w);
    CGFloat h = 1.0;
    CGFloat y = 0.5 * (1 - h);
    /// 扫描范围。对应辅助扫描框的frame（borderFrame）设置
    scanCode.rectOfInterest = CGRectMake(y, x, h, w);
    [scanCode startRunning];
}

- (void)scanCode:(SGScanCode *)scanCode result:(NSString *)result {
    [self stop];
    
    [scanCode playSoundEffect:@"SGQRCode.bundle/scan_end_sound.caf"];

    if (!isDownload){
        [[NSNotificationCenter defaultCenter] postNotificationName:QR_SCAN_RESULT object:result];
        isDownload = true;
    }
    [self.navigationController popViewControllerAnimated:true];
}

- (void)configureNav {
    
    leftBtn = [UIButton new];
    [self.view addSubview:leftBtn];
    [leftBtn setImage:[UIImage imageNamed:@"icon_return_white"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).inset(10);
        make.left.equalTo(self.view).inset(8);
        make.height.with.offset(40);
    }];
    
    rightBtn = [UIButton new];
    [self.view addSubview:rightBtn];
    [rightBtn setTitle:kJL_TXT("photos") forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = FontMedium(15);
    [rightBtn addTarget:self action:@selector(rightBarButtonItenAction) forControlEvents:UIControlEventTouchUpInside];
    
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).inset(10);
        make.right.equalTo(self.view).inset(8);
        make.height.with.offset(40);
    }];
    
    titleLab = [UILabel new];
    [self.view addSubview:titleLab];
    titleLab.font = FontMedium(18);
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = kJL_TXT("scan_qrcode");
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).inset(10);
        make.centerX.equalTo(self.view);
        make.height.offset(40);
    }];
}

-(void)backBtnAction{
    [self.navigationController popViewControllerAnimated:true];
}


- (void)rightBarButtonItenAction {
    [SGPermission permissionWithType:SGPermissionTypePhoto completion:^(SGPermission * _Nonnull permission, SGPermissionStatus status) {
        if (status == SGPermissionStatusNotDetermined) {
            [permission request:^(BOOL granted) {
                if (granted) {
                    kJLLog(JLLOG_DEBUG, @"第一次授权成功");
                    [self _enterImagePickerController];
                } else {
                    kJLLog(JLLOG_DEBUG, @"第一次授权失败");
                }
            }];
        } else if (status == SGPermissionStatusAuthorized) {
            kJLLog(JLLOG_DEBUG, @"SGPermissionStatusAuthorized");
            [self _enterImagePickerController];
        } else if (status == SGPermissionStatusDenied) {
            kJLLog(JLLOG_DEBUG, @"SGPermissionStatusDenied");
            NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
            NSString *app_Name = [infoDict objectForKey:@"CFBundleDisplayName"];
            if (app_Name == nil) {
                app_Name = [infoDict objectForKey:@"CFBundleName"];
            }
            
            NSString *messageString = [NSString stringWithFormat:kJL_TXT("allow_access"), app_Name];
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:kJL_TXT("Tips") message:messageString preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:kJL_TXT("confirm") style:(UIAlertActionStyleDefault) handler:nil];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
        } else if (status == SGPermissionStatusRestricted) {
            kJLLog(JLLOG_DEBUG, @"SGPermissionStatusRestricted");
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:kJL_TXT("Tips") message:kJL_TXT("can_not_access") preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:kJL_TXT("confirm") style:(UIAlertActionStyleDefault) handler:nil];
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
        }
    }];
}

- (void)_enterImagePickerController {
    [self stop];

    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - - UIImagePickerControllerDelegate 的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self start];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [scanCode readQRCode:image completion:^(NSString *result) {
        if (result == nil) {
            [self dismissViewControllerAnimated:YES completion:nil];
            [self start];
            kJLLog(JLLOG_DEBUG, @"未识别出二维码");
        } else {
            [self dismissViewControllerAnimated:YES completion:^{
                if (!self->isDownload){
                    [[NSNotificationCenter defaultCenter] postNotificationName:QR_SCAN_RESULT object:result];
                    self->isDownload = true;
                }
                [self.navigationController popViewControllerAnimated:true];
            }];
        }
    }];
}

- (SGScanView *)scanView {
    if (!_scanView) {
        SGScanViewConfigure *configure = [[SGScanViewConfigure alloc] init];
        configure.cornerLocation = SGCornerLoactionInside;
        configure.cornerWidth = 1;
        configure.cornerLength = 25;
        configure.isShowBorder = YES;
        configure.scanlineStep = 2;
        configure.scanline = @"scane_line";
        configure.autoreverses = YES;
        configure.cornerColor = [UIColor colorFromHexString:@"#398BFF"];

        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat w = self.view.frame.size.width;
        CGFloat h = self.view.frame.size.height;
        _scanView = [[SGScanView alloc] initWithFrame:CGRectMake(x, y, w, h) configure:configure];
        CGFloat w1 = 0.7 * _scanView.frame.size.width;
        CGFloat h1 = w1;
        CGFloat x1 = 0.5 * (_scanView.frame.size.width - w1);
        CGFloat y1 = 0.3 * (_scanView.frame.size.height - h1);
        _scanView.borderFrame = CGRectMake(x1, y1, w1, h1);
        _scanView.scanFrame =  CGRectMake(x1, y1, w1, h1);
        [_scanView startScanning];
    }
    return _scanView;
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.60 * self.view.frame.size.height;
        CGFloat promptLabelW = self.view.frame.size.width;
        CGFloat promptLabelH = 25;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = FontMedium(14);
        _promptLabel.textColor = [UIColor whiteColor];
        _promptLabel.text = kJL_TXT("qr_code_into_the_box");
    }
    return _promptLabel;
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{

    if(viewController == self){
        [navigationController setNavigationBarHidden:YES animated:YES];
    }else{

        //系统相册继承自 UINavigationController 这个不能隐藏 所有就直接return
        if ([navigationController isKindOfClass:[UIImagePickerController class]]) {
            return;
        }

        //不在本页时，显示真正的navbar
        [navigationController setNavigationBarHidden:NO animated:YES];
        //当不显示本页时，要么就push到下一页，要么就被pop了，那么就将delegate设置为nil，防止出现BAD ACCESS
        //之前将这段代码放在viewDidDisappear和dealloc中，这两种情况可能已经被pop了，self.navigationController为nil，这里采用手动持有navigationController的引用来解决
        if(navigationController.delegate == self){
            //如果delegate是自己才设置为nil，因为viewWillAppear调用的比此方法较早，其他controller如果设置了delegate就可能会被误伤
            navigationController.delegate = nil;
        }
    }

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}
@end
