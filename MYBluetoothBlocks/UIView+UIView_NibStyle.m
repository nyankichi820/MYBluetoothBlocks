//
//  UIView+UIView_Roundable.m
//  MYBluetoothBlocks
//
//  Created by masafumi yoshida on 2014/03/23.
//  Copyright (c) 2014年 masafumi yoshida. All rights reserved.
//

#import "UIView+UIView_NibStyle.h"

@implementation UIView (UIView_NibStyle)


-(void)awakeFromNib{
    
    if([self isKindOfClass:[UIButton class] ]){
        self.layer.cornerRadius = 2;
        self.layer.shadowColor  = [UIColor lightGrayColor].CGColor;
        self.layer.shadowRadius  = 2.0f;
        self.layer.shadowOpacity  = 0.5f;
        self.layer.shadowOffset  = CGSizeMake(2, 2);
        self.clipsToBounds = NO;
    }
    
    if([self isKindOfClass:[UILabel class] ]){
        UILabel *label = (UILabel*)self;
        label.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:16];
    }
    
}

@end
