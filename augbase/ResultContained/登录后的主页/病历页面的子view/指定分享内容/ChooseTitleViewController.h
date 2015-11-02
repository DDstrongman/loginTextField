//
//  ChooseTitleViewController.h
//  Yizhenapp
//
//  Created by 李胜书 on 15/10/10.
//  Copyright © 2015年 李胜书. All rights reserved.
//

@protocol ChooseTitleArrayDele <NSObject>

@required
-(void)chooseTitleArray:(NSArray *)choosedArray ChoosedENGArray:(NSArray *)choosedENGArray;//选择了哪些数组

@end

#import <UIKit/UIKit.h>

@interface ChooseTitleViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *setShareTitleTable;//选择分享的表格

@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) NSArray *titleENGArray;//指标英文名
@property (nonatomic,strong) NSArray *setChoosedTitleArray;
@property (nonatomic,strong) NSMutableArray *setChoosedENGTitleArray;


@property (nonatomic,weak) id<ChooseTitleArrayDele> chooseTitleArrayDele;

@end
