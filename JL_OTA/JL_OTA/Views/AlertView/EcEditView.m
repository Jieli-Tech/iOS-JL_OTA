//
//  EcEditView.m
//  JL_OTA
//
//  Created by EzioChan on 2022/11/4.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "EcEditView.h"

@implementation EcEditView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds, 20, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds, 20, 0);
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds{
    return CGRectMake(bounds.size.width-bounds.size.height, 0, bounds.size.height, bounds.size.height);
}

@end
