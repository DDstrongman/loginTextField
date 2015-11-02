//
//  MyGenderViewController.h
//  Yizhenapp
//
//  Created by 李胜书 on 15/10/19.
//  Copyright © 2015年 李胜书. All rights reserved.
//

@protocol ChangeGenderDele <NSObject>

@required
-(void)changeGender:(BOOL)result;

@end

#import <UIKit/UIKit.h>

@interface MyGenderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *setUserGenderTable;

@property (nonatomic,weak) id<ChangeGenderDele>changeGenderDele;

@end
