//
//  UIImageView+RoundCorner.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/17.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (RoundCorner)

- (void)imageWithRound;
- (void)imageWithRound:(BOOL)whiteCorner;
- (void)viewWithRadis:(float)radisCorner;

@end
