//
//  ChooseTimeViewController.h
//  Yizhenapp
//
//  Created by 李胜书 on 15/10/10.
//  Copyright © 2015年 李胜书. All rights reserved.
//
@protocol ChooseTimeArrayDele <NSObject>

@required
-(void)chooseTimeArray:(NSArray *)choosedArray;//选择了哪些数组

@end

#import <UIKit/UIKit.h>

@interface ChooseTimeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *setShareTimeTable;//选择分享的表格

@property (nonatomic,strong) NSArray *timeArray;
@property (nonatomic,strong) NSArray *setChoosedTimeArray;

@property (nonatomic,weak) id<ChooseTimeArrayDele> chooseTimeArrayDele;

@end
