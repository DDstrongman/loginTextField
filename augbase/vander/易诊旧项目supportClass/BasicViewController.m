//
//  BasicViewController.m
//  Yizhen2
//
//  Created by Jpxin on 14-6-9.
//  Copyright (c) 2014年 Augbase. All rights reserved.
//

#import "BasicViewController.h"

@interface BasicViewController ()
{
}
@end

@implementation BasicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setHidden:YES];
    
    
    
    
    
}
-(void)setNewbarTitle:(NSString *)title andbackground:(UIImage *)image{
    
    
    self.newbar=[[UIImageView alloc] Jframe(0, 0, SCREEN_WIDTH, 64)];
    self.newbar.image=image;
    self.newbar.userInteractionEnabled=YES;
    [self.view addSubview:self.newbar];
    
    
    
    
    
    //title
//    NSDictionary* attrs =@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:17.5]};
//    NSAttributedString *newatt=[[NSAttributedString alloc] initWithString:title attributes:attrs];
//    CGRect rect=[newatt boundingRectWithSize:CGSizeMake(MAXFLOAT, 18) options:NSStringDrawingTruncatesLastVisibleLine context:nil];
    
    
    self.navtitlelabel=[[UILabel alloc] initWithFrame:CGRectMake(90, 13+20, 140, 18)];
    self.navtitlelabel.textColor=colorText;
    self.navtitlelabel.textAlignment=NSTextAlignmentCenter;
    
    self.navtitlelabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:17.5];
    self.navtitlelabel.text=title;
    [self.newbar addSubview:self.navtitlelabel];
    
    
    
    
}
-(void)setNewbarTitle:(NSString *)title andbackground:(UIImage *)image andtitlecolor:(UIColor *)color{
    
    self.newbar=[[UIImageView alloc] Jframe(0, 0, SCREEN_WIDTH, 64)];
    self.newbar.image=image;
    self.newbar.userInteractionEnabled=YES;
    [self.view addSubview:self.newbar];
    
    
    
    
    
    //title
    NSDictionary* attrs =@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:17.5]};
    NSAttributedString *newatt=[[NSAttributedString alloc] initWithString:title attributes:attrs];
    CGRect rect=[newatt boundingRectWithSize:CGSizeMake(MAXFLOAT, 18) options:NSStringDrawingTruncatesLastVisibleLine context:nil];
    CGSize titleSize=rect.size;
    
    
    
    UILabel *titlelabel=[[UILabel alloc] initWithFrame:CGRectMake(40, 13+20, 240, 18)];
    titlelabel.textColor=color;
    titlelabel.textAlignment=NSTextAlignmentCenter;
    
    titlelabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:17.5];
    titlelabel.text=title;
    [self.newbar addSubview:titlelabel];

}

-(void)setNewbackBtnimage:(UIImage *)image{
    
   self.backbtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.backbtn  setFrame:CGRectMake(10, 20+12, 11, 20)];
    [self.backbtn  setBackgroundImage:image forState:JNormal];
    [self.backbtn  setEnlargeEdgeWithTop:11 right:100 bottom:20 left:20];
    [self.backbtn  addTarget:self action:@selector(myleft) forControlEvents:UIControlEventTouchUpInside];
    [self.newbar addSubview:self.backbtn];
    
    
    
}

-(void)setNewbarLeftTitle:(NSString *)title{
    self.leftbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.leftbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.leftbtn.titleLabel.textAlignment=NSTextAlignmentLeft;
    self.leftbtn.titleLabel.font=[UIFont systemFontOfSize:17.5];
    [self.leftbtn setTitleColor:colorText forState:UIControlStateNormal];
    [self.leftbtn setTitle:title forState:UIControlStateNormal];
    self.leftbtn.frame=CGRectMake(10, 20+13, 40+30, 18);
    [self.newbar addSubview:self.leftbtn];
    [self.leftbtn setEnlargeEdgeWithTop:20 right:0 bottom:20 left:10];
    [self.leftbtn addTarget:self action:@selector(mycancel) forControlEvents:JAction];
}

-(void)setNewbarRightTitle:(NSString *)title{
    
    
    self.rightbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.rightbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.rightbtn.titleLabel.textAlignment=NSTextAlignmentLeft;
    self.rightbtn.titleLabel.font=[UIFont systemFontOfSize:17.5];
    [self.rightbtn setTitleColor:colorText forState:UIControlStateNormal];
    [self.rightbtn setTitle:title forState:UIControlStateNormal];
    self.rightbtn.enabled=NO;
    [self.rightbtn setEnlargeEdgeWithTop:20 right:10 bottom:20 left:10];

    self.rightbtn.frame=CGRectMake(275-35-20-10-10, 20+13, 35+35+20+10+10, 18);
    
    [self.newbar addSubview:self.rightbtn];
    [self.rightbtn addTarget:self action:@selector(myright) forControlEvents:UIControlEventTouchUpInside];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)myleft{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)mycancel{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)myright{
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark- 获取label自适应后的height
-(CGSize)getRectsize:(NSInteger)fontsize andText:(NSString *)text andWidth:(float)w{
    if (text.length==0) {
        CGSize size=CGSizeZero;
        return size;
    }
    else{
        CGSize constraint = CGSizeMake(w, 20000.0f);
        
        NSDictionary * attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:fontsize] forKey:NSFontAttributeName];
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:text
         attributes:attributes];
        CGRect rect = [attributedText boundingRectWithSize:constraint
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGSize size = rect.size;
        
        return  size;
    }
    
}


#pragma mark-hud
-(void)creatsuccess:(NSString *)success{
    [HUD hide:YES];

    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new勾.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.delegate = self;
    HUD.labelText = success;
    [HUD show:YES];
    [HUD hide:YES afterDelay:1.1];
    
}
-(void)creatFailure:(NSString *)failure{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.mode=MBProgressHUDModeText;
    
    HUD.delegate = self;
    HUD.labelText = failure;
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
    
}
-(void)creatHUD{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
    
}

-(void)loadline:(NSString *)loadstr{
    [HUD hide:YES];

    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = loadstr;
    [HUD show:YES];
    
}
#pragma mark-alert
-(void)creatAlertView:(NSString *)title andContent:(NSString *)content andcantitle:(NSString *)canceltitle andothers:(NSArray *)others{
    
    
    //        UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    //
    //        UIAlertAction *a1=[UIAlertAction actionWithTitle:canceltitle
    //                                                   style:UIAlertActionStyleCancel
    //                                                 handler:^(UIAlertAction *action) {
    //
    //                                                 }];
    //
    //
    //        [alertVC addAction:];
    
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:title message:content delegate:self cancelButtonTitle:canceltitle otherButtonTitles: nil];
    for (int i=0; i<others.count; i++) {
        [alertView addButtonWithTitle:others[i]];
        
        
    }
    [alertView show];
    
    
    
}


@end
