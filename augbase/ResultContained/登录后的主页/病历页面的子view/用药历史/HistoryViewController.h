//
//  HistoryViewController.h
//  Yizhen
//
//  Created by ramy on 14-3-15.
//  Copyright (c) 2014年 jpx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Drug.h"
#import "NewAddDrugViewController.h"
#import "HistroyCell.h"
#import "UIButton+EnlargeArea.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "TMCache.h"
typedef void (^ changedraw) (int ischange);
typedef void (^ changeHisdrug) (int ischangedrug);
typedef void (^ changedoneqr) (NSString *hisnames);


@interface HistoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,UIAlertViewDelegate>

{
    UIView *aview;
    UIView *alineview;
    MBProgressHUD *HUD;
    
    
}
@property (nonatomic,copy)changedoneqr qrblock;
@property (nonatomic,copy)changeHisdrug changedrug;

@property (nonatomic,assign)int ischange;

@property (nonatomic,copy)changedraw mychangedraw;


@property (nonatomic,strong)NSString *source;

@property (nonatomic,strong)UITableView *mytableview;
@property (nonatomic,strong)NSMutableArray *mydatas;
-(void)addObj:(Drug *)d;
@property (nonatomic,strong)UIImageView *newnavbar;

@end
