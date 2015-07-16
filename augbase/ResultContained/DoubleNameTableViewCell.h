//
//  DoubleNameTableViewCell.h
//  ResultContained
//
//  Created by 李胜书 on 15/6/29.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoubleNameTableViewCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong) IBOutlet UILabel *firstTitleLabel;
@property (nonatomic,strong) IBOutlet UILabel *firstWeekLabel;
@property (nonatomic,strong) IBOutlet UILabel *secondTitleLabel;
@property (nonatomic,strong) IBOutlet UILabel *secondWeekLabel;

@end
