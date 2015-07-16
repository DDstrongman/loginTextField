//
//  CaseViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/2.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) IBOutlet UITableView *titleTable;

@property (nonatomic,strong) IBOutlet UIScrollView *resultScroller;
@property (nonatomic,strong) IBOutlet UITableView *firstTable;
@property (nonatomic,strong) IBOutlet UITableView *secondTable;
@property (nonatomic,strong) IBOutlet UITableView *thirdTable;
@property (nonatomic,strong) IBOutlet UITableView *forthTable;

//此处的collectionview只是代替显示，在主体项目中已经实现（manage里的view）
@property (nonatomic,strong) IBOutlet UICollectionView *settingCollection;

@end
