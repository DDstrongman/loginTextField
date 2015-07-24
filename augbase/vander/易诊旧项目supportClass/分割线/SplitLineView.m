//
//  SplitLineView.m
//  Yizhen
//
//  Created by ramy on 14-3-25.
//  Copyright (c) 2014年 jpx. All rights reserved.
//

#import "SplitLineView.h"

@implementation SplitLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
+(SplitLineView *)getview:(float )x  andY:(float)y andW:(float)w{
    SplitLineView *sq=[[SplitLineView alloc]initWithFrame:CGRectMake(x, y, w, 0.6)];
    sq.backgroundColor=colorRGBA3;
    return sq;
    

}

+(SplitLineView *)getview2:(float )x  andY:(float)y andW:(float)w{
    SplitLineView *sq=[[SplitLineView alloc]initWithFrame:CGRectMake(x, y, w, 0.6)];
    sq.backgroundColor=[UIColor blackColor];
    return sq;
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
