//
//  CurrentileViewController.h
//  Yizhen
//
//  Created by ramy on 14-3-15.
//  Copyright (c) 2014年 jpx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"
#import "BasicViewController.h"
#import "AFNetworking.h"

//block 传值 刷新当前疾病
typedef void (^MYBlock) (NSArray  *btnArray);
@interface CurrentileViewController : BasicViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,MBProgressHUDDelegate>
{
   // MBProgressHUD *HUD;
    
}
//疾病类型
@property (nonatomic,strong)NSMutableArray *mydatas;

@property (nonatomic,strong)UITableView *mytableview;
@property (nonatomic,strong)NSString *delectstr;
@property (nonatomic,strong)UIScrollView *myscrollview;
@property (nonatomic,strong)UIButton *mybtn;

@property (nonatomic,copy)MYBlock block;
//当前疾病
@property (nonatomic,strong)NSMutableArray *currentArray;
@property (nonatomic,strong)UIImageView *newnavbar;

@property (nonatomic,strong)UIScrollView *contentview;



//疾病
@property (nonatomic,strong)NSMutableArray *oneArray;



@end
