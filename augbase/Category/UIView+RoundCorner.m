//
//  UIImageView+RoundCorner.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/17.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "UIView+RoundCorner.h"

@implementation UIView (RoundCorner)

- (void) imageWithRound{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = self.frame.size.width/2;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void) imageWithRound:(BOOL)whiteCorner{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = self.frame.size.width/2;
    if (whiteCorner) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}

- (void)viewWithRadis:(float)radisCorner{
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:radisCorner];
}

@end
