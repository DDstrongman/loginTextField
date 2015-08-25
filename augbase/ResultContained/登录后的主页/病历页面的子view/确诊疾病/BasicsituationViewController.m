//
//  BasicsituationViewController.m
//  Yizhen
//
//  Created by ramy on 14-3-15.
//  Copyright (c) 2014年 jpx. All rights reserved.
//

#import "BasicsituationViewController.h"
//#import "MainViewController.h"
#import "CurrentileViewController.h"
#import "CurrentileViewControllerTwo.h"
#import "AFNetworking.h"
#import "TMMemoryCache.h"
#import "TMDiskCache.h"

@interface BasicsituationViewController ()

@end

@implementation BasicsituationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
#pragma mark- 导航栏
-(void)initnavBar{
    [self setNewbarTitle:NSLocalizedString(@"确认疾病", @"") andbackground:IMAGE(@"new128")];
    [self setNewbackBtnimage:IMAGE(@"左箭头.1")];
    
    
    /*
    int status=StatusHeight;
    self.newnavbar=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, TOP)];
    self.newnavbar.userInteractionEnabled=YES;
    self.newnavbar.image=[UIImage imageNamed:@"new128"];
    [self.view addSubview:self.newnavbar];
    
    
    UIFont *font=[UIFont fontWithName:@"Helvetica-Bold" size:17.5];
    CGSize titleSize = [@"基本情况"  sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, 18)];
    
    
    UILabel *titlelabel=[[UILabel alloc] initWithFrame:CGRectMake((320-titleSize.width)/2, 13+status, titleSize.width, 18)];
    titlelabel.textColor=[UIColor colorRGBA1];
    titlelabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:17.5];
    titlelabel.text=@"基本情况";
    [self.newnavbar addSubview:titlelabel];
    
    UIButton *backbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backbtn setFrame:CGRectMake(10, status+12, 41, 20)];
    [backbtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    backbtn.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 30);
    //    UIEdgeInsets insets = {top, left, bottom, right};
    [backbtn setEnlargeEdgeWithTop:10 right:30 bottom:10 left:10];
    
    [backbtn addTarget:self action:@selector(myleft:) forControlEvents:UIControlEventTouchUpInside];
    [self.newnavbar addSubview:backbtn];
    
    */
    
    
}
#pragma mark-viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];//1
    self.navigationController.navigationBarHidden = YES;//1
    [self initnavBar];//1
    [self.tabBarController.tabBar setHidden:YES];//1
 //   [self initArray];// 0.8 简单的 + 上面的 疾病的处理
    ch1=77;
    ch2=77;
    ch3=77;
    
    [self initview];
    [self AFgetsource];
    
}

-(void)initArray{
    self.fatherView.userInteractionEnabled=YES;
    self.mydic=[NSMutableDictionary dictionaryWithCapacity:2];
    [self.mydic setObject:[NSArray arrayWithObjects:@"A型",@"B型",@"C型",@"D型",@"E型",@"F型",@"G型",nil] forKey:@"乙肝"];
    [self.mydic setObject:[NSArray arrayWithObjects:@"1型",@"2型",@"3型",nil] forKey:@"丙肝"];
    //footview  布局  整体布局
    self.mypickview=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, 320, 275)];
    self.mypickview.userInteractionEnabled=YES;
    [self.mypickview addSubview:[SplitLineView getview:0 andY:0 andW:320]];
    UILabel *illlabel=[[UILabel alloc] initWithFrame:CGRectMake(85, 16, 60, 20)];
    illlabel.text=@"疾病";
    illlabel.backgroundColor=[UIColor clearColor];
    illlabel.font=[UIFont systemFontOfSize:18];
    [self.mypickview addSubview:illlabel];
    UILabel *typelabel=[[UILabel alloc] initWithFrame:CGRectMake(205, 16, 60, 20)];
    typelabel.text=@"基因型";
    typelabel.backgroundColor=[UIColor clearColor];
    typelabel.font=[UIFont systemFontOfSize:18];
    [self.mypickview addSubview:typelabel];
    [self.mypickview addSubview:[SplitLineView getview:0 andY:50 andW:320]];
    self.illpicker=[[UIPickerView alloc] initWithFrame:CGRectMake(20, 51, 160, 60)];
    self.illpicker.dataSource=self;
    self.illpicker.delegate=self;
    [self.illpicker selectRow:1 inComponent:0 animated:YES];
    [self.mypickview addSubview:self.illpicker];
    self.typepicker=[[UIPickerView alloc] initWithFrame:CGRectMake(120, 51, 200, 60)];
    self.typepicker.dataSource=self;
    [self.typepicker selectRow:2 inComponent:0 animated:YES];
    self.typepicker.delegate=self;
    [self.mypickview addSubview:self.typepicker];
    self.mykey=@"丙肝";
    
    
    
    
    
    UIImageView *aimgview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 226, 320, 49)];
    aimgview.userInteractionEnabled=YES;
    aimgview.image=[UIImage imageNamed:@"bar640×99@2x.png"];
    
    [self.mypickview addSubview:aimgview];
    
    UIButton *btnbar1=[UIButton buttonWithType:UIButtonTypeCustom];
    btnbar1.frame=CGRectMake(85, 4, 29, 41.5);
    [btnbar1 setBackgroundImage:[UIImage imageNamed:@"取消"] forState:UIControlStateNormal];
    [btnbar1 addTarget:self action:@selector(btnbar1) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    UIButton *btnbar2=[UIButton buttonWithType:UIButtonTypeCustom];
    btnbar2.frame=CGRectMake(215, 4, 29, 41.5);
    [btnbar2 setBackgroundImage:[UIImage imageNamed:@"完成"] forState:UIControlStateNormal];
    [btnbar2 addTarget:self action:@selector(btnbar2) forControlEvents:UIControlEventTouchUpInside];
    
    [aimgview addSubview:btnbar1];
    [aimgview addSubview:btnbar2];
    self.currentArray=[NSMutableArray arrayWithCapacity:10];
    self.yesArray=[NSMutableArray arrayWithCapacity:10];
    self.yestwoArray=[NSMutableArray arrayWithCapacity:10];

}
#pragma mark-取消
-(void)btnbar1{
    self.btn3.userInteractionEnabled=YES;
    [UIView animateWithDuration:0.6 animations:^{
        self.mypickview.frame=CGRectMake(0, SCREEN_HEIGHT, 300, 275);
        self.fatherView.contentOffset=CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        [self.mypickview removeFromSuperview];
    }];
}
#pragma mark-确认 修改病毒基因型
-(void)btnbar2{
    self.btn3.userInteractionEnabled=YES;
    NSString *illstr=[[self.mydic allKeys] objectAtIndex:[self.illpicker selectedRowInComponent:0]];
    
    NSString *typestr =[[self.mydic objectForKey:illstr] objectAtIndex:[self.typepicker selectedRowInComponent:0]];
    self.fatherView.contentOffset=CGPointMake(0, 0);
    self.mytypeile=[illstr stringByAppendingString:typestr];
    //CGRectMake(20, 172, 100, 30)
    [self.btn3 removeFromSuperview];
    for (UIView *v in virusview.subviews) {
        
        
        if ([v isKindOfClass:[UILabel class]]) {
            [v removeFromSuperview];
        }
    }
    UILabel *alabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 12)];
    alabel.font=[UIFont systemFontOfSize:12];
    alabel.textColor=colorRGBA5;
    alabel.backgroundColor=[UIColor clearColor];
    
    alabel.text=@"病毒基因型";
    [virusview addSubview:alabel];
    
    UILabel *alabel2=[[UILabel alloc] initWithFrame:CGRectMake(15, 20, 200, 20)];
    alabel2.font=[UIFont systemFontOfSize:14];
    alabel2.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *labeltap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(displayPickview)];
    labeltap.numberOfTapsRequired=1;
    [alabel2 addGestureRecognizer:labeltap];
    
    alabel2.backgroundColor=[UIColor clearColor];
    alabel2.textColor=colorRGBA4;
    alabel2.text=self.mytypeile;
    [virusview addSubview:alabel2];
    
    // NSLog(@"%@",self.mytypeile);
    
    
    
    
    [UIView animateWithDuration:0.6 animations:^{
        self.mypickview.frame=CGRectMake(0, SCREEN_HEIGHT, 320, 275);
        self.fatherView.contentOffset=CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        [self.mypickview removeFromSuperview];
    }];
    //修改病毒基因型
    [self sendchangeviruname:self.mytypeile];
    
}
-(void)exit{
    
    self.btn3.userInteractionEnabled=YES;
    self.fatherView.contentOffset=CGPointMake(0, 0);
    //CGRectMake(20, 172, 100, 30)
    [self.btn3 removeFromSuperview];
    for (UIView *v in virusview.subviews) {
        
        
        if ([v isKindOfClass:[UILabel class]]) {
            [v removeFromSuperview];
        }
    }
    UILabel *alabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 12)];
    alabel.font=[UIFont systemFontOfSize:12];
    alabel.textColor=colorRGBA5;
    alabel.backgroundColor=[UIColor clearColor];
    alabel.text=@"病毒基因型";
    [virusview addSubview:alabel];
    UILabel *alabel2=[[UILabel alloc] initWithFrame:CGRectMake(15, 20, 200, 20)];
    alabel2.font=[UIFont systemFontOfSize:14];
    alabel2.userInteractionEnabled=YES;
    UITapGestureRecognizer *labeltap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(displayPickview)];
    labeltap.numberOfTapsRequired=1;
    [alabel2 addGestureRecognizer:labeltap];
    alabel2.backgroundColor=[UIColor clearColor];
    alabel2.textColor=colorRGBA4;
    NSLog(@"--%@",self.mytypeile);
    
    alabel2.text=self.mytypeile;
    [virusview addSubview:alabel2];
    
    // NSLog(@"%@",self.mytypeile);
    
    
    
    
    [UIView animateWithDuration:0.6 animations:^{
        self.mypickview.frame=CGRectMake(0, SCREEN_HEIGHT, 320, 275);
        self.fatherView.contentOffset=CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        [self.mypickview removeFromSuperview];
    }];
    
}

#pragma mark- >_<|************初始化 *************|>_<
-(void)initview{
    //yes  scrollview
    int tt=64;
    self.fatherView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, tt+1, 320, SCREEN_HEIGHT)];
    self.fatherView.contentSize=CGSizeMake(320, SCREEN_HEIGHT+1);
    currentview1=[[UIView alloc] initWithFrame:CGRectMake(0, 1, 320, 77)];
    currentview1.backgroundColor=[UIColor whiteColor];
    self.fatherView.showsVerticalScrollIndicator=NO;
    
    UILabel *label1=[[UILabel alloc] init];
    label1.frame=CGRectMake(15, 10, 200, 14);
    label1.text=@"当前确诊疾病";
    label1.font=[UIFont systemFontOfSize:14];
    label1.textColor=colorRGBA4;
    [currentview1 addSubview:label1];
    //第一次启动 为空的时候
    self.btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    self.btn1.frame=CGRectMake(10, 33 , 147, 34);
    self.btn1.tag=1;
    [self.btn1 setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [self.btn1 addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"基本情况添加"] forState:UIControlStateNormal];
    [currentview1 addSubview:self.btn1];
    
    //第一条线 随时可以变
    baseline1=[SplitLineView getview:0 andY:33+34+10 andW:320];
    [currentview1 addSubview:baseline1];
    
    [self.fatherView addSubview:currentview1];
    
    /************病史******************/
    
    currentview2=[[UIView alloc] initWithFrame:CGRectMake(0, 79, 320, 77)];
    currentview2.backgroundColor=[UIColor whiteColor];
    
    
    UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(15, 9, 60, 14)];
    label2.text=@"病史";
    label2.textColor=colorRGBA4;
    label2.backgroundColor=[UIColor clearColor];
    label2.font=[UIFont systemFontOfSize:14];
    [currentview2 addSubview:label2];
    
    self.btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    self.btn2.frame=CGRectMake(10, 32 , 147, 34);
    self.btn2.tag=1;
    [self.btn2 setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [self.btn2 addTarget:self action:@selector(add2:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn2 setBackgroundImage:[UIImage imageNamed:@"基本情况添加"] forState:UIControlStateNormal];
    
    [currentview2 addSubview:self.btn2];
    baseline2=[[UIView alloc] initWithFrame:CGRectMake(0, ch2-1, 320, 0.5)];
    baseline2.backgroundColor=colorRGBA3;
    [currentview2 addSubview:baseline2];
    [self.fatherView addSubview:currentview2];
    [self.view addSubview:self.fatherView];
    
    
  //  [self viruview];
    //new  病毒基因型
#warning 病毒基因型
    
    currentview3=[[UIView alloc] initWithFrame:CGRectMake(0, 79+77, 320, 77)];
    currentview3.backgroundColor=[UIColor whiteColor];
    
    
    UILabel *label3=[[UILabel alloc] initWithFrame:CGRectMake(15, 9, 100, 14)];
    label3.text=@"病毒基因型";
    label3.textColor=colorRGBA4;
    label3.backgroundColor=[UIColor clearColor];
    label3.font=[UIFont systemFontOfSize:14];
    [currentview3 addSubview:label3];
    
    
    
    self.newbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.newbtn.frame=CGRectMake(10, 32 , 147, 34);
    self.newbtn.tag=3;
    [self.newbtn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [self.newbtn addTarget:self action:@selector(add3:) forControlEvents:UIControlEventTouchUpInside];
    [self.newbtn setBackgroundImage:[UIImage imageNamed:@"基本情况添加"] forState:UIControlStateNormal];
    
    [currentview3 addSubview:self.newbtn];
    baseline3=[[UIView alloc] initWithFrame:CGRectMake(0, ch3-1, 320, 0.5)];
    baseline3.backgroundColor=colorRGBA3;
    [currentview3 addSubview:baseline3];
    [self.fatherView addSubview:currentview3];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    self.isDisplay=!self.isDisplay;
    [self.mypickview removeFromSuperview];
    
    NSMutableString *string=[[NSMutableString alloc] init];
    
    for (int i=0; i<self.tmpArray0.count; i++) {
        [string appendString:self.tmpArray0[i]];
        
    }
    if (self.qrblock) {
        self.qrblock(string);
        
    }
    
    [super viewWillDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated{
    
    //[[MainViewController shandbasetabbarview].tabbarview setFrame:CGRectMake(0, SCREEN_HEIGHT, 320, 49)];
    
    [super viewWillAppear:animated];
}
#pragma mark- >_<|***********数据更新**************|>_<
-(void)AFgetsource{
   
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
	[HUD show:YES];
    //que/getabstractlist
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *url = [NSString stringWithFormat:@"%@und/list",Baseurl];
    NSString *uurl=[NSString stringWithFormat:@"%@?uid=%@&token=%@",url,[defaults objectForKey:@"userUID"],[defaults objectForKey:@"userToken"]];
    NSLog(@"%@",uurl);
    
    [UIDTOKEN getme].BASICurl=[[NSURL URLWithString:uurl] absoluteString];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
//    NSDictionary *dic=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIDTOKEN getme].uid,[UIDTOKEN getme].token,nil] forKeys:[NSArray arrayWithObjects:@"uid",@"token",nil]];
  
    
   id cacheobj= [[TMMemoryCache sharedCache] objectForKey:[[NSURL URLWithString:uurl] absoluteString]];
    if (1) {
        [manager POST:uurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"responseObject=%@",responseObject);
            NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            int res=[[source objectForKey:@"res"] intValue];
            NSLog(@"res=%d",res);
            if (res==0) {
                //请求完成
                [HUD hide:YES];
                [self AFreloadview:source];
                [[TMMemoryCache sharedCache] setObject:source forKey:[[NSURL URLWithString:uurl] absoluteString]];
                
                //  [self tableviewreload:source];
                
            }
            else if (res==14){
                [HUD hide:YES];
                
            }
            
            else{
                //服务端出错
                [HUD hide:YES];
                HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.view addSubview:HUD];
                
                
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new勾.png"]];
                HUD.mode = MBProgressHUDModeCustomView;
                
                HUD.delegate = self;
                HUD.labelText = @"服务器出错";
                
                [HUD show:YES];
                [HUD hide:YES afterDelay:1];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [HUD hide:YES];
            HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            [self.view addSubview:HUD];
            
            
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new勾.png"]];
            HUD.mode = MBProgressHUDModeCustomView;
            
            HUD.delegate = self;
            HUD.labelText = @"网络出错";
            
            [HUD show:YES];
            [HUD hide:YES afterDelay:1];
        }];

    }
    
    else{
        [HUD hide:YES];
        NSDictionary *source=[(NSDictionary *)[TMMemoryCache sharedCache] objectForKey:[[NSURL URLWithString:uurl] absoluteString]];
        
        [self AFreloadview:source];
 
    }
  }
#pragma mark-解析数据
-(void)AFreloadview:(NSDictionary *)dic{
    //需要两个数组
    NSMutableArray *array1=[NSMutableArray arrayWithCapacity:10];
    NSMutableArray *array2=[NSMutableArray arrayWithCapacity:10];
    //病毒基因型
    NSMutableArray *array3=[NSMutableArray arrayWithCapacity:10];
    
    self.tmpArray0=[NSMutableArray arrayWithCapacity:10];
    self.tmpArray1=[NSMutableArray arrayWithCapacity:10];
    self.tmpArray2=[NSMutableArray arrayWithCapacity:10];

    
    
    
    [array1 removeAllObjects];
    [array2 removeAllObjects];
    [array3 removeAllObjects];

    NSArray *keyarray=[dic objectForKey:@"disList"];
    NSLog(@"keyarray==%d",keyarray.count);
    for (int i=0; i<keyarray.count; i++) {
        NSDictionary *keydic1=[keyarray objectAtIndex:i];
        
        [array1 addObject:[keydic1 objectForKey:@"name"]];
        
    }
    NSArray *keyarray2=[dic objectForKey:@"disHisList"];//病史
    NSLog(@"keyarray2==%d",keyarray2.count);
    for (int i=0; i<keyarray2.count; i++) {
        NSDictionary *keydic2=[keyarray2 objectAtIndex:i];
        [array2 addObject:[keydic2 objectForKey:@"name"]];
        
    }
    
    NSArray *keyarray3=[dic objectForKey:@"virusList"];
    
    for (int i=0; i<keyarray3.count; i++) {
        NSDictionary *keydic3=[keyarray3 objectAtIndex:i];
        [array3 addObject:[keydic3 objectForKey:@"name"]];
        
    }

    
    for (int i=0; i<array1.count; i++) {
        [self.tmpArray0 addObject:array1[i]];
        
    }
    for (int i=0; i<array2.count; i++) {
        [self.tmpArray1 addObject:array2[i]];
        
    }
    for (int i=0; i<array3.count; i++) {
        [self.tmpArray2 addObject:array3[i]];
        
    }
    NSLog(@"%d-%d-%d",array1.count,array2.count,array3.count);
    
    [self topviewinit:array1];
    [self topviewinit2:array2];
    [self topviewinit3:array3];
    
    
}
-(void)reloadallview{
    
    [self topviewinit:self.tmpArray0];
    [self topviewinit2:self.tmpArray1];
    [self topviewinit3:self.tmpArray2];
    
}
#pragma mark-destroy
-(void)viruview{
    
//    virusview=[[UIView alloc] initWithFrame:CGRectMake(0, 156, 320, 45)];
//    virusview.backgroundColor=[UIColor whiteColor];
//    //病毒基因型
//    self.btn3=[[UILabel alloc] init];
//    
//    self.btn3.frame=CGRectMake(15, 15.5, 100, 14);
//    self.btn3.textColor=colorText;
//    self.btn3.font=[UIFont systemFontOfSize:14];
//    
//    self.btn3.userInteractionEnabled=YES;
//    self.btn3.text=@"病毒基因型";
//    
//    self.btn3.backgroundColor=[UIColor clearColor];
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(displayPickview)];
//    tap.numberOfTapsRequired=1;
//    [self.btn3 addGestureRecognizer:tap];
//    [virusview addSubview:self.btn3];
//    
//    [virusview addSubview:[SplitLineView getview:0 andY:45 andW:320]];
//    
//    [self.fatherView addSubview:virusview];
}
-(void)displayPickview{
    
    self.btn3.userInteractionEnabled=NO;
    
    
    if (SCREEN_HEIGHT==480) {
        
        
        
        
        [UIView animateWithDuration:0.8 animations:^{
            [self.fatherView setContentOffset:CGPointMake(0, ch1+ch2+1)];
            
        }];
        [[UIApplication sharedApplication].keyWindow addSubview:self.mypickview];
        
        [UIView animateWithDuration:0.6 animations:^{
            self.mypickview.frame=CGRectMake(0, SCREEN_HEIGHT-275, 320, 275);
            
        }];
        
        self.startpick.alpha=1;
        
        
        
        
        
    }
    else{
        
        
        [UIView animateWithDuration:0.8 animations:^{
            [self.fatherView setContentOffset:CGPointMake(0,ch1+ch2+1)];
            
        }];
        [[UIApplication sharedApplication].keyWindow addSubview:self.mypickview];
        
        [UIView animateWithDuration:0.6 animations:^{
            self.mypickview.frame=CGRectMake(0, SCREEN_HEIGHT-275, 320, 275);
            
        }];
        
        
        
        
    }
    
}


#pragma mark-Methed
-(void)bar1{
    self.btn3.userInteractionEnabled=YES;
    
    self.isDisplay=!self.isDisplay;
    if (SCREEN_HEIGHT==480) {
        [UIView animateWithDuration:0.8 animations:^{
            [self.fatherView setContentOffset:CGPointMake(0, 0)];
            
        }];
        
    }
    self.startpick.alpha=0;
    [self.mypickview removeFromSuperview];
    
}
-(void)bar2{
    self.btn3.userInteractionEnabled=YES;
    
    self.isDisplay=!self.isDisplay;
    if (SCREEN_HEIGHT==480) {
        [UIView animateWithDuration:0.8 animations:^{
            [self.fatherView setContentOffset:CGPointMake(0, 0)];
            
        }];
        
    }
    NSString *illstr=[self.illArray objectAtIndex:[self.startpick selectedRowInComponent:0]];
    NSString *typestr =[self.typeArray objectAtIndex:[self.startpick selectedRowInComponent:0]];
    
    
    self.mytypeile=[illstr stringByAppendingString:typestr];
    
    
    //CGRectMake(20, 172, 100, 30)
    [self.btn3 removeFromSuperview];
    
    UIView *aview=[[UIView alloc] initWithFrame:CGRectMake(-150, 163, 320, 48)];
    aview.backgroundColor=[UIColor whiteColor];
    aview.alpha=0.0;
    
    UILabel *alabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 5, 100, 15)];
    alabel.font=[UIFont systemFontOfSize:11];
    alabel.textColor=[UIColor grayColor];
    alabel.backgroundColor=[UIColor clearColor];
    
    alabel.text=@"病毒基因型";
    [aview addSubview:alabel];
    
    
    UILabel *alabel2=[[UILabel alloc] initWithFrame:CGRectMake(20, 24, 200, 20)];
    alabel2.font=[UIFont systemFontOfSize:14];
    alabel.backgroundColor=[UIColor clearColor];
    alabel2.textColor=[UIColor blackColor];
    alabel2.text=self.mytypeile;
    [aview addSubview:alabel2];
    
    
    [self.fatherView addSubview:aview];
    
    
    [UIView animateWithDuration:0.8 animations:^{
        [aview setFrame:CGRectMake(0, 163, 320, 48)];
        aview.alpha=1;
        
    }];
    
    
    //下面的bar消失
    self.startpick.alpha=0;
    [self.mypickview removeFromSuperview];
    
   // [[MainViewController shandbasetabbarview].tabbarview setFrame:CGRectMake(320, SCREEN_HEIGHT-49, 320, 49)];
    
}


#pragma mark-上半部分刷新界面
-(void)topviewinit:(NSArray *)array{
    
    
    
    for (UIView *a in currentview1.subviews) {
        if ([a isKindOfClass:[UIButton class]]) {
            [a removeFromSuperview];
            
        }
        
    }
    [currentview1 addSubview:self.btn1];
    
    self.currentArray=[NSMutableArray arrayWithCapacity:10];
    [self.currentArray removeAllObjects];
    
    for (int i=0; i<array.count; i++) {
        NSLog(@"--%@",array[i]);
        
        [self.currentArray addObject:array[i]];
        
    }
    NSLog(@"%d",self.currentArray.count);
    
    int a = self.currentArray.count;
    
    
    
    ch1=77+(a/2)*39;
    NSLog(@"ch1=%f",ch2);
    
    for (NSString *str in self.currentArray) {
        [self reloadcontentview:str];
        
    }
    
    
    
    if (self.currentArray.count==0) {
        
        NSLog(@"ch1=%f",ch1);
        
        [UIView animateWithDuration:0 animations:^{
            self.btn1.frame=CGRectMake(10, 33 , 147, 34);
            
            currentview1.frame=CGRectMake(0, 1, 320, ch1);
            baseline1.frame=CGRectMake(0, ch1-1, 320, 0.5);
            currentview2.frame=CGRectMake(0,ch1+1, 320, 77);
            virusview.frame=CGRectMake(0,116+77+1+1 , 320, 45);
            self.fatherView.userInteractionEnabled=YES;
            
            if (ch1+77+2+45>SCREEN_HEIGHT-64) {
                self.fatherView.scrollEnabled=YES;
                self.fatherView.contentSize=CGSizeMake(320, ch1+77+1+1+80+45);
                
            }
            
        }];
        
    }
    
    
}

#pragma mark-下半部分
-(void)topviewinit2:(NSArray *)array{
    
    
    
    for (UIView *a in currentview2.subviews) {
        if ([a isKindOfClass:[UIButton class]]) {
            [a removeFromSuperview];
            
        }
        
    }
    currentview2.userInteractionEnabled=YES;
    
    [currentview2 addSubview:self.btn2];
    [self.yesArray removeAllObjects];
    self.yesArray=[NSMutableArray arrayWithCapacity:10];
    
    for (int i=0; i<array.count; i++) {
        [self.yesArray addObject:array[i]];
        
    }
    int a = self.yesArray.count;
    
    ch2=77+(a/2)*39;
    NSLog(@"ch2====%f",ch2);
    
    for (NSString *str in self.yesArray) {
        [self reloadcontentview2:str];
    }
    if (self.yesArray.count==0) {
        [UIView animateWithDuration:0 animations:^{
            self.btn2.frame=CGRectMake(10, 33 , 147, 34);
            
            currentview1.frame=CGRectMake(0, 1, 320, ch1);
            baseline1.frame=CGRectMake(0, ch1-1, 320, 0.5);
            currentview2.frame=CGRectMake(0,ch1+1, 320, ch2);
            if (ch1+79+45>SCREEN_HEIGHT-64) {
                self.fatherView.scrollEnabled=YES;
                self.fatherView.contentSize=CGSizeMake(320, ch1+79+4+80+45);
                
            }
            baseline2.frame=CGRectMake(0, ch2-1, 320, 0.5);
            
        }];
        
    }
    
    
}
#pragma mark-病毒基因型
-(void)topviewinit3:(NSArray *)array{
    for (UIView *a in currentview3.subviews) {
        if ([a isKindOfClass:[UIButton class]]) {
            [a removeFromSuperview];
            
        }
        
    }
    currentview3.userInteractionEnabled=YES;
    
    [currentview3 addSubview:self.newbtn];
    [self.yestwoArray removeAllObjects];
    self.yestwoArray=[NSMutableArray arrayWithCapacity:10];
    
    for (int i=0; i<array.count; i++) {
        NSLog(@"%@",array[i]);
        [self.yestwoArray addObject:array[i]];
        
    }
    int a = self.yestwoArray.count;
    ch3=77+(a/2)*39;
    NSLog(@"ch3333====%f",ch3);
    
    for (NSString *str in self.yestwoArray) {
        [self reloadcontentview3:str];
    }
    if (self.yestwoArray.count==0) {
            self.newbtn.frame=CGRectMake(10, 33 , 147, 34);
            
            currentview1.frame=CGRectMake(0, 1, 320, ch1);
            baseline1.frame=CGRectMake(0, ch1-1, 320, 0.5);
            currentview2.frame=CGRectMake(0,ch1+1, 320, ch2);
            currentview3.frame=CGRectMake(0,ch1+1+ch2, 320, ch3);
            baseline2.frame=CGRectMake(0, ch2-1, 320, 0.5);
        baseline3.frame=CGRectMake(0, ch3-1, 320, 0.5);

        
            if (ch1+79+45+ch2>SCREEN_HEIGHT-64) {
                self.fatherView.scrollEnabled=YES;
                self.fatherView.contentSize=CGSizeMake(320, ch1+ch2+79+4+80+45);
                
            }
            
      
        
    }

    
}
-(void)reloadcontentview:(NSString *)str{
    
    
    NSMutableArray *myarray=[NSMutableArray arrayWithCapacity:10];
    
    
    
    for (UIView *btn in currentview1.subviews ) {
        if ([btn isKindOfClass:[UIButton class]]) {
            
            
            
            [myarray addObject:btn];
            
            
            
            
        }
    }
    
    [UIView animateWithDuration:0 animations:^{
        
        
        UIButton *sbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [sbtn setTitle:str forState:UIControlStateNormal];
        [sbtn setTitleColor:colorRGBA4 forState:JNormal];
        sbtn.titleLabel.font=[UIFont systemFontOfSize:14];
        sbtn.layer.cornerRadius=5;
        sbtn.backgroundColor=colorRGBA8;
        
        sbtn.frame=CGRectMake(10, 33, 147, 34);
        [currentview1 addSubview:sbtn];
        
        
        int total=myarray.count-1;
        
        
        
        //    int a=myarray.count+1;//真正的btn的数量
        
        currentview1.frame=CGRectMake(0, 1, 320, ch1);
        baseline1.frame=CGRectMake(0, ch1-1, 320, 0.5);
        currentview2.frame=CGRectMake(0,ch1+1, 320, ch2);
        virusview.frame=CGRectMake(0,ch1+ch2+1+1 , 320, 45);
        baseline2.frame=CGRectMake(0, ch2-1, 320, 0.5);
        if (ch1+ch2+2+45>SCREEN_HEIGHT-64) {
            self.fatherView.scrollEnabled=YES;
            self.fatherView.contentSize=CGSizeMake(320, ch1+ch2+2+45+80);
            
        }
        
        for (int i=total; i>=0; i--) {
            UIButton *btn=myarray[i];
            
            
            
            int xxx;
            if ((total-i)%2==0) {
                xxx=163;
                
            }
            else{
                xxx=10;
                
            }
            int yyy;
            yyy=(total-i+1)/2*39+33;
            
            btn.frame=CGRectMake(xxx, yyy, 147, 34);
        }
    }];
    
    
    
    
    
}
-(void)reloadcontentview2:(NSString *)str{
    
    NSLog(@"%@",str);
    
    NSMutableArray *myarray=[NSMutableArray arrayWithCapacity:10];
    
    for (UIView *btn in currentview2.subviews ) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [myarray addObject:btn];
        }
    }
    [UIView animateWithDuration:0 animations:^{
        UIButton *sbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [sbtn setTitle:str forState:UIControlStateNormal];
        [sbtn setTitleColor:colorRGBA4 forState:JNormal];
        sbtn.titleLabel.font=[UIFont systemFontOfSize:14];
        sbtn.layer.cornerRadius=5;
        sbtn.backgroundColor=colorRGBA8;
        
        sbtn.frame=CGRectMake(10, 33, 147, 34);
        [currentview2 addSubview:sbtn];
        int total=myarray.count-1;
        //真正的btn的数量  == total+1
        currentview1.frame=CGRectMake(0, 1, 320, ch1);
        baseline1.frame=CGRectMake(0, ch1-1, 320, 0.5);
        currentview2.frame=CGRectMake(0,ch1+1, 320, ch2);
        currentview3.frame=CGRectMake(0,ch1+ch2+1 ,320 , ch3);
        baseline2.frame=CGRectMake(0, ch2-1, 320, 0.5);
        baseline3.frame=CGRectMake(0, ch3-1, 320, 0.5);

        
        
        for (int i=total; i>=0; i--) {
            
            
            UIButton *btn=myarray[i];
            
            
            int xxx;
            if ((total-i)%2==0) {
                xxx=163;
                
            }
            else{
                xxx=10;
                
            }
            int yyy;
            yyy=(total-i+1)/2*39+33;
            
            btn.frame=CGRectMake(xxx, yyy, 147, 34);
        }
    }];
    
    
    
    
    
}
-(void)reloadcontentview3:(NSString *)str{
    NSLog(@"%@",str);
    
    
    NSMutableArray *myarray=[NSMutableArray arrayWithCapacity:10];
    
    for (UIView *btn in currentview3.subviews ) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [myarray addObject:btn];
        }
    }
    [UIView animateWithDuration:0 animations:^{
        UIButton *sbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [sbtn setTitle:str forState:UIControlStateNormal];
        [sbtn setTitleColor:colorRGBA4 forState:JNormal];
        sbtn.titleLabel.font=[UIFont systemFontOfSize:14];
        sbtn.layer.cornerRadius=5;
        sbtn.backgroundColor=colorRGBA8;
        
        sbtn.frame=CGRectMake(10, 33, 147, 34);
        [currentview3 addSubview:sbtn];
        int total=myarray.count-1;
        //真正的btn的数量  == total+1
        currentview1.frame=CGRectMake(0, 1, 320, ch1);
        baseline1.frame=CGRectMake(0, ch1-1, 320, 0.5);
        currentview2.frame=CGRectMake(0,ch1+1, 320, ch2);
        baseline2.frame=CGRectMake(0, ch2-1, 320, 0.5);

        
        currentview3.frame=CGRectMake(0, ch2+ch1+1, 320, ch3);
        baseline3.frame=CGRectMake(0, ch3-1, 320, 0.5);

            self.fatherView.scrollEnabled=YES;
            self.fatherView.contentSize=CGSizeMake(320, ch1+ch2+ch3+2+80+45);
            
       
        
        
        for (int i=total; i>=0; i--) {
            
            
            UIButton *btn=myarray[i];
            
            
            int xxx;
            if ((total-i)%2==0) {
                xxx=163;
                
            }
            else{
                xxx=10;
                
            }
            int yyy;
            yyy=(total-i+1)/2*39+33;
            
            btn.frame=CGRectMake(xxx, yyy, 147, 34);
        }
    }];
    
    
    
    
    
}
#pragma  mark--add
-(void)add:(UIButton *)btn{
    CurrentileViewController *currentVC=[[CurrentileViewController alloc] init];
    
    NSMutableArray *keyarray=[NSMutableArray arrayWithCapacity:10];
    for (UIView *btn in currentview1.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            
            if ([(UIButton *)btn currentTitle] .length>0) {
                [keyarray addObject:[(UIButton *)btn currentTitle]];
                
            }
        }
        
    }
    NSLog(@"keyarray=%d",keyarray.count);
    
    currentVC.oneArray=keyarray;
    
    currentVC.block=^(NSArray *currentArray){
        //先不做处理
              // [self AFgetsource];
    
        
        [self.tmpArray0 removeAllObjects];
        self.tmpArray0=[NSMutableArray arrayWithCapacity:10];
        for (int i=0; i<currentArray.count; i++) {
            NSLog(@"%@",currentArray[i]);
            
            [self.tmpArray0 addObject:currentArray[i]];
            NSLog(@"%@",self.tmpArray0);
            NSLog(@"%@",self.tmpArray0);

        }
        [self reloadallview];

        
//        [self topviewinit:currentArray];
//        
//        [self topviewinit2:self.yesArray];
//        
//        [self topviewinit3:self.yestwoArray];
    };
    
    
    [self.navigationController pushViewController:currentVC animated:YES];
    
    
    
}
-(void)add2:(UIButton *)btn{
    
    CurrentileViewControllerTwo *currentVC=[[CurrentileViewControllerTwo alloc] init];
    
    NSMutableArray *keyarray=[NSMutableArray arrayWithCapacity:10];
    for (UIView *btn in currentview2.subviews) {
        NSLog(@"%@",btn);
        if ([btn isKindOfClass:[UIButton class]]) {
            
            if ([(UIButton *)btn currentTitle] .length>0) {
                [keyarray addObject:[(UIButton *)btn currentTitle]];
                
            }
        }
        
    }
    
    currentVC.oneArray=keyarray;
    
    currentVC.block=^(NSArray *currentArray){
        
        //先不做处理
        [self.tmpArray1 removeAllObjects];
        self.tmpArray1=[NSMutableArray arrayWithCapacity:10];
        for (int i=0; i<currentArray.count; i++) {
            NSLog(@"%@",currentArray[i]);
            
            [self.tmpArray1 addObject:currentArray[i]];
            
        }
        [self reloadallview];

//        [self topviewinit2:currentArray];
//        [self topviewinit:self.currentArray];
//
//        [self topviewinit3:self.yestwoArray];

    };
    
    [self.navigationController pushViewController:currentVC animated:YES];
    
    
    
}
-(void)add3:(UIButton *)btn{
    
    CurrentileViewControllerThree *currentVC=[[CurrentileViewControllerThree alloc] init];
    
    NSMutableArray *keyarray=[NSMutableArray arrayWithCapacity:10];
    for (UIView *btn in currentview3.subviews) {
        NSLog(@"%@",btn);
        if ([btn isKindOfClass:[UIButton class]]) {
            
            if ([(UIButton *)btn currentTitle] .length>0) {
                [keyarray addObject:[(UIButton *)btn currentTitle]];
                
            }
        }
        
    }
    
    currentVC.oneArray=keyarray;
    
    currentVC.block=^(NSArray *currentArray){
        
        //先不做处理
        [self.tmpArray2 removeAllObjects];
        self.tmpArray2=[NSMutableArray arrayWithCapacity:10];

        for (int i=0; i<currentArray.count; i++) {
            [self.tmpArray2 addObject:currentArray[i]];
            
        }        //[self AFgetsource];
        [self cleanabout];
        
        [self reloadallview];
        
    };
    
    [self.navigationController pushViewController:currentVC animated:YES];
    
    
    
}
-(void)cleanabout{
    if ([UserD objectForKey:@"aboutcard"]!=NULL) {
        [[TMDiskCache sharedCache] removeObjectForKey:[UserD objectForKey:@"aboutcard"]];
        
    }

}
-(void)myleft:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}

#pragma mark-pickview DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (self.typepicker==pickerView) {
        //  NSLog(@"--%d",[[self.mydic objectForKey:self.mykey] count]);
        
        return [[self.mydic objectForKey:self.mykey] count];
        
    }
    else
    {
        return 2;
        
        
    }
    
    
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    
    if (self.illpicker == pickerView) {
        NSLog(@"%@--%d",[self.mydic allKeys],row);
        
        NSString *ill = [[self.mydic allKeys] objectAtIndex:row];
        NSLog(@"ill%@",ill);
        
        return ill;
    }
    
    else
    {
        
        NSString *type=[[self.mydic objectForKey:self.mykey] objectAtIndex:row];
        return type;
        
        
    }
    
    
    
    
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    if (component==0) {
        return 150;
    }else{
        return 80;
        
    }
}
#pragma mark-delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.illpicker == pickerView) {
        self.mykey=[[self.mydic allKeys] objectAtIndex:row];
        [self.typepicker reloadComponent:0];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-修改病毒
-(void)sendchangeviruname:(NSString *)str{
    NSString *url = [NSString stringWithFormat:@"%@und/create",Baseurl];
    {
        
        if ([str isEqualToString:@"乙肝A型"]) {
            str=@"20";
        }
        else if ([str isEqualToString:@"乙肝B型"]){
            str=@"21";
        }
        else if ([str isEqualToString:@"乙肝C型"]){
            str=@"22";
        }
        else if ([str isEqualToString:@"乙肝D型"]){
            str=@"23";
        }
        else if ([str isEqualToString:@"乙肝E型"]){
            str=@"24";
        }
        else if ([str isEqualToString:@"乙肝F型"]){
            str=@"25";
        }
        else if ([str isEqualToString:@"乙肝G型"]){
            str=@"26";
        }
        else if ([str isEqualToString:@"丙肝1型"]){
            str=@"27";
        }
        else if ([str isEqualToString:@"丙肝2型"]){
            str=@"28";
        }
        else if ([str isEqualToString:@"丙肝3型"]){
            str=@"29";
        }
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *yzuid=[user objectForKey:@"userUID"];
    NSString *yztoken=[user objectForKey:@"userToken"];
    //  NSLog(@"%@-%@",yztoken,yzuid);
    NSDictionary *dic=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:yzuid,yztoken,str,@"2",nil] forKeys:[NSArray arrayWithObjects:@"uid",@"token",@"did",@"category",nil]];
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        NSLog(@"%d",res);
        
        if (res==0) {
            //请求完成
            [self.view makeToast:@"    修改成功    " duration:0.5 position:@"center"];
            
        }
        else if (res==14){
        }
        else{
        }
        
        
        
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
    }];
    
    
    
}

@end
