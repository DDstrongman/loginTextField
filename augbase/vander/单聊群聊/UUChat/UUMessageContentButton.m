//
//  UUMessageContentButton.m
//  BloodSugarForDoc
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 shake. All rights reserved.
//

#import "UUMessageContentButton.h"
@implementation UUMessageContentButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //图片
        self.backImageView = [[UIImageView alloc]init];
        self.backImageView.userInteractionEnabled = YES;
        self.backImageView.layer.cornerRadius = 5;
        self.backImageView.layer.masksToBounds  = YES;
        self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backImageView.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.backImageView];
        
        //语音
        self.voiceBackView = [[UIView alloc]init];
        [self addSubview:self.voiceBackView];
        self.second = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
        self.second.textAlignment = NSTextAlignmentCenter;
        self.second.font = [UIFont systemFontOfSize:14];
        self.voice = [[UIImageView alloc]initWithFrame:CGRectMake(90, 5, 20, 20)];
        self.voice.image = [UIImage imageNamed:@"chat_animation_white3"];
        self.voice.animationImages = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"chat_animation_white1"],
                                      [UIImage imageNamed:@"chat_animation_white2"],
                                      [UIImage imageNamed:@"chat_animation_white3"],nil];
        self.voice.animationDuration = 1;
        self.voice.animationRepeatCount = 0;
        self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.indicator.center = CGPointMake(80, 15);
        [self.voiceBackView addSubview:self.indicator];
        [self.voiceBackView addSubview:self.voice];
        [self.voiceBackView addSubview:self.second];
        
        //大表格
        self.urlContentView = [[UIView alloc]init];
        [self addSubview:self.urlContentView];
        self.urlTitleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 15, 60, 60)];
        self.urlTitleImageView.image = [UIImage imageNamed:@"form4wc"];
        self.urlTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(64+10+6, 15,ViewWidth-120-50-60-4-16-12, 60)];
        self.urlTitleLabel.textAlignment = NSTextAlignmentLeft;
        self.urlTitleLabel.font = [UIFont systemFontOfSize:14];
        self.urlTitleLabel.numberOfLines = 0;
        [self.urlContentView addSubview:self.urlTitleImageView];
        [self.urlContentView addSubview:self.urlTitleLabel];
        
        self.backImageView.userInteractionEnabled = NO;
        self.voiceBackView.userInteractionEnabled = NO;
        self.second.userInteractionEnabled = NO;
        self.voice.userInteractionEnabled = NO;
        self.urlContentView.userInteractionEnabled = NO;
        self.urlTitleImageView.userInteractionEnabled = NO;
        self.urlTitleLabel.userInteractionEnabled = NO;
        
        self.second.backgroundColor = [UIColor clearColor];
        self.voice.backgroundColor = [UIColor clearColor];
        self.voiceBackView.backgroundColor = [UIColor clearColor];
        self.urlContentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)benginLoadVoice
{
    self.voice.hidden = YES;
    [self.indicator startAnimating];
}
- (void)didLoadVoice
{
    self.voice.hidden = NO;
    [self.indicator stopAnimating];
    [self.voice startAnimating];
}
-(void)stopPlay
{
//    if(self.voice.isAnimating){
        [self.voice stopAnimating];
//    }
}

- (void)setIsMyMessage:(BOOL)isMyMessage
{
    _isMyMessage = isMyMessage;
    if (isMyMessage) {
        self.backImageView.frame = CGRectMake(5, 5, 220, 220);
        self.voiceBackView.frame = CGRectMake(15, 10, 130, 35);
        self.second.textColor = [UIColor whiteColor];
        self.voice.image = [UIImage imageNamed:@"chat_animation_white3"];
        self.voice.animationImages = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"chat_animation_white1"],
                                      [UIImage imageNamed:@"chat_animation_white2"],
                                      [UIImage imageNamed:@"chat_animation_white3"],nil];
    }else{
        self.backImageView.frame = CGRectMake(15, 5, 220, 220);
        self.voiceBackView.frame = CGRectMake(25, 10, 130, 35);
        self.second.textColor = [UIColor grayColor];
        self.voice.image = [UIImage imageNamed:@"chat_animation3"];
        self.voice.animationImages = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"chat_animation1"],
                                      [UIImage imageNamed:@"chat_animation2"],
                                      [UIImage imageNamed:@"chat_animation3"],nil];
    }
}
//添加
- (BOOL)canBecomeFirstResponder{
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return (action == @selector(copy:));
}

-(void)copy:(id)sender{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.titleLabel.text;
}

@end
