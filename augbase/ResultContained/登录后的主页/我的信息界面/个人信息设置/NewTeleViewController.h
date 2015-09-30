//
//  NewTeleViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/9/9.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//
@protocol EditTeleDele <NSObject>

@required
-(void)editTeleResult:(BOOL)result;

@end
#import <UIKit/UIKit.h>

@interface NewTeleViewController : UIViewController

@property (nonatomic,weak) id<EditTeleDele>editTeleResultDele;

@end
