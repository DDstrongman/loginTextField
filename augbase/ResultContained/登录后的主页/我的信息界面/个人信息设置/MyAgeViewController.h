//
//  MyAgeViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/9/22.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UpdateAgeDelegate <NSObject>

@required
-(void)UpdateAge:(BOOL)result;
@end

@interface MyAgeViewController : UIViewController

@property (nonatomic,weak) id<UpdateAgeDelegate> updateAge;

@end
