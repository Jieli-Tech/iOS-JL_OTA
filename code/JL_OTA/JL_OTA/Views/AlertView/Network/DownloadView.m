//
//  DownloadView.m
//  JL_OTA
//
//  Created by EzioChan on 2023/4/23.
//  Copyright © 2023 Zhuhia Jieli Technology. All rights reserved.
//

#import "DownloadView.h"
#import "ToolsHelper.h"

@interface DownloadView(){
   
}
@property(nonatomic,strong)UIImageView *bgView;
@property(nonatomic,strong)UIView *centerView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *secondLab;
@property(nonatomic,strong)UIProgressView *progressView;

@end

@implementation DownloadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

//MARK: - UI init

-(void)initUI{
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.bgView];
    [self addSubview:self.centerView];
    [_centerView addSubview:self.titleLab];
    [_centerView addSubview:self.secondLab];
    [_centerView addSubview:self.progressView];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).inset(13);
        make.height.offset(148);
        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).inset(33);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_centerView).inset(30);
        make.height.offset(26);
    }];
    
    [_secondLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_centerView).inset(30);
        make.top.equalTo(_titleLab.mas_bottom).offset(10);
        make.height.offset(25);
    }];
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_centerView).inset(28);
        make.bottom.equalTo(_centerView).inset(30);
        make.height.offset(3);
    }];
}

- (UIImageView *)bgView{
    if(!_bgView){
        _bgView = [[UIImageView alloc] init];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.3;
    }
    return _bgView;
}

-(UIView *)centerView{
    if (!_centerView){
        _centerView = [UIView new];
        _centerView.backgroundColor = [UIColor whiteColor];
        _centerView.layer.cornerRadius = 15;
        _centerView.layer.masksToBounds = true;
    }
    return _centerView;
}
- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:16];
        _titleLab.textColor = [UIColor colorFromHexString:@"#242424"];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}


-(UILabel *)secondLab{
    if(!_secondLab){
        _secondLab = [UILabel new];
        _secondLab.font = [UIFont systemFontOfSize:15];
        _secondLab.textColor = [UIColor colorFromHexString:@"#919191"];
        _secondLab.textAlignment = NSTextAlignmentCenter;
        
    }
    return _secondLab;
}

- (UIProgressView *)progressView{
    if(!_progressView){
        _progressView = [UIProgressView new];
        _progressView.progressTintColor = [UIColor colorFromHexString:@"#398BFF"];
        _progressView.trackTintColor = [UIColor colorFromHexString:@"#D8D8D8"];
        _progressView.progress = 0.0;
    }
    return _progressView;
}

//MARK: - Start download
-(void)downloadAction:(NSString *)url{
    self.hidden = false;

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    self->_secondLab.text = [url lastPathComponent];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        [DFAction mainTask:^{
            self->_progressView.progress = downloadProgress.fractionCompleted;
            self->_titleLab.text = [NSString stringWithFormat:@"%@ %.2f%%",kJL_TXT("downloading_file"),downloadProgress.fractionCompleted*100];
        }];
        
    }  destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        [DFAction mainTask:^{
            self->_secondLab.text = [response suggestedFilename];
        }];
        return [ToolsHelper targetSavePath:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        kJLLog(JLLOG_DEBUG, @"File downloaded to: %@", filePath);
        [DFAction mainTask:^{
            self.hidden = true;
            self->_titleLab.text = @"";
            self->_progressView.progress = 0.0;
            self->_secondLab.text = @"";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_FILE" object:nil];
        }];
        
    }];
    [downloadTask resume];
}

@end
