//
//  OrderTextListViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/9/15.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTextListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *listTable;//排序的表格

@property (nonatomic,strong) NSArray *listArray;//传入之前的排序数组
@property (nonatomic,strong) NSDictionary *listName;//传入的对应的排序key值的中文名

@end
