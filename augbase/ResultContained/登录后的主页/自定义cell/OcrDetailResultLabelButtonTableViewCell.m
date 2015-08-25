//
//  OcrDetailResultLabelButtonTableViewCell.m
//  ResultContained
//
//  Created by 李胜书 on 15/8/12.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "OcrDetailResultLabelButtonTableViewCell.h"

@implementation OcrDetailResultLabelButtonTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,2, 60,17)];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:_timeLabel];
        
        _medicalButton = [[UIButton alloc] initWithFrame:CGRectMake(15,22,80,20)];
        _medicalButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _medicalButton.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [_medicalButton setImage:[UIImage imageNamed:@"begin"] forState:UIControlStateNormal];
        _medicalButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [_medicalButton setTitle:NSLocalizedString(@"恩替卡韦", @"") forState:UIControlStateNormal];
        [self addSubview:_medicalButton];
    }
    return self;
}

@end
