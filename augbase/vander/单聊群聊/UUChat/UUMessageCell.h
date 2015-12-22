//
//  UUMessageCell.h
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//
@protocol ShowWebViewDele <NSObject>

@required
-(void)ShowWebView:(NSString *)Url MineOrOther:(NSInteger)from;

@end


#import <UIKit/UIKit.h>
#import "UUMessageContentButton.h"
@class UUMessageFrame;
@class UUMessageCell;

@protocol UUMessageCellDelegate <NSObject>
@optional
- (void)headImageDidClick:(UUMessageCell *)cell userId:(NSInteger)userId;
//没有实现
- (void)cellContentDidClick:(UUMessageCell *)cell image:(UIImage *)contentImage;
@end


@interface UUMessageCell : UITableViewCell

@property (nonatomic, retain)UILabel *labelTime;
@property (nonatomic, retain)UILabel *labelNum;
@property (nonatomic, retain)UIButton *btnHeadImage;

@property (nonatomic, retain) UIImage *titleImage;

@property (nonatomic, retain)UUMessageContentButton *btnContent;

@property (nonatomic, retain)UUMessageFrame *messageFrame;

@property (nonatomic, assign)id<UUMessageCellDelegate>delegate;
@property (nonatomic, assign)id<ShowWebViewDele>showWebDele;

@end

