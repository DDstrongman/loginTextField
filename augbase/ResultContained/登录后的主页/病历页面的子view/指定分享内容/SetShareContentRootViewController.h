//
//  SetShareContentRootViewController.h
//  Yizhenapp
//
//  Created by 李胜书 on 15/10/10.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetShareContentRootViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *setShareTable;//选择分享的表格

@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) NSArray *timeArray;
@property (nonatomic,strong) NSDictionary *titleDic;

@end
