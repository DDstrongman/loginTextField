//
//  MessTableViewCell.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/13.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAImageView.h"

@interface MessTableViewCell : UITableViewCell

@property (nonatomic, strong) PAImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleText;
@property (nonatomic, strong) UILabel *descriptionText;
@property (nonatomic, strong) UILabel *timeText;

@end
