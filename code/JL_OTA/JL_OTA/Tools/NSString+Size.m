//
//  NSString+Size.m
//  JL_OTA
//
//  Created by EzioChan on 2022/11/28.
//  Copyright © 2022 Zhuhia Jieli Technology. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

-(CGFloat)textWidthFont:(UIFont*)font maxHeight:(CGFloat)height{
    CGFloat width =0;
    do{
        if(self.length<=0) {
            break;
        }
        NSDictionary *attribute = @{NSFontAttributeName:font};
        CGRect retSize = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingTruncatesLastVisibleLine |
                           NSStringDrawingUsesLineFragmentOrigin |
                           NSStringDrawingUsesFontLeading attributes:attribute context:nil];
        width = retSize.size.width;
    }while(0);
    return ceil(width);
}

@end
