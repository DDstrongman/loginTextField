//
//  MyNoteViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/9/9.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

@protocol ChangeNoteDele <NSObject>

@required
-(void)changeNote:(BOOL)result;

@end

#import <UIKit/UIKit.h>

@interface MyNoteViewController : UIViewController

@property (nonatomic,weak) id<ChangeNoteDele>changeDele;

@end
