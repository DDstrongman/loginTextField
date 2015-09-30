//
//  ModifyDrugHistoryViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/9/7.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//
@protocol ModifyDrugSucess <NSObject>

@required
-(void)modifyDrugResult:(BOOL)success;

@end


#import <UIKit/UIKit.h>

@interface ModifyDrugHistoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UITableView *resetDrugTable;//重置药物历史

@property (nonatomic,strong) NSDictionary *drugDic;//传入选择的用药历史

@property (nonatomic,weak) id<ModifyDrugSucess>modifyDrugSuccess;

@end
