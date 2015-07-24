//
//  CurrentileViewControllerThree.h
//  Yizhen2
//
//  Created by Jpxin on 14-7-2.
//  Copyright (c) 2014年 Augbase. All rights reserved.
//

#import "BasicViewController.h"
#import "SearchViewController.h"
typedef void (^TMYBlock) (NSArray  *btnArray);

@interface CurrentileViewControllerThree : BasicViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,MBProgressHUDDelegate>
{
    

}

//疾病类型
@property (nonatomic,strong)NSMutableArray *mydatas;

@property (nonatomic,strong)UITableView *mytableview;
@property (nonatomic,strong)NSString *delectstr;
@property (nonatomic,strong)UIScrollView *myscrollview;
@property (nonatomic,strong)UIButton *mybtn;

@property (nonatomic,copy)TMYBlock block;

@property (nonatomic,strong)NSMutableArray *currentArray;
@property (nonatomic,strong)UIImageView *newnavbar;

@property (nonatomic,strong)UIScrollView *contentview;



@property (nonatomic,strong)NSMutableArray *oneArray;
@end
