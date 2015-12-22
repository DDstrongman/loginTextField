//
//  DrugHistroyViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/9/7.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OcrTextResultViewController.h"

@interface DrugHistroyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *drugHistroyTable;//用药历史记录

@property (nonatomic,strong) OcrTextResultViewController *OcrTextViewController;

@end
