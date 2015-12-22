//
//  SetShareContentRootViewController.h
//  Yizhenapp
//
//  Created by 李胜书 on 15/10/10.
//  Copyright © 2015年 李胜书. All rights reserved.
//

@protocol SendTableResultDele <NSObject>

@required
-(void)SendTableResult:(BOOL)Result ShareUrl:(NSString *)shareUrl;

@end

#import <UIKit/UIKit.h>

@interface SetShareContentRootViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *setShareTable;//选择分享的表格

@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) NSArray *timeArray;
@property (nonatomic,strong) NSDictionary *titleDic;

@property (nonatomic) BOOL shareOrSend;//是发送大表还是分享大表,no为分享，yes为发送

@property (nonatomic,weak) id<SendTableResultDele> sendTableResultDele;//

@end
