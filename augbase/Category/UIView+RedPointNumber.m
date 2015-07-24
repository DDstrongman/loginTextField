//
//  UIImageView+RedPointNumber.m
//  mytest
//
//  Created by 李胜书 on 15/7/22.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "UIView+RedPointNumber.h"

@implementation UIView(RedPointNumber)

-(void)imageWithRedPoint{
    UILabel *pointView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 12, 12)];
    pointView.backgroundColor = [UIColor redColor];
    [pointView imageWithRound:NO];
    pointView.center = CGPointMake(self.frame.size.width-3, 3);
    [self addSubview:pointView];
}

-(void)imageWithRedNumber:(NSInteger)number{
    UILabel *numberView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
    numberView.backgroundColor = [UIColor redColor];
    [numberView imageWithRound:NO];
    numberView.center = CGPointMake(self.frame.size.width-3, 3);
    numberView.text = [NSString stringWithFormat:@"%ld",(long)number];
    numberView.textAlignment = NSTextAlignmentCenter;
    numberView.font = [UIFont systemFontOfSize:11.0];
    numberView.textColor = [UIColor whiteColor];
    [self addSubview:numberView];
}

@end
