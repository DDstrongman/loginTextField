//
//  BasicsituationViewController.h
//  Yizhen
//
//  Created by ramy on 14-3-15.
//  Copyright (c) 2014年 jpx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "BasicViewController.h"
#import "CurrentileViewControllerThree.h"
typedef void (^ Basicqrblock ) (NSString *s);

@interface BasicsituationViewController :BasicViewController <UIPickerViewDelegate,UIPickerViewDataSource,MBProgressHUDDelegate>
{
    UIView *baseline1;
    UIView *baseline2;
    UIView *baseline3;

    
    UIView *currentview1;
    UIView *currentview2;
    UIView *currentview3;
    
   // MBProgressHUD *HUD;
    
    UIView *virusview;
    
    
    
    float ch1;
    float ch2;
    float ch3;

    
    
}

@property (nonatomic,copy)Basicqrblock qrblock;

@property (nonatomic,assign)BOOL isExist;


@property (nonatomic,strong)UIScrollView *currentView;
@property (nonatomic,strong)UIScrollView *currentView2;
@property (nonatomic,strong)UIScrollView *currentView3;//病毒基因型

@property (nonatomic,strong)NSString *mytypeile;

@property (nonatomic,strong)UIButton *btn1;
@property (nonatomic,strong)UIButton *btn2;
@property (nonatomic,strong)UIButton *newbtn;//病毒基因型
@property (nonatomic,strong)UILabel *btn3;


//父视图
@property (nonatomic,strong)UIScrollView *fatherView;


@property (nonatomic,strong)NSMutableArray *illArray;
@property (nonatomic,strong)NSMutableArray *typeArray;
@property (nonatomic,strong)NSMutableDictionary *mydic;





@property (nonatomic,strong)UIPickerView *startpick;
@property (nonatomic,assign)BOOL isDisplay;
@property (nonatomic,strong)UIView *mypickview;

//new pickerview
@property (nonatomic,strong)UIPickerView *illpicker;
@property (nonatomic,strong)UIPickerView *typepicker;
@property (nonatomic,strong)NSString *mykey;



@property (nonatomic,strong)UIImageView *newnavbar;


@property (nonatomic,strong)NSMutableArray *currentArray;
@property (nonatomic,strong)NSMutableArray *yesArray;

//
@property (nonatomic,strong)NSMutableArray *yestwoArray;




@property (nonatomic,strong)NSMutableArray *tmpArray0;
@property (nonatomic,strong)NSMutableArray *tmpArray1;
@property (nonatomic,strong)NSMutableArray *tmpArray2;

@end
