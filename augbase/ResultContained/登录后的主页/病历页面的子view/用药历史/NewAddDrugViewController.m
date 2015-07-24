//
//  NewAddDrugViewController.m
//  Yizhen2
//
//  Created by Jpxin on 14-9-28.
//  Copyright (c) 2014年 Augbase. All rights reserved.
//

#import "NewAddDrugViewController.h"
#import "Newdrug.h"
#import "TMCache.h"
static int xxxx=10;
static int newrows=0;
@interface NewAddDrugViewController ()
{
    
    NSString *startTime;
    NSString *endTime;
    UIDatePicker *datapick;
    UIButton *btnbar3;
    UIImageView *barview;
    
    
}
@end

@implementation NewAddDrugViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)myright{
    if ([self getMoretimesize]) {
        mydrug=[[Drug alloc] init];
        mydrug.name=self.drugname.text;
        mydrug.starttime=startTime;
        if ([endTime isEqualToString:@"~至今"]) {
            mydrug.isuse=1;
            
        }
        else{
            mydrug.endtime=[endTime substringFromIndex:1];
            
        }
        mydrug.iskang=self.iskang.on;
        NSString *mid;
        for (int i=0;i<self.keynewArray.count ; i++) {
            Newdrug *obj=self.keynewArray[i];
            if ([obj.drugname isEqualToString:self.drugname.text]) {
                mid=obj.myid;
                break;
                
            }
            
        }
        if (mid==nil) {
            
        }
        else{
            [self addnetworking:mid];
        }

    }
    else{
        
        
    }
    
    
    
    
    
}
-(void)addnetworking:(NSString *)mid{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@emr/medicinemanagement/create",Baseurl];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *yzuid=[UIDTOKEN getme].uid;
    NSString *yztoken=[UIDTOKEN getme].token;
    
    NSString *newstarttime;
    newstarttime=startTime;
    NSString *newendtime;
    if ([endTime isEqualToString:@"~至今"]) {
        newendtime=@"2020-12-12";
        
    }else {
        newendtime=[endTime substringFromIndex:1];
    }
    NSLog(@"%@,%@",newendtime,newstarttime);
    NSDictionary *dic;
    NSLog(@"kk=%@",mid);
    
    dic =[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:yzuid,yztoken,self.drugname.text,newstarttime,newendtime,[NSNumber numberWithBool:self.iskang.on],[NSString stringWithFormat:@"%d",mydrug.isuse],mid,nil] forKeys:[NSArray arrayWithObjects:@"uid",@"token",@"medicinename",@"begindate",@"stopdate",@"resistant",@"isuse",@"mid",nil]];
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"responseObject=%@",responseObject);
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        NSLog(@"%d",res);
        
        
        if (res==0) {
            [self cleancache];

            [HUD hide:YES];

            mydrug.mhid=[source objectForKey:@"mhid"];
            mydrug.mid=mid;
            
            [self.delegate addObj:mydrug];
            [self backaaa];
            
            //请求完成
            
        }
        
        else{
            [HUD hide:YES];

            HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            [self.view addSubview:HUD];
            
            HUD.mode = MBProgressHUDModeCustomView;
            
            HUD.delegate = self;
            HUD.labelText = @"添加失败";
            
            [HUD show:YES];
            [HUD hide:YES afterDelay:1];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD hide:YES];

        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.view addSubview:HUD];
        
        HUD.mode = MBProgressHUDModeCustomView;
        
        HUD.delegate = self;
        HUD.labelText = @"添加失败";
        
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
    }];

 

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNewbarTitle:@"添加用药历史" andbackground:IMAGE(@"new128")];
    [self setNewbarLeftTitle:@"取消"];
    [self setNewbarRightTitle:@"存储"];
    [self.rightbtn setEnabled:NO];
    [self.rightbtn setTitleColor:colorRGBA5 forState:UIControlStateDisabled];
    [self initview];
    

    
}
-(void)initview{
    int a=64;
    self.drugname=[[UITextField alloc] initWithFrame:CGRectMake(10, a+12.5, 320-10, 20)];
    self.drugname.returnKeyType=UIReturnKeyDone;
    self.drugname.delegate=self;
    self.drugname.font=[UIFont systemFontOfSize:14];
    self.drugname.backgroundColor=[UIColor clearColor];
    self.drugname.font=[UIFont systemFontOfSize:14];
    [self.drugname becomeFirstResponder];
    self.drugname.adjustsFontSizeToFitWidth=YES;
    //self.drugname
    self.drugname.placeholder=@"药物名称";
    self.drugname.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(10, a+10+45, 24, 24)];
    imgview.image=[UIImage imageNamed:@"时间"];
    
    self.startbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.startbtn setTitle:@"开始时间" forState:UIControlStateNormal];
    [self.startbtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.startbtn setTitleColor:colorRGBA4 forState:UIControlStateNormal];
    
    [self.startbtn addTarget:self action:@selector(addstarttime) forControlEvents:UIControlEventTouchUpInside];
    [self.startbtn setFrame:CGRectMake(10+25, a+10+45, 60, 25)];
    
    
    
    self.endbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.endbtn setTitle:@"~停药时间" forState:UIControlStateNormal];
    [self.endbtn setTitleColor:colorRGBA4 forState:UIControlStateNormal];
    [self.endbtn addTarget:self action:@selector(addstarttime2) forControlEvents:UIControlEventTouchUpInside];
    [self.endbtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    endTime=@"~停药时间";
    [self.endbtn setFrame:CGRectMake(66+25, a+10+45, 72, 25)];
    
    
    
    UIView *lineview=[[UIView alloc] initWithFrame:CGRectMake(12, a+45, 320-24, 0.5)];
    lineview.backgroundColor=colorRGBA3;
    //    UILabel *isdrug=[[UILabel alloc] initWithFrame:CGRectMake(10, a+55, 100, 20)];
    //    isdrug.backgroundColor=[UIColor clearColor];
    //    isdrug.font=[UIFont systemFontOfSize:14];
    //    isdrug.textColor=colorRGBA4;
    //    isdrug.text=@"是否耐药";
    //
    
    UILabel *nodrug=[[UILabel alloc] initWithFrame:CGRectMake(220, a+55, 50, 25)];
    nodrug.backgroundColor=[UIColor clearColor];
    nodrug.font=[UIFont systemFontOfSize:14];
    nodrug.text=@"耐药";
    nodrug.textColor=colorRGBA5;
    
    
    self.iskang=[[UISwitch alloc] initWithFrame:CGRectMake(255,  a+51.5, 100, 15)];
    [self.iskang setOnTintColor:[UIColor colorWithRed:1/255.0 green:136/255.0 blue:204/255.0 alpha:1]];
    
    
    
    UIView *line2=[[UIView alloc] initWithFrame:CGRectMake(0, 90+a, 320, 0.5)];
    line2.backgroundColor=colorRGBA3;
    [self.view addSubview:line2];
    
    
    
    [self.view addSubview:self.drugname];
    [self.view addSubview:imgview];
    [self.view addSubview:self.startbtn];
    [self.view addSubview:self.endbtn];
    [self.view addSubview:lineview];
    //  [self.view addSubview:isdrug];
    [self.view addSubview:nodrug];
    [self.view addSubview:self.iskang];

    
    [self initfootview];

}
-(void)reloadTimebtn{
    int a=64;
    float stitlewidth=[self getWeight:startTime];
    float etitlewidth=[self getWeight:endTime];
    
    [UIView animateWithDuration:0.8 animations:^{
        self.startbtn.frame=CGRectMake(10+30, a+55, stitlewidth, 25);
        self.endbtn.frame=CGRectMake(40+stitlewidth+3, a+55, etitlewidth, 25);
        

    }];

}
-(void)initfootview{
    self.footview=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, 320, 286)];
    self.footview.backgroundColor=[UIColor whiteColor];
    
    //bar
   barview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 49)];
    barview.image=[UIImage imageNamed:@"bar640×99@2x"];
    barview.userInteractionEnabled=YES;
    [self.footview addSubview:barview];
    
    
    /******************分割线*******************/
    UIView *fline1=[[UIView alloc] initWithFrame:CGRectMake(0, 49, 320, 0.65)];
    fline1.backgroundColor=colorRGBA3;
    [self.footview addSubview:fline1];
    
    
    
   // [self.footview addSubview:self.mypickview];
    
//    self.yeardatas=[NSMutableArray arrayWithCapacity:30];
//    self.mondatas=[NSMutableArray arrayWithCapacity:12];
//    self.daydatas=[NSMutableArray arrayWithCapacity:30];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSString *dateString=@"2021-12-30";
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    

    
    
    

    datapick=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, 50+45, 400,  286-95)];
     NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    datapick.locale=locale;
    
    datapick.maximumDate=destDate;
    datapick.datePickerMode=UIDatePickerModeDate;
    [self.footview addSubview:datapick];

    
    UIButton *btnbar1=[UIButton buttonWithType:UIButtonTypeCustom];
    btnbar1.frame=CGRectMake(20, 15.5, 40, 18);
    btnbar1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft|UIControlContentHorizontalAlignmentFill;
    btnbar1.titleLabel.textAlignment=NSTextAlignmentLeft;
    btnbar1.titleLabel.font=[UIFont systemFontOfSize:18];
    [btnbar1 setTitleColor:colorText forState:JNormal];
    [btnbar1 setTitle:@"取消" forState:JNormal];
    [btnbar1 addTarget:self action:@selector(btnbar1) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *btnbar2=[UIButton buttonWithType:UIButtonTypeCustom];
    btnbar2.frame=CGRectMake(260, 15.5, 40, 18);
    [btnbar2 addTarget:self action:@selector(btnbar2) forControlEvents:UIControlEventTouchUpInside];
    btnbar2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight|UIControlContentHorizontalAlignmentFill;
    btnbar2.titleLabel.textAlignment=NSTextAlignmentLeft;
    btnbar2.titleLabel.font=[UIFont systemFontOfSize:18];
    [btnbar2 setTitle:@"完成" forState:JNormal];
    [btnbar2 setTitleColor:colorText forState:JNormal];
    [barview addSubview:btnbar1];
    [barview addSubview:btnbar2];
    
   btnbar3=[UIButton buttonWithType:UIButtonTypeCustom];
    btnbar3.frame=CGRectMake(140, 15.5, 40, 18);
    btnbar3.titleLabel.textAlignment=NSTextAlignmentLeft;
    btnbar3.titleLabel.font=[UIFont systemFontOfSize:18];
    [btnbar3 setTitleColor:colorText forState:JNormal];
    [btnbar3 setTitle:@"至今" forState:JNormal];
    [btnbar3 addTarget:self action:@selector(btnbar3) forControlEvents:UIControlEventTouchUpInside];

   
    
    
    self.timebtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.timebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[self.timebtn addTarget:self action:@selector(timedone) forControlEvents:UIControlEventTouchUpInside];
    self.timebtn.titleLabel.font=[UIFont systemFontOfSize:17.5];
    [self.timebtn setTitle:@"开始时间" forState:UIControlStateNormal];
    self.timebtn.frame=CGRectMake(120, 15+49, 80, 30);
    [self.footview addSubview:self.timebtn];
    
    [self.view addSubview:self.footview];
    
    
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


#pragma mark-pickdelegate
// returns the number of 'columns' to display.

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
}


#pragma mark-开始时间
-(void)addstarttime{
    if (btnbar3.superview==barview) {
        [btnbar3 removeFromSuperview];

    }
    
    
    [self.drugname resignFirstResponder];
    
    
    if (taskcount<1) {
    
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温情提示" message:@"请确定药物名称" delegate:self cancelButtonTitle:@"我忘记了" otherButtonTitles:@"马上去确定",nil];
        [alert show];
    }
    else{
        
     
        if ([self.startbtn.currentTitle isEqualToString:@"开始时间"]) {
            
        }
        else{
            NSString *str=self.startbtn.currentTitle;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *date=[dateFormatter dateFromString:str];
            [datapick setDate:date];
            
            
            
        }

        
        
    [self.timebtn setTitle:@"开始时间" forState:JNormal];
    [UIView animateWithDuration:0.5 animations:^{
        self.footview.frame=CGRectMake(0, SCREEN_HEIGHT-286, 320, 286);

    } completion:^(BOOL finished) {
        
    }];
    }
    
}
-(void)addstarttime2{
    if (btnbar3.superview==barview) {
        
    }
    else {
        [barview addSubview:btnbar3];
        
    }
    
    
    [self.drugname resignFirstResponder];
    [self.timebtn setTitle:@"停药时间" forState:JNormal];
    
    
    if ([self.endbtn.currentTitle isEqualToString:@"~停药时间"]) {
        NSLog(@"aaa");
    }
    else{
        if ([self.endbtn.currentTitle isEqualToString:@"~至今"]) {
            
        }
        else{
            NSString *str=[self.endbtn.currentTitle substringFromIndex:1];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date=[dateFormatter dateFromString:str];
        [datapick setDate:date];
        }
        
        
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.footview.frame=CGRectMake(0, SCREEN_HEIGHT-286, 320, 286);
    } completion:^(BOOL finished) {
    }];
    
    
}
#pragma mark-完成取消
//至今
-(void)btnbar3{
    if ([self.timebtn.currentTitle isEqualToString:@"停药时间"]){
        [UIView animateWithDuration:0.5 animations:^{
            [self.footview setFrame:CGRectMake(0, SCREEN_HEIGHT, 320, 286)];
            
            
        }];
        
        endTime=@"~至今";
        [self.endbtn setTitle:@"~至今" forState:JNormal];
        
        [self reloadTimebtn];
        
            [self.rightbtn setEnabled:YES];
       
        
        
    }

}
-(void)btnbar2{
    
    NSDate *date2=[datapick date];
    NSDate *date3=[NSDate date];
    NSTimeInterval k1=[date2 timeIntervalSince1970];
    NSTimeInterval k2=[date3 timeIntervalSince1970];
    {
    NSDate *date=[datapick date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
        NSString *destDateString2 = [dateFormatter stringFromDate:date];

    }
    if (k1>k2) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"不要穿越" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"了解", nil];
        [alert show];
        
    }
    else{
        
        
        
    taskcount++;
    
    NSDate *date=[datapick date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    if ([self.timebtn.currentTitle isEqualToString:@"开始时间"]) {
        startTime=destDateString;
        [self.startbtn setTitle:startTime forState:JNormal];

    }
    else if ([self.timebtn.currentTitle isEqualToString:@"停药时间"] ){
        endTime=[NSString stringWithFormat:@"~%@",destDateString];
        [self.endbtn setTitle:endTime forState:JNormal];
        
    
    }

    [self reloadTimebtn];
    
    
    if ([self.timebtn.currentTitle isEqualToString:@"开始时间"]) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.footview setFrame:CGRectMake(0, SCREEN_HEIGHT, 320, 286)];
            
        } completion:^(BOOL finished) {
            if (btnbar3.superview==barview) {
                
            }
            else {
                [barview addSubview:btnbar3];
                
            }

            [self.timebtn setTitle:@"停药时间" forState:JNormal];

            [UIView animateWithDuration:0.5 animations:^{
                [self.footview setFrame:CGRectMake(0, SCREEN_HEIGHT-286, 320, 286)];

            }];
            
        }];
    }
    
    else if ([self.timebtn.currentTitle isEqualToString:@"停药时间"]){
        [UIView animateWithDuration:0.5 animations:^{
            [self.footview setFrame:CGRectMake(0, SCREEN_HEIGHT, 320, 286)];

            
        }];
        
        
        
        if (taskcount>=3) {
            
            [self.rightbtn setEnabled:YES];
            
        }
        if ([self getMoretimesize]) {
            [self.rightbtn setEnabled:YES];
        }
        else{
            [self.rightbtn setEnabled:NO];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"停止时间不能小于开始用药时间" delegate:self cancelButtonTitle:@"重新填" otherButtonTitles:nil, nil];
            [alert show];
        }


        
        
    }
    
    }
}
//取消
-(void)btnbar1{
    [UIView animateWithDuration:0.5 animations:^{
        [self.footview setFrame:CGRectMake(0, SCREEN_HEIGHT, 320, 286)];
    }];
}


#pragma mark-获取文字长度
-(CGFloat)getWeight:(NSString *)str{
    //    NSDictionary* attrs =@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:17.5]};
    NSDictionary* attrs =@{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    
    NSAttributedString *newatt=[[NSAttributedString alloc] initWithString:str attributes:attrs];
    CGRect rect=[newatt boundingRectWithSize:CGSizeMake(MAXFLOAT, 25) options:NSStringDrawingTruncatesLastVisibleLine context:nil];
    CGSize titleSize=rect.size;
    return titleSize.width;
    
    
}



#pragma mark-键盘*************************************
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温情提示" message:@"您所填的写的药物名称没有被收录，请选择提示标签中的药物名称。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];

    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.5 animations:^{
        self.footview.frame=CGRectMake(0,SCREEN_HEIGHT, 320, 286);
        
    } completion:^(BOOL finished) {
        
    }];
    isdisplay=0;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChange:)           name:UITextFieldTextDidChangeNotification object:self.drugname];
    return YES;
}


#pragma mark-时时更新数据
- (void)textFieldDidChange:(NSNotification *)note
{
    float hhhh=0;
    
    if (SCREEN_HEIGHT==480) {
        hhhh=80;
    }
    else{
        hhhh=160;
        
    }
    float a=64;
    [drugalert removeFromSuperview];
    drugalert=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 90+a, 320, hhhh)];
    drugalert.backgroundColor=[UIColor whiteColor];
    drugalert.contentSize=CGSizeMake(320, 200);
    drugalert.showsVerticalScrollIndicator=YES;
    drugalert.showsHorizontalScrollIndicator=YES;
    
    // [drugalert flashScrollIndicators];
    [self.view addSubview:drugalert];
    
    
    [self addTAG];
    
    
   
}
-(void)addTAG{
    if (self.drugname.text.length==0) {
        
    }
    else{
        
        //que/getabstractlist
        
        NSString *url = [NSString stringWithFormat:@"%@med/keywords",Baseurl];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSString *yzuid=[UIDTOKEN getme].uid;
        NSString *yztoken=[UIDTOKEN getme].token;
        
        NSString *uurl=[NSString stringWithFormat:@"%@?uid=%@&token=%@&keywords=%@",url,yzuid,yztoken,self.drugname.text];
        
        uurl=[uurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@",uurl);
        
        
        NSDictionary *dic=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:yzuid,yztoken,self.drugname.text,nil] forKeys:[NSArray arrayWithObjects:@"uid",@"token",@"keywords",nil]];
        
        
        [manager POST:uurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            
            int res=[[source objectForKey:@"res"] intValue];
            
            NSLog(@"res=%d",res);
            
            if (res==0) {
                //请求完成
                NSArray *myarray=[source objectForKey:@"list"];
                
                if (myarray.count==0) {
                    
                }
                else{
                    NSMutableArray *keyArray=[NSMutableArray arrayWithCapacity:10];
                    self.keynewArray=[NSMutableArray arrayWithCapacity:10];
                    
                    for (int k=0; k<myarray.count; k++) {
                        NSDictionary *dic =[myarray objectAtIndex:k];
                        Newdrug *newobj=[[Newdrug alloc] init];
                        
                        NSString *str=[dic objectForKey:@"brandname"];
                        NSString *myid=[dic objectForKey:@"id"];
                        newobj.drugname=str;
                        newobj.myid=myid;
                        [self.keynewArray addObject:newobj];
                        [keyArray addObject:str];
                        
                    }
                    
                    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"length" ascending:YES];//其中，price为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
                    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
                    
                    
                    [keyArray sortUsingDescriptors:sortDescriptors];
                    
                    
                    if (isdisplay==1) {
                        
                    }
                    else{
                        [self addBTNs:keyArray];
                    }
                    
                }
                
                
                
                
            }
            else if (res==14){
            }
            else{
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
        
    }

}
-(void)addBTNs:(NSArray *)array{
    //按钮进行排版
    for (UIView *a in drugalert.subviews) {
        if ([a isKindOfClass:[UIButton class]]) {
            [a removeFromSuperview];
            
        }
    }
    xxxx=10;
    newrows=0;
    
    for (int i=0; i<array.count; i++) {
        
        NSString *title=array[i];
        CGSize size=[self get:title];
        CGSize size2;
        if (i!=array.count-1) {
            NSString *title2=array[i+1];
            size2=[self get:title2];
        }
        int nextw=size2.width+20;
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:colorRGBA5 forState:JNormal];
        btn.backgroundColor=colorRGBA8;
        [btn setTitle:title forState:UIControlStateNormal];
        btn.layer.cornerRadius=5;
        btn.frame=CGRectMake(xxxx, 10+45*newrows, size.width+20, 35);
        [btn addTarget:self action:@selector(kkkkkk:) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [drugalert addSubview:btn];
        int  ppppp=size.width+20 +10+xxxx+nextw  ;
        if (ppppp>310) {
            xxxx=10;
            newrows++;
        }
        else{
            xxxx=size.width+20 +10+xxxx;
        }
        
    }
    drugalert.contentSize=CGSizeMake(320, 10+(newrows+1)*45+10);
    
   
    
}
-(CGSize)get:(NSString *)title{
    NSDictionary* attrs =@{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    NSAttributedString *newatt=[[NSAttributedString alloc] initWithString:title attributes:attrs];
    CGRect rect=[newatt boundingRectWithSize:CGSizeMake(MAXFLOAT, 18) options:NSStringDrawingTruncatesLastVisibleLine context:nil];
    CGSize titleSize=rect.size;
    return titleSize;
}

#pragma mark-触发tag
-(void)kkkkkk:(UIButton *)btn{
    
    
    [drugalert removeFromSuperview];
    isdisplay=1;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    
    [self.drugname resignFirstResponder];
    
    
    //完成进度+1
    taskcount++;
    self.drugname.text=btn.currentTitle;
    //开始弹出 开始时间
    if (taskcount>=3) {
        
    }
    else{
        [self addstarttime];
    }
    
    
    
    
}
-(BOOL)getMoretimesize{
    int key=0;
    
    if ([endTime isEqualToString:@"~停药时间"]) {
        key=0;

        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温情提示" message:@"亲,您还没有填写停药时间" delegate:self cancelButtonTitle:@"我忘记了" otherButtonTitles:@"马上去确定",nil];
        [alert show];
    }
    else if([startTime isEqualToString:@"开始时间"]){
        key=0;

        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温情提示" message:@"亲,您还没有填写开始时间" delegate:self cancelButtonTitle:@"我忘记了" otherButtonTitles:@"马上去确定",nil];
        [alert show];

    }
    
    else{
        
        NSString *tmpendtime=[endTime substringFromIndex:1];
        
        
        if ([startTime isEqualToString:tmpendtime]) {
            key=1;
        }
        else{
            
        
            if ([endTime isEqualToString:@"~至今"]) {
                key=1;
                return YES;
            }
            else{
            
       
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat: @"yyyy-MM-dd"];
            
            
            
            
            NSDate *endstr= [dateFormatter dateFromString:tmpendtime];
            NSDate *startstr= [dateFormatter dateFromString:startTime];
            
            
            NSTimeInterval difference=[endstr timeIntervalSince1970]-[startstr timeIntervalSince1970];
            
            
            if (difference>=0) {
                key=1;
            }
            else {
                key=0;
            }
            
            }
        }
        

    
    
    
    
    
    }
    
    
    NSString *s1=@"2014-01-28";
    NSString *s2=@"2013-02-01";
    
    NSLog(@"%d",s2>s1);
    NSLog(@"%d",s1>s2);

    
    return key;
}
-(void)cleancache{
    if ([UserD objectForKey:@"aboutcard"] !=NULL) {
        [[TMDiskCache sharedCache] removeObjectForKey:[UserD objectForKey:@"aboutcard"]];
    }
    if ([UserD objectForKey:@"cardurl"] !=NULL) {
        [[TMDiskCache sharedCache] removeObjectForKey:[UserD objectForKey:@"cardurl"]];
    }
}

-(void)backaaa{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
