//
//  MyLocationSectionViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/9/9.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

@protocol ChangeAddressDele <NSObject>

@required
-(void)changeAddress:(BOOL)result;

@end

#import <UIKit/UIKit.h>

@interface MyLocationSectionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *locationSectionTable;

@property (nonatomic,weak) UIViewController *popViewController;

@property (nonatomic,strong) NSArray *sectionArray;//地区的ary
@property (nonatomic,strong) NSString *cityName;//地区的ary

@property (nonatomic,weak) id<ChangeAddressDele>changeAddressDele;

@end
