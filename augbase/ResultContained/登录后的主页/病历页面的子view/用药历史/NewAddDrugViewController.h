//
//  NewAddDrugViewController.h
//  Yizhen2
//
//  Created by Jpxin on 14-9-28.
//  Copyright (c) 2014年 Augbase. All rights reserved.
//

#import "BasicViewController.h"
#import "HistoryViewController.h"
#import "Newdrug.h"
typedef void (^AddHisdrug) (Drug *drug);


@interface NewAddDrugViewController : BasicViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate>
{
    int taskcount;
    int legalname;
    UIScrollView *drugalert;
    int isdisplay;
    Drug *mydrug;
   // MBProgressHUD *HUD;
    
}
@property (nonatomic,assign)id delegate;
@property (nonatomic,copy)AddHisdrug addblock;

@property (nonatomic,strong)NSMutableArray *keynewArray;



@property (nonatomic,strong)UIView *footview;
@property (nonatomic,strong)UITextField *drugname;

@property (nonatomic,strong)UIButton *startbtn;
@property (nonatomic,strong)UIButton *endbtn;

@property (nonatomic,strong)UIButton *timebtn;
@property (nonatomic,strong)UISwitch *iskang;

@end
