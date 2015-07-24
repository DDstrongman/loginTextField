//
//  HistroyCell.h
//  Yizhen-2.28
//
//  Created by ramy on 14-3-6.
//  Copyright (c) 2014年 jpx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistroyCell : UITableViewCell
@property (nonatomic,strong)UILabel *namelab;
@property (nonatomic,strong)UILabel *starttime;
@property (nonatomic,strong)UILabel *endtime;
@property (nonatomic,strong)UILabel *l2;//耐药 灰色
@property (nonatomic,strong)UIImageView *rightview;

@end
