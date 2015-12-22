//
//  UUMessageContentButton.h
//  BloodSugarForDoc
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 shake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUMessageContentButton : UIButton

//bubble imgae
@property (nonatomic, retain) UIImageView *backImageView;

//audio
@property (nonatomic, retain) UIView *voiceBackView;
@property (nonatomic, retain) UILabel *second;
@property (nonatomic, retain) UIImageView *voice;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;

@property (nonatomic, retain) UIView *urlContentView;//大表格背景白色view
@property (nonatomic, retain) UIImageView *urlTitleImageView;//大表格背景白色view
@property (nonatomic, retain) UILabel *urlTitleLabel;


@property (nonatomic, assign) BOOL isMyMessage;


- (void)benginLoadVoice;

- (void)didLoadVoice;

-(void)stopPlay;

@end
