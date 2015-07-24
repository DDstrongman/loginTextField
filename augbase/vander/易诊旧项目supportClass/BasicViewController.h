//
//  BasicViewController.h
//  Yizhen2
//
//  Created by Jpxin on 14-6-9.
//  Copyright (c) 2014年 Augbase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface BasicViewController : UIViewController<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;

}

-(void)setNewbarTitle:(NSString *)title andbackground:(UIImage *)image;

-(void)setNewbackBtnimage:(UIImage *)image;


-(void)setNewbarLeftTitle:(NSString *)title;
-(void)setNewbarRightTitle:(NSString *)title;

@property (nonatomic,strong)UIImageView *newbar;

@property (nonatomic,strong)UIButton *backbtn;
@property (nonatomic,strong)UIButton *leftbtn;
@property (nonatomic,strong)UIButton *rightbtn;
@property (nonatomic,strong)NSString *newtitle;
-(void)setNewbarTitle:(NSString *)title andbackground:(UIImage *)image andtitlecolor:(UIColor *)color;
-(CGSize)getRectsize:(NSInteger)fontsize andText:(NSString *)text andWidth:(float)w;




-(void)myleft;
-(void)mycancel;
-(void)myright;

-(void)creatAlertView:(NSString *)title andContent:(NSString *)content andcantitle:(NSString *)canceltitle andothers:(NSArray *)others;
-(void)loadline:(NSString *)loadstr;
-(void)creatFailure:(NSString *)failure;
-(void)creatsuccess:(NSString *)success;
-(void)creatHUD;

@property (nonatomic,strong)UILabel *navtitlelabel;






@end
