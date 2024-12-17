//
//  WebViewController.m
//  JL_OTA
//
//  Created by 李放 on 2024/11/28.
//  Copyright © 2024 Zhuhia Jieli Technology. All rights reserved.
//

#import "WebViewController.h"

#define USER_PRIVACY_POLICY  @"https://cam.jieliapp.com/app/JL_OTA_app_privacy_policy.html"    // 隐私政策的URL
#define USER_PROFILE_URL     @"https://cam.jieliapp.com/app/app.user.service.protocol.html"    // 用户协议的URL
#define ICP_URL              @"https://beian.miit.gov.cn/"                                     // ICP官网的URL

@interface WebViewController ()<WKNavigationDelegate>{
    __weak IBOutlet UIView *titleView;
    __weak IBOutlet NSLayoutConstraint *titleHeight;
    
    //空图片
    UIImageView *noneImv;
    //空文字1
    UILabel *noneLabFirst; //网络异常/暂无数据
    //空文字2
    UILabel *noneLabSecond; //请检查您的网络连接并稍后再试
    
    WKWebView *webView;
    
    NSString *webViewParams;
}

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initContentUI];
}

-(void)initContentUI{
    if(self.webType == PrivacyPolicyType){
        self.title = kJL_TXT("privacy_policy");
    }else if(self.webType == UserProfileType){
        self.title = kJL_TXT("user_agreement");
    }else {
        self.title = self.icpTitleName;
    }
    
    self.view.backgroundColor = kDF_RGBA(255, 255, 255, 1);
    
    UIImage *img = [[UIImage imageNamed:@"icon_return_nol"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStyleDone target:self action:@selector(backBtnAction)];
    leftBtn.tintColor = [UIColor grayColor];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    
    [self.view addSubview:[self webView]];
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self.view);
    }];
    
    /*--- 网络监测 ---*/
    AFNetworkReachabilityManager *net = [AFNetworkReachabilityManager sharedManager];
    [self actionNetStatus:net.networkReachabilityStatus];
    
    [net setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [self actionNetStatus:status];
    }];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [ webView evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%@'",webViewParams] completionHandler:nil];
    [ webView evaluateJavaScript:@"var script = document.createElement('script');"
     
     "script.type = 'text/javascript';"
     
     "script.text = \"function ResizeImages() { "
     
     "var myimg,oldwidth;"
     
     "var maxwidth = 1000.0;"
     
     "for(i=1;i <document.images.length;i++){"
     
     "myimg = document.images[i];"
     
     "oldwidth = myimg.width;"
     
     "myimg.width = maxwidth;"
     
     "}"
     
     "}\";"
     
     "document.getElementsByTagName('head')[0].appendChild(script);ResizeImages();" completionHandler:nil];
}

#pragma mark - 网络监测
-(void)actionNetStatus:(AFNetworkReachabilityStatus)status{
    if (status == AFNetworkReachabilityStatusNotReachable) {
        if(self.webType == PrivacyPolicyType || self.webType == UserProfileType){
            [self noNetWorkRequestHtml];
        }else {
            [self noNetWorkRequestIcpHtml];
        }
    }
    
    if (status == AFNetworkReachabilityStatusUnknown) {
        if(self.webType == PrivacyPolicyType || self.webType == UserProfileType){
            [self noNetWorkRequestHtml];
        }else {
            [self noNetWorkRequestIcpHtml];
        }
    }
    if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
        [self haveNetworkRequestHtml];
    }
    if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
        [self haveNetworkRequestHtml];
    }
    
    [self changeWebParams];
}

-(void)noNetWorkRequestHtml{
    NSURL *htmlURL;
    if(self.webType == PrivacyPolicyType){
        htmlURL = [[NSBundle mainBundle] URLForResource:@"user_privacy_policy" withExtension:@"html"];
    }else if(self.webType == UserProfileType){
        htmlURL = [[NSBundle mainBundle] URLForResource:@"user_protocol" withExtension:@"html"];
    }
    [webView loadFileURL:htmlURL allowingReadAccessToURL:htmlURL];
}

-(void)noNetWorkRequestIcpHtml{
    [self.view addSubview:[self noneImv]];
    [self.view addSubview:[self noneLabFirst]];
    [self.view addSubview:[self noneLabSecond]];
    
    [noneImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(kJL_HeightNavBar+100);
    }];
    
    [noneLabFirst mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(noneImv.mas_bottom).offset(20);
    }];
    
    [noneLabSecond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(noneLabFirst.mas_bottom).offset(5);
    }];
    
    webView.hidden = YES;
    noneImv.hidden = NO;
    noneLabFirst.hidden = NO;
    noneLabSecond.hidden = NO;
}

-(void)haveNetworkRequestHtml{
    NSURLRequest *request;
    if(self.webType == PrivacyPolicyType){
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:USER_PRIVACY_POLICY]];
    }else if(self.webType == UserProfileType){
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:USER_PROFILE_URL]];
    }else {
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:ICP_URL]];
        noneImv.hidden = YES;
        noneLabFirst.hidden = YES;
        noneLabSecond.hidden = YES;
    }
    
    webView.hidden = NO;
    [webView loadRequest:request];
}

-(void)changeWebParams{
    if(self.webType == ICPType){
        webViewParams = @"100%";
    }else{
        webViewParams = @"280%";
    }
}

-(void)backBtnAction{
    [self.navigationController popViewControllerAnimated:true];
}

-(WKWebView *)webView{
    if(!webView){
        webView = [[WKWebView alloc] init];
        webView.scrollView.bounces=NO;
        [webView.scrollView setShowsVerticalScrollIndicator:NO];
        webView.navigationDelegate = self;
    }
    return webView;
}

-(UIImageView *)noneImv{
    if(!noneImv){
        noneImv = [[UIImageView alloc] init];
        noneImv.contentMode = UIViewContentModeCenter;
        noneImv.image = [UIImage imageNamed:@"product_img_no_network"];
    }
    return noneImv;
}

-(UILabel *)noneLabFirst{
    if(!noneLabFirst){
        noneLabFirst = [[UILabel alloc] init];
        noneLabFirst.textColor = kDF_RGBA(36,36,36,1);
        noneLabFirst.textAlignment = NSTextAlignmentCenter;
        noneLabFirst.font = FontMedium(15);
        noneLabFirst.text = kJL_TXT("network_abnormality");
    }
    return noneLabFirst;
}

-(UILabel *)noneLabSecond{
    if(!noneLabSecond){
        noneLabSecond = [[UILabel alloc] init];
        noneLabSecond.textColor = kDF_RGBA(0, 0, 0, 0.3);
        noneLabSecond.textAlignment = NSTextAlignmentCenter;
        noneLabSecond.font =  FontMedium(14);
        noneLabSecond.text = kJL_TXT("check_network");
    }
    return noneLabSecond;
}


@end
