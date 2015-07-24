//
//  HistoryViewController.m
//  Yizhen
//
//  Created by ramy on 14-3-15.
//  Copyright (c) 2014年 jpx. All rights reserved.
//

#import "HistoryViewController.h"
//#import "MainViewController.h"
#import "NewChangeViewController.h"

@interface HistoryViewController ()
{
    UIButton *btn;
    NSString *urlkey;
}
@property (nonatomic,strong)UIImageView *noImgview;

@end

@implementation HistoryViewController
-(void)addnoimage{
    
    
    UIImage *image=IMAGE(@"暂无用药历史.1");
    
    float ww=image.size.width;
    float hh=image.size.height;
    NSLog(@"%f",ww);
    
    
    self.mytableview.scrollEnabled=NO;
    [self.noImgview removeFromSuperview];
    self.noImgview=[[UIImageView alloc] initWithFrame:CGRectMake((160.0-(ww/2)/2.0), (self.mytableview.frame.size.height-64)/2-hh/2/2.0, ww/2, 154)];
    self.noImgview.image=image;
    self.mytableview.separatorColor=CLEARCOLOR;
    [self.mytableview addSubview:self.noImgview];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark- 导航栏
-(void)initnavBar{
   
    
    int status=20;
    self.newnavbar=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    self.newnavbar.userInteractionEnabled=YES;
    self.newnavbar.image=[UIImage imageNamed:@"new128"];
    [self.view addSubview:self.newnavbar];
    //17.5
    
    UIFont *font=[UIFont fontWithName:@"Helvetica-Bold" size:17.5];
    CGSize titleSize = [@"用药历史"  sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, 18)];
    
    UILabel *titlelabel=[[UILabel alloc] initWithFrame:CGRectMake((320-titleSize.width)/2, 13+status, titleSize.width, 18)];
    titlelabel.textColor=colorRGBA1;
    titlelabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:17.5];
    titlelabel.text=@"用药历史";
    [self.newnavbar addSubview:titlelabel];
    
    
    
    
    //
    UIButton *backbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backbtn setFrame:CGRectMake(10, status+12, 11, 20)];
    [backbtn setImage:[UIImage imageNamed:@"左箭头.1.png"] forState:UIControlStateNormal];
    backbtn.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 0);
    //    UIEdgeInsets insets = {top, left, bottom, right};
    [backbtn setEnlargeEdgeWithTop:20 right:50 bottom:20 left:11];
    
    [backbtn addTarget:self action:@selector(myleft) forControlEvents:UIControlEventTouchUpInside];
    [self.newnavbar addSubview:backbtn];
    
    
    
    //rightbtn
    btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight|UIControlContentHorizontalAlignmentFill;
    btn.titleLabel.textAlignment=NSTextAlignmentLeft;
    btn.titleLabel.font=[UIFont systemFontOfSize:17.5];
    [btn setTitleColor:colorText forState:UIControlStateNormal];
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    [btn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:20];
    btn.frame=CGRectMake(275, status+13, 35, 18);
    [self.newnavbar addSubview:btn];
    [btn addTarget:self action:@selector(mytap2) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}
-(void)mytap2{
    
    if ([btn.titleLabel.text isEqualToString:@"编辑"]) {
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        if (self.mydatas.count!=0) {
            
            if (alineview.superview ==aview) {
                [alineview removeFromSuperview];
                [aview addSubview:alineview];
            }
            else{
                //添加上面的一条线
                [alineview removeFromSuperview];
                
                [aview addSubview:alineview];
            }
            
        }
    }
    else {
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
        if (self.mydatas.count!=0) {
            
          
                //添加上面的一条线
                [alineview removeFromSuperview];
                
                [aview addSubview:alineview];
            
        }
    }
    
    [self.mytableview setEditing:!self.mytableview.editing animated:YES];
    
    
    
    
    
}

-(void)myleft{
    
    if(self.mytableview.isEditing==YES){
        [self.mytableview setEditing:NO animated:YES];
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
        [self performSelector:@selector(back) withObject:nil afterDelay:0.2];

    }
    
    else{
        [self performSelector:@selector(back) withObject:nil afterDelay:0];

    }
    
    
}
-(void)back{
    
    if (self.mychangedraw) {
        self.mychangedraw(self.ischange);
        
        
    }
    if (self.changedrug ) {
        self.changedrug(self.ischange);
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)viewWillDisappear:(BOOL)animated{
   // [(MLNavigationController *)self.navigationController setCanDragBack:YES];
    
    NSMutableString *hisnames=[[NSMutableString alloc] init];
    
    for (int i=0; i<self.mydatas.count; i++) {
        Drug *d=[self.mydatas objectAtIndex:i];
        NSString *name=d.name;
        [hisnames appendString:name];


    }
    if (self.qrblock) {
        self.qrblock(hisnames);
    }
    
    [super viewWillDisappear:animated];
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   // alineview=[SplitLineView getview:0 andY:0 andW:320];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.hidden=YES;
    
    self.tabBarController.tabBar.hidden=YES;
    [self initnavBar];
    
    self.ischange=0;
    
    
    [self inittabelview];
    
}

-(void)addObj:(Drug *)d{
    
    self.ischange=1;
    //[self update];
    [[TMDiskCache sharedCache] removeObjectForKey:urlkey];
    [self.mydatas insertObject:d atIndex:self.mydatas.count];
    [self.noImgview removeFromSuperview];
    NSIndexPath *indexpath=[NSIndexPath indexPathForRow:self.mydatas.count-1 inSection:0];
    
    if (self.mydatas.count!=0) {
        
        
        //添加上面的一条线
        [alineview removeFromSuperview];
        
        [aview addSubview:alineview];
        
    }
    [self.mytableview insertRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
    
    
    
    
    
    
}

-(void)inittabelview{
    
    
    
    
    int t=64;
    
    
    
    
    
    
    self.mytableview=[[UITableView alloc] initWithFrame:CGRectMake(0, t, 320, SCREEN_HEIGHT-t)];
    
    self.mytableview.delegate=self;
    self.mytableview.dataSource=self;
    self.mytableview.showsVerticalScrollIndicator=NO;
    //
    self.mytableview.separatorColor=CLEARCOLOR;
    self.mytableview.separatorColor=colorRGBA3;
    [self setadd];
    [self getdatasuorce];
    
    
    [self.view addSubview:self.mytableview];
    
    if ([self.mytableview respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.mytableview setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    
    
}
-(void)setadd{
    aview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    aview.backgroundColor=[UIColor whiteColor];
    
    UIView *line2=[[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, 0.5)];
    line2.backgroundColor=colorRGBA3;
    [aview addSubview:line2];
    UITapGestureRecognizer *mytap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mytap)];
    mytap.numberOfTapsRequired=1;
    [aview addGestureRecognizer:mytap];
    UIButton *btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame=CGRectMake(160-7, 13, 14, 14);
    [btn2 addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"用药历史加号"] forState:UIControlStateNormal];
    
    btn2.adjustsImageWhenHighlighted=NO;
    
    [aview addSubview:btn2];
    self.mytableview.tableFooterView=aview;
    

}
-(void)getdatasuorce{
    self.mydatas=[NSMutableArray arrayWithCapacity:10];
    
    [self.mydatas removeAllObjects];
    
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@emr/medicinemanagement/list",Baseurl];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval=15;
    
//    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
//    NSString *yzuid=[user objectForKey:@"myuid"];
//    NSString *yztoken=[user objectForKey:@"mytoken"];
    
    if (self.source==NULL) {
        self.source=@"1";
        
    }
    
#warning 暂时测试用，因为旧版的未给dictionary赋值
    [UIDTOKEN getme].uid = @"123test";
    [UIDTOKEN getme].token = @"123test";
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIDTOKEN getme].uid,[UIDTOKEN getme].token,self.source,nil] forKeys:[NSArray arrayWithObjects:@"uid",@"token",@"source",nil]];
    urlkey=[[NSURL URLWithString:[NSString stringWithFormat:@"%@?uid=%@&token=%@",url,[UIDTOKEN getme].uid,[UIDTOKEN getme].token]] absoluteString];
    id obj=[[TMDiskCache sharedCache] objectForKey:urlkey];
    if (obj==NULL) {
        //缓存现在
        [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            
            int res=[[source objectForKey:@"res"] intValue];

            //  NSLog(@"res=%d",res);
         
            
            if (res==0) {
                //请求完成
                [HUD hide:YES];

                [self tableviewreload:source];
            
                [[TMDiskCache sharedCache] setObject:source forKey:urlkey];
                
            }
            else if (res==14){
                
                [HUD hide:YES];
                [self addnoimage];
                [btn setEnabled:NO];
                [btn setTitleColor:colorRGBA5 forState:JNormal];
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
            
            [self.view makeToast:@"当前网络已断开" duration:1 position:@"center"];
            
            
            NSLog(@"网络出错");
            //  [self showerror];
            
            
            
            
            NSLog(@"error");
        }];
    }
    
    else{
        [HUD hide:YES];
        NSDictionary *source= (NSDictionary *)obj;
        
        
        
        [self tableviewreload:source];
        
        
    }
    
    
    
 
    
    
    
    
    
    
}
-(void)tableviewreload:(NSDictionary *)s{
    
    if ([s allKeys].count ==1) {
        NSLog(@"-没有历史");
        
    }
    else{
        
        NSArray *myarray=[s objectForKey:@"list"];
        
        
        for (NSDictionary *kkdic in myarray) {
            Drug *d=[[Drug alloc] init];
            NSString *name=[kkdic objectForKey:@"medicinename"];
            
            NSString *start=[kkdic objectForKey:@"begindate"];
            NSString *end=[kkdic objectForKey:@"stopdate"];
            NSString *mhid=[kkdic objectForKey:@"mhid"];
            BOOL kang=[[kkdic objectForKey:@"resistant"] boolValue];
            d.name=name;
            d.starttime=[NSString stringWithFormat:@"%@",start];
            d.endtime=end;
            d.iskang=kang;
            d.isuse=[[kkdic objectForKey:@"isuse"] intValue];
            d.mid=[kkdic objectForKey:@"mid"];
            d.mhid=mhid;
            [self.mydatas addObject:d];
            
            
            
            
        }
        
        
    }
    
    
    
    
    
    
    if (self.mydatas.count!=0) {
        
        if (alineview.superview ==aview) {
            
        }
        else{
        //添加上面的一条线
            [alineview removeFromSuperview];
            
        [aview addSubview:alineview];
        }
        
    }
    [self.mytableview reloadData];
    
}
-(void)mytap{
    [self add];
    
    [self.mytableview setEditing:NO animated:YES];
    [btn setTitle:@"编辑" forState:UIControlStateNormal];

    //  210219196805223410
    //  6230580000010928708
    
}
-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    [self initnavBar];
   // [(MLNavigationController *)self.navigationController setCanDragBack:NO];
    
    //[[MainViewController shandbasetabbarview].tabbarview setFrame:CGRectMake(0, SCREEN_HEIGHT, 320, 49)];
    NSLog(@"%d",self.mydatas.count);
    [super viewWillAppear:animated];
}


#pragma  mark-DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mydatas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"cell";
    HistroyCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[HistroyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    Drug *d=[self.mydatas objectAtIndex:indexPath.row];
    cell.namelab.text=d.name;
    
    if (d.iskang==1) {
        //1
        cell.l2.text=@"耐药";
    }
    else{
        cell.l2.text=@"不耐药";
        
    }
    
    
    float stitlewidth=[self getWeight:d.starttime];
    float etitlewidth=0;
    cell.starttime.text=d.starttime;
    cell.starttime.frame=CGRectMake(10, 36, stitlewidth, 16);


    
    
    
    

    if (d.isuse==1) {
        cell.endtime.text=[NSString stringWithFormat:@"~%@",@"至今"];
         etitlewidth=[self getWeight:@"~至今"];
            cell.endtime.frame=CGRectMake(10+stitlewidth+3, 36, etitlewidth, 16);

        
        
    
    }
    else{
        cell.endtime.text=[NSString stringWithFormat:@"~%@",d.endtime];
        etitlewidth=[self getWeight:[NSString stringWithFormat:@"~%@",d.endtime]];
        cell.endtime.frame=CGRectMake(10+stitlewidth+3, 36, etitlewidth, 16);

        
        
    }

    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 63;
}
#pragma mark-delegate  选中cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewChangeViewController *hischange=[[NewChangeViewController alloc] init];
    hischange.ind=indexPath;
    
    Drug *d=[self.mydatas objectAtIndex:indexPath.row];
   
    hischange.mydrug=d;
    
    hischange.changeblock=^(Drug *d, NSIndexPath *indexp){
        [self.mydatas replaceObjectAtIndex:indexp.row withObject:d];
        [[TMDiskCache sharedCache] removeObjectForKey:urlkey];
        self.ischange=1;
       // [self update];

        [self.mytableview reloadRowsAtIndexPaths:@[indexp] withRowAnimation:UITableViewRowAnimationFade];
    };
    [self.navigationController pushViewController:hischange animated:YES];
    
    
    
}


-(void)add{
//    AddingdrugsViewController *addVC=[[AddingdrugsViewController alloc] init];
//    addVC.delegate=self;
//    [self.navigationController pushViewController:addVC animated:YES];
   NewAddDrugViewController *addVC=[[NewAddDrugViewController alloc] init];
    addVC.delegate=self;
    
    [self.navigationController pushViewController:addVC animated:YES];
}

-(void)update{
//    NSNotification *notification=[NSNotification notificationWithName:@"CHANGEDRUG" object:self userInfo:[NSDictionary dictionaryWithObject:@"1" forKey:@"type"]];
//    [[NSNotificationCenter defaultCenter]postNotification:notification];
    

}
#pragma mark-编辑
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        [[TMDiskCache sharedCache] removeObjectForKey:urlkey];
       // [self update];
        
        Drug *drug=[self.mydatas objectAtIndex:indexPath.row];
        int mhid=[drug.mhid intValue];
        
        
        [self.mydatas removeObjectAtIndex:indexPath.row];
        [self.mytableview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (self.mydatas.count!=0) {
            
            if (alineview.superview ==aview) {
                [alineview removeFromSuperview];
                [aview addSubview:alineview];
            }
            else{
                //添加上面的一条线
                [alineview removeFromSuperview];
                
                [aview addSubview:alineview];
            }
            
        }

        [self.mytableview reloadData];
        
        //本地更新
        //网络请求
        
        [self getnetWorking:mhid];
        
    }
}
-(void)getnetWorking:(int)mhid{
    
    [self cleancache];

    self.ischange=1;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *yzuid=[user objectForKey:@"myuid"];
    NSString *yztoken=[user objectForKey:@"mytoken"];
    //  NSLog(@"%@-%@",yztoken,yzuid);
    
    NSString *url = [NSString stringWithFormat:@"%@emr/medicinemanagement/delete?uid=%@&token=%@&mhid=%@",Baseurl,yzuid,yztoken,[NSNumber numberWithInt:mhid]];
    
    NSLog(@"%@url",url);
    
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:yzuid,yztoken,[NSNumber numberWithInt:mhid],nil] forKeys:[NSArray arrayWithObjects:@"uid",@"token",@"mhid",nil]];
    
    
    
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"responseObject=%@",responseObject);
        
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        
        int res=[[source objectForKey:@"res"] intValue];
        
        //  NSLog(@"res=%d",res);
        NSLog(@"%@",source);
        
        if (res==0) {
            //请求完成
            NSLog(@"wanchneg");
            
            
            
            
        }
        else if (res==14){
        }
        else{
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:@"当前网络已断开" duration:1 position:@"center"];
    }];
    
    
    
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // btn.titleLabel.text=@"完成";
    
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    
    
}
-(void)cleancache{
    if ([UserD objectForKey:@"aboutcard"] !=NULL) {
        [[TMDiskCache sharedCache] removeObjectForKey:[UserD objectForKey:@"aboutcard"]];
        
    }
    if ([UserD objectForKey:@"cardurl"] !=NULL) {
        [[TMDiskCache sharedCache] removeObjectForKey:[UserD objectForKey:@"cardurl"]];
        
    }
    
}
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    // NSLog(@"ta==%d",tableView.editing);
    
    if (tableView.editing==0) {
        //  btn.titleLabel.text=@"编辑";
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
        
    }
    
    
    
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
#pragma mark-获取文字长度
-(CGFloat)getWeight:(NSString *)str{
    //    NSDictionary* attrs =@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:17.5]};
    NSDictionary* attrs =@{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    
    NSAttributedString *newatt=[[NSAttributedString alloc] initWithString:str attributes:attrs];
    CGRect rect=[newatt boundingRectWithSize:CGSizeMake(MAXFLOAT, 25) options:NSStringDrawingTruncatesLastVisibleLine context:nil];
    CGSize titleSize=rect.size;
    return titleSize.width;
    
    
}
@end
