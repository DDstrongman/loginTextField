//
//  AddDrugHistoryViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/9/7.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//
@protocol AddDrugSucessDelegate <NSObject>

@required
-(void)AddDrugSucess:(BOOL)sucess;

@end


#import <UIKit/UIKit.h>

@interface AddDrugHistoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UITableView *addDrugTable;//添加用药的表

@property (nonatomic,weak) id<AddDrugSucessDelegate> addDrugDelegate;

@end
