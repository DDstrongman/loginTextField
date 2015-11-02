//
//  MyDocInfoViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/9/9.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

@protocol ChangeRealNameDele <NSObject>

@required
-(void)changeRealName:(BOOL)result;

@end

#import <UIKit/UIKit.h>

@interface MyDocInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *setDocInfoTable;

@property (nonatomic,weak) id<ChangeRealNameDele>changeRealNameDele;

@end
