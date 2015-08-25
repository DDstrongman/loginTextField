//
//  CurrentileViewController.m
//  Yizhen
//
//  Created by ramy on 14-3-15.
//  Copyright (c) 2014年 jpx. All rights reserved.
// 添加当前疾病


#import "CurrentileViewControllerTwo.h"
#import "CurrentileCell.h"
#import "AFNetworking.h"
#import "TMCache.h"

@interface CurrentileViewControllerTwo ()

@end

@implementation CurrentileViewControllerTwo

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillDisappear:(BOOL)animated{
    
    
    
    [super viewWillDisappear:animated];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initnavBar];//1
    
    
    self.view.backgroundColor=[UIColor whiteColor];//1
    [self initDataSource];//1
    self.currentArray=[NSMutableArray array];
    
    
    [self initview];
    
    
}
#pragma mark- >_<|*************************|>_<
#pragma mark-完成
-(void)myright{
    if (self.block) {
        //把当前的数组传过去
        NSLog(@"%@",self.currentArray);
        
        self.block(self.currentArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    if ([UIDTOKEN getme].BASICurl!=NULL) {
        [[TMDiskCache sharedCache] removeObjectForKey:[UIDTOKEN getme].BASICurl];
        
    }
    [self posturl];
}
#pragma mark- 导航栏
-(void)initnavBar{
    
    [self setNewbarTitle:@"病史" andbackground:IMAGE(@"new128")];
    [self setNewbarLeftTitle:@"取消"];
    [self setNewbarRightTitle:@"完成"];
    self.rightbtn.enabled=YES;
    
    

//    int status=20;
//    
//    
//    self.newnavbar=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
//    self.newnavbar.userInteractionEnabled=YES;
//    self.newnavbar.image=[UIImage imageNamed:@"new128"];
//    [self.view addSubview:self.newnavbar];
//    //17.5
//    
//    
//    
//    UIFont *font=[UIFont fontWithName:@"Helvetica-Bold" size:17.5];
//    
//    CGSize titleSize = [@"基本情况"  sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, 18)];
//    
//    
//    
//    UILabel *titlelabel=[[UILabel alloc] initWithFrame:CGRectMake((320-titleSize.width)/2, 13+status, titleSize.width, 18)];
//    titlelabel.textColor=[UIColor colorRGBA1];
//    titlelabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:17.5];
//    titlelabel.text=@"基本情况";
//    [self.newnavbar addSubview:titlelabel];
//    
//    
//    
//    
//    
//    UIButton *canbtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    canbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft|UIControlContentHorizontalAlignmentFill;
//    canbtn.titleLabel.textAlignment=NSTextAlignmentLeft;
//    canbtn.titleLabel.font=[UIFont systemFontOfSize:17.5];
//    [canbtn setTitleColor:[UIColor colorRGBB9] forState:UIControlStateNormal];
//    [canbtn setEnlargeEdgeWithTop:10 right:20 bottom:10 left:10];
//    
//    [canbtn setTitle:@"取消" forState:UIControlStateNormal];
//    canbtn.frame=CGRectMake(10, status+13, 40, 18);
//    [self.newnavbar addSubview:canbtn];
//    [canbtn addTarget:self action:@selector(tap1) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    
//    UIButton *  savelabel=[UIButton buttonWithType:UIButtonTypeCustom];
//    savelabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight|UIControlContentHorizontalAlignmentFill;
//    savelabel.titleLabel.textAlignment=NSTextAlignmentLeft;
//    savelabel.titleLabel.font=[UIFont systemFontOfSize:17.5];
//    [savelabel setTitleColor:[UIColor colorRGBB9] forState:UIControlStateNormal];
//    [savelabel setTitle:@"完成" forState:UIControlStateNormal];
//    [savelabel setEnlargeEdgeWithTop:10 right:10 bottom:10 left:20];
//    
//    
//    savelabel.frame=CGRectMake(275, status+13, 35, 18);
//    [self.newnavbar addSubview:savelabel];
//    [savelabel addTarget:self action:@selector(tap2) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark-完成
-(void)tap2{
    
    if (self.block) {
        self.block(self.currentArray);
        
    }
    
    
    
    
    [self posturl];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
#pragma mark-取消
-(void)tap1{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}

-(void)initview{
    int t=64;
    
    float screen=SCREEN_HEIGHT;
    
    
    self.contentview=[[UIScrollView alloc] initWithFrame:CGRectMake(0, t, 320, SCREEN_HEIGHT-t)];
    
    [self.view addSubview:self.contentview];
    
    
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(15, 10, 140, 14)];
    label.font=[UIFont systemFontOfSize:14];
    label.textColor=colorRGBA4;
    label.text=@"病史";
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor blackColor];
    [self.contentview addSubview:label];
    
    
    //10 +14 +9
    
    
    
    //创建默认按钮  第一次启动的时候
    self.mybtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 33, 147, 34)];
    [self.mybtn setBackgroundImage:[UIImage imageNamed:@"添加2"] forState:UIControlStateNormal];
    [self.contentview addSubview:self.mybtn];
    
    float th=0;
    if (self.mydatas.count*45+78>=screen-64) {
        th=screen-64-78;
    }
    else{
        th=self.mydatas.count*45;
        
    }
    
    
    self.mytableview=[[UITableView alloc] initWithFrame:CGRectMake(0,78, 320,th)];
    self.mytableview.dataSource=self;
    self.mytableview.delegate=self;
    //self.mytableview.scrollEnabled=NO;
    [self setExtraCellLineHidden:self.mytableview];
    
    
    [self.contentview addSubview:self.mytableview];
    
    
    //147  上下 5  高度 34   距离疾病 9
    
    //10  33+34 +10  线 +tableview
    
    
    
    [self.currentArray removeAllObjects];
    for (NSString *str in self.oneArray) {
        [self.currentArray addObject:str];
        
    }
    
    
    [self initcurrentview];
    
    
    
    
    
    
    
    
    
    
    
    
}
-(void)initDataSource{
    
    
    //第一次启动的情况下
    self.mydatas=[NSMutableArray arrayWithCapacity:10];
    
    
    NSMutableArray *fuben=[NSMutableArray arrayWithCapacity:20];
    
    
    
    
    [self.mydatas addObject:@"大三阳肝炎"];
    [self.mydatas addObject:@"大三阳携带"];
    [self.mydatas addObject:@"小三阳肝炎"];
    [self.mydatas addObject:@"小三阳携带"];
    [self.mydatas addObject:@"丙肝"];
    [self.mydatas addObject:@"肝纤维化"];
    [self.mydatas addObject:@"肝硬化（失代偿期）"];
    [self.mydatas addObject:@"肝硬化（代偿期）"];
    [self.mydatas addObject:@"脂肪肝"];
    [self.mydatas addObject:@"酒精肝"];
    [self.mydatas addObject:@"肝癌"];
    [self.mydatas addObject:@"药物性肝炎"];
    [self.mydatas addObject:@"肝衰竭"];
    for (NSString *s in self.mydatas) {
        
        NSLog(@"%@",s);
        [fuben addObject:s];
        
    }
    
    for (int i=0; i<self.oneArray.count; i++) {
        NSString *str=[self.oneArray objectAtIndex:i];
        for (int j=0; j<fuben.count; j++) {
            if ([str isEqualToString:[fuben objectAtIndex:j]]) {
                [self.mydatas removeObject:str];
            }
        }
    }
    NSLog(@"self.mydatas.count=%d",self.mydatas.count);
    
}
#pragma mark-dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.mydatas.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"mycell";
    CurrentileCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[CurrentileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    cell.mybtn.tag=indexPath.row;
    [cell.mybtn addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    cell.mylabel.text=[self.mydatas objectAtIndex:indexPath.row];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    return cell;
    
}

//隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    tableView.separatorColor=colorRGBA3;
    UIView *view =[ [UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 5)];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:[SplitLineView getview:0 andY:4.4 andW:320]];
    
    UIView *view2 =[ [UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 5)];
    view2.backgroundColor = [UIColor whiteColor];
    [view2 addSubview:[SplitLineView getview:0 andY:0 andW:320]];
    
    [tableView setTableFooterView:view2];
    [tableView setTableHeaderView:view];
}

#pragma mark-视图刷新
-(void)reloadcontentview:(NSString *)str{
    
    
    NSMutableArray *myarray=[NSMutableArray arrayWithCapacity:10];
    
    
    
    for (UIView *btn in self.contentview.subviews ) {
        if ([btn isKindOfClass:[UIButton class]]) {
            
            [myarray addObject:btn];
            
            
        }
    }
    
    [UIView animateWithDuration:0.8 animations:^{
        
        
        UIButton *sbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [sbtn setTitle:str forState:UIControlStateNormal];
        [sbtn setTitleColor:colorRGBA4 forState:JNormal];
        sbtn.titleLabel.font=[UIFont systemFontOfSize:14];
        sbtn.layer.cornerRadius=5;
        sbtn.backgroundColor=colorRGBA8;
        [sbtn addTarget:self action:@selector(mydisplay:) forControlEvents:UIControlEventTouchUpInside];
        
        sbtn.frame=CGRectMake(10, 33, 147, 34);
        [self.contentview addSubview:sbtn];
        
        
        int total=myarray.count-1;
        
        
        
        int a=myarray.count;
        
        int newh=0;
        
        newh=34+44+39*(a/2);
        NSLog(@"newh=%d",newh);
        
        float screen=SCREEN_HEIGHT;
        
        
        float th=0;
        if (self.mydatas.count*45+newh>=screen-64) {
            th=screen-64-newh;
        }
        else{
            th=self.mydatas.count*45;
            
        }
        
        self.mytableview.frame=CGRectMake(0,newh, 320,th);
        
        
        
        
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

-(void)add:(UIButton *)btn{
    
    NSString *str=[self.mydatas objectAtIndex:btn.tag];
    [self.currentArray addObject:str];
    
    
    [self reloadcontentview:str];
    [self.mydatas removeObject:str];
    [self performSelector:@selector(reload) withObject:nil afterDelay:0.05];
    
}

-(void)initcurrentview{
    
    //在有值的情况下 去添加
    for (int i=0; i<self.currentArray.count; i++) {
        
        [self reloadcontentview:self.currentArray[i]];
        
        
    }
    
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CurrentileCell *cell=(CurrentileCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    NSString *str=[self.mydatas objectAtIndex:cell.mybtn.tag];
    [self.currentArray addObject:str];
    [self reloadcontentview:str];
    [self.mydatas removeObject:str];
    
    
    [self performSelector:@selector(reload) withObject:nil afterDelay:0.05];
    
}
-(void)mydisplay:(UIButton *)btn{
    self.delectstr=btn.currentTitle;
    NSString *str=self.delectstr;
    [self.currentArray removeObject:self.delectstr];
    [self.mydatas addObject:str];
    NSLog(@"--%d",self.mydatas.count);
    
    [self reloadcontentviewdelect];
    //    UIActionSheet *actionsheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"取消选择" otherButtonTitles:@"搜索问答库", nil];
    //    [actionsheet showInView:self.view];
    //
    
}

#pragma mark-UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //取消选择 0
    
    
    
    if (buttonIndex==0) {
        
        //删除时会报错
        NSString *str=self.delectstr;
        [self.currentArray removeObject:self.delectstr];
        [self.mydatas addObject:str];
        
        [self reloadcontentviewdelect];
        
        
        
        
    }
    else if (buttonIndex==1){
        
        
        SearchViewController *sVC=[[SearchViewController alloc] init];
        sVC.searchstr=self.delectstr;
        
        [self.navigationController pushViewController:sVC animated:YES];
        
    }
    
    
    
}

-(void)reloadcontentviewdelect{
    
    
    NSMutableArray *myarray=[NSMutableArray arrayWithCapacity:10];
    
    
    
    for (UIButton *btn in self.contentview.subviews ) {
        if ([btn isKindOfClass:[UIButton class]]) {
            
            if ([btn.currentTitle isEqualToString:self.delectstr]) {
                [btn removeFromSuperview];
                
            }
            
            else{
                [myarray addObject:btn];
            }
            
        }
    }
    int total=myarray.count-1;
    
    [UIView animateWithDuration:0.8 animations:^{
        
        
        
        
        int a=myarray.count;
        
        int newh=0;
        
        newh=34+44+39*((a-1)/2);
        
        float screen=SCREEN_HEIGHT;
        
        
        float th=0;
        if (self.mydatas.count*45+newh>=screen-64) {
            th=screen-64-newh;
        }
        else{
            th=self.mydatas.count*45;
            
        }
        
        self.mytableview.frame=CGRectMake(0,newh, 320,th);
        
        [self.mytableview reloadData];
        
        NSLog(@"total==%d",total);
        
        for (int i=total; i>=0; i--) {
            
            
            UIButton *btn=myarray[i];
            
            
            int xxx;
            if ((total-i)%2==0) {
                xxx=10;
                
            }
            else{
                xxx=163;
                
            }
            
            
            int yyy;
            yyy=(total-i)/2*39+33;
            
            btn.frame=CGRectMake(xxx, yyy, 147, 34);
            
            
            
            
        }
        
        /* for (int i=total; i>=0; i--) {
         
         
         UIButton *btn=myarray[i];
         
         
         
         if (i==total) {
         btn.frame=CGRectMake(10, 33, 147, 34);
         
         }
         else if (i==total-1){
         btn.frame=CGRectMake(163, 33, 147, 34);
         
         
         }
         else if (i==total-2){
         
         btn.frame=CGRectMake(10, 33+34+5, 147, 34);
         
         }
         else if (i==total-3){
         
         btn.frame=CGRectMake(163, 33+34+5, 147, 34);
         
         }
         else if (i==total-4){
         
         btn.frame=CGRectMake(10, 33+34+5+34+5, 147, 34);
         
         }
         else if (i==total-5){
         
         btn.frame=CGRectMake(163, 33+34+5+34+5, 147, 34);
         
         }
         
         }*/
    }];
    
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
    
}
-(void)reload{
    [self.mytableview reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark--post
#pragma mark-想服务器
-(void)posturl{
    NSMutableArray *keyarray2=[NSMutableArray arrayWithCapacity:10];
    for (int i=0; i<self.currentArray.count; i++) {
        NSString *str=[self.currentArray objectAtIndex:i];
        if ([str isEqualToString:@"大三阳肝炎"]) {
            [keyarray2 addObject:@"1"];
        }
        else if ([str isEqualToString:@"大三阳携带"]){
            [keyarray2 addObject:@"2"];
        }
        else if ([str isEqualToString:@"小三阳肝炎"]){
            [keyarray2 addObject:@"3"];
        }
        else if ([str isEqualToString:@"小三阳携带"]){
            [keyarray2 addObject:@"4"];
        }
        else if ([str isEqualToString:@"丙肝"]){
            [keyarray2 addObject:@"5"];
        }
        else if  ([str isEqualToString:@"肝纤维化"]){
            [keyarray2 addObject:@"6"];
        }
        else if  ([str isEqualToString:@"肝硬化（失代偿期）"]){
            [keyarray2 addObject:@"7"];
        }
        
        else if  ([str isEqualToString:@"肝硬化（代偿期）"]){
            [keyarray2 addObject:@"8"];
        }
        else if  ([str isEqualToString:@"脂肪肝"]){
            [keyarray2 addObject:@"9"];
        }
        else if  ([str isEqualToString:@"酒精肝"]){
            [keyarray2 addObject:@"10"];
        }
        else if  ([str isEqualToString:@"肝癌"]){
            [keyarray2 addObject:@"11"];
        }
        else if  ([str isEqualToString:@"药物性肝炎"]){
            [keyarray2 addObject:@"12"];
        }
        else if  ([str isEqualToString:@"肝衰竭"]){
            [keyarray2 addObject:@"13"];
        }
    }
    [self setiles:keyarray2];
}
-(void)setiles:(NSMutableArray *)array{
    
    HUD = [[MBProgressHUD alloc] initWithView:JWindow];
	[JWindow addSubview:HUD];
    
    
    NSString *url = [NSString stringWithFormat:@"%@und/edit",Baseurl];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    
    NSMutableString *mystring=[NSMutableString string];
    for (int i=0; i<array.count; i++) {
        if (i==array.count-1) {
            [mystring appendString:[NSString stringWithFormat:@"%@",array[i]]];
            
        }
        else{
            [mystring appendString:[NSString stringWithFormat:@"%@_",array[i]]];
            
        }
        
    }
    if ([mystring isEqualToString:@""]) {
        [mystring appendString:@"0"];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uurl=[NSString stringWithFormat:@"%@?uid=%@&token=%@&category=%@&did=%@",url,[defaults objectForKey:@"userUID"],[defaults objectForKey:@"userToken"],@"1",mystring];
    
    
    uurl=[uurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",uurl);
    
    
    [manager POST:uurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resdic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        int res=[[resdic objectForKey:@"res"] integerValue];
        
        if (res==0) {
            NSLog(@"更新成功");
        }
        else{
            HUD.mode = MBProgressHUDModeText;
            HUD.delegate = self;
            HUD.labelText = @"更新失败";
            [HUD show:YES];
            [HUD hide:YES afterDelay:1];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        HUD.mode = MBProgressHUDModeText;
        HUD.delegate = self;
        HUD.labelText = @"更新失败";
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
    }];
    

}

-(void)deleteill:(NSMutableArray *)array{
    NSString *url = [NSString stringWithFormat:@"%@und/delete",Baseurl];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *yzuid=[user objectForKey:@"myuid"];
    NSString *yztoken=[user objectForKey:@"mytoken"];
    //  NSLog(@"%@-%@",yztoken,yzuid);
    
    
    
    NSMutableString *did=[[NSMutableString alloc] init];
    
    
    
    for (int i=0; i<array.count; i++) {
        NSString *str;
        
        if (i==array.count-1) {
            str=[NSString stringWithFormat:@"%@",[array objectAtIndex:i]];
            
        }
        else{
            str=[NSString stringWithFormat:@"%@_",[array objectAtIndex:i]];
            
        }
        
        [did appendFormat:@"%@",str];
        
    }
    NSLog(@"did=%@",did);
    
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:yzuid,yztoken,did,@"1",nil] forKeys:[NSArray arrayWithObjects:@"uid",@"token",@"did",@"category",nil]];
    
    
    
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        
        int res=[[source objectForKey:@"res"] intValue];
        
        
        if (res==0) {
            //请求完成
            NSLog(@"dlee deee");
            
        }
        else if (res==14){
            
        }
        
        else{
            
            
        }
        
        
        
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        [self.view makeToast:@"当前网络已断开" duration:1 position:@"center"];
        
    }];
}

-(void)addile:(NSMutableArray *)array{
    NSString *url = [NSString stringWithFormat:@"%@und/create",Baseurl];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *yzuid=[user objectForKey:@"myuid"];
    NSString *yztoken=[user objectForKey:@"mytoken"];
    //  NSLog(@"%@-%@",yztoken,yzuid);
    
    
    
    NSMutableString *did=[[NSMutableString alloc] init];
    
    
    
    for (int i=0; i<array.count; i++) {
        [did appendFormat:@"%@_",[array objectAtIndex:i]];
        
    }
    NSLog(@"add===did=%@",did);
    
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:yzuid,yztoken,did,@"1",nil] forKeys:[NSArray arrayWithObjects:@"uid",@"token",@"did",@"category",nil]];
    
    
    
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        
        int res=[[source objectForKey:@"res"] intValue];
        
        
        if (res==0) {
            //请求完成
            NSLog(@"add success");
            
        }
        else if (res==14){
            
        }
        
        else{
            
            
        }
        
        
        
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
        
        [self.view makeToast:@"当前网络已断开" duration:1 position:@"center"];
    }];
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

@end
