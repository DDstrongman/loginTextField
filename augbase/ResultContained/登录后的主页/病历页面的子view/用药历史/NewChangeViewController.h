//
//  NewChangeViewController.h
//  Yizhen2
//
//  Created by Jpxin on 14-9-28.
//  Copyright (c) 2014年 Augbase. All rights reserved.
//

#import "BasicViewController.h"
#import "Drug.h"
#import "TMCache.h"

typedef void (^ChangeDrug) (Drug *drug,NSIndexPath *ind);

@interface NewChangeViewController : BasicViewController<UITextFieldDelegate,MBProgressHUDDelegate>
{
    int taskcount;
    int legalname;
    UIScrollView *drugalert;
    int isdisplay;

    int yesname;
    
   // MBProgressHUD *HUD;
}
@property (nonatomic,strong)Drug *mydrug;
@property (nonatomic,strong)NSIndexPath *ind;

@property (nonatomic,copy)ChangeDrug changeblock;
@property (nonatomic,strong)NSMutableArray *keynewArray;
@property (nonatomic,strong)UIView *footview;
@property (nonatomic,strong)UITextField *drugname;
@property (nonatomic,strong)UIButton *startbtn;
@property (nonatomic,strong)UIButton *endbtn;

@property (nonatomic,strong)UIButton *timebtn;
@property (nonatomic,strong)UISwitch *iskang;
@end
