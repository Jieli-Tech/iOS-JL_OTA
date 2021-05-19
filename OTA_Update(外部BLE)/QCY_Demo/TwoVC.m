//
//  TwoVC.m
//  QCY_Demo
//
//  Created by 杰理科技 on 2020/3/17.
//  Copyright © 2020 杰理科技. All rights reserved.
//

#import "TwoVC.h"

@interface TwoVC (){
    UIScrollView    *subScrollView;
    JL_EQMode       nowEqMode;
    NSArray         *eqArray;
    int8_t          sld_v_1;
    int8_t          sld_v_2;
    int8_t          sld_v_3;
    int8_t          sld_v_4;
    int8_t          sld_v_5;
    int8_t          sld_v_6;
    int8_t          sld_v_7;
    int8_t          sld_v_8;
    int8_t          sld_v_9;
    int8_t          sld_v_10;
    
    __weak IBOutlet UIButton *btn_1;
    __weak IBOutlet UIButton *btn_2;
    __weak IBOutlet UIButton *btn_3;
    __weak IBOutlet UIButton *btn_4;
    __weak IBOutlet UIButton *btn_5;
    __weak IBOutlet UIButton *btn_6;
    __weak IBOutlet UIButton *btn_7;
    
}
@property (assign,nonatomic) float sw;
@property (assign,nonatomic) float sh;
@property (assign,nonatomic) float sGap_h;
@property (assign,nonatomic) float sGap_t;
@end

@implementation TwoVC

- (void)viewDidLoad {
    [super viewDidLoad];


}

-(void)setupUI{

}

-(void)updateEqModeUI{

}

-(void)updateEqArrayUI{

}

-(void)onSliderValue:(UISlider*)slider{

}

- (IBAction)btn_1:(id)sender {
    
}
- (IBAction)btn_2:(id)sender {
}

- (IBAction)btn_3:(id)sender {
}
- (IBAction)btn_4:(id)sender {
}
- (IBAction)btn_5:(id)sender {
}
- (IBAction)btn_6:(id)sender {
}
- (IBAction)btn_7:(id)sender {
}


-(void)noteChangeEqMode:(NSNotification*)note{
}

-(void)noteChangeEqArray:(NSNotification*)note{
}

-(void)addNote{
    
}





@end
