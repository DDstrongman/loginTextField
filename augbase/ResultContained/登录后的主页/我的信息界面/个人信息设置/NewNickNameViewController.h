//
//  NewNickNameViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/9/9.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

@protocol EditNickNameDele <NSObject>

@required
-(void)editNickNameResult:(BOOL)result;

@end

#import <UIKit/UIKit.h>

#import "ImageViewLabelTextFieldView.h"

@interface NewNickNameViewController : UIViewController

@property (nonatomic,strong) ImageViewLabelTextFieldView *editNickName;//修改昵称

@property (nonatomic,weak) id<EditNickNameDele>editResultDele;

@end
