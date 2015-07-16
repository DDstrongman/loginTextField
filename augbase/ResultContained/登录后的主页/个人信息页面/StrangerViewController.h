//
//  StrangerViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/15.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SendAddMessViewController.h"

@interface StrangerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

{
    BOOL showDetail;//显示病情用药与否
}

@property (nonatomic,strong) IBOutlet UITableView *showStrangerTable;
//@property (nonatomic,strong) UIButton *deleteButton;

//网络获取的各个个人数据
@property (nonatomic,strong) UIImage *strangerImage;//头像
@property (nonatomic) NSString *strangerName;//昵称
@property (nonatomic) NSString *strangerDescribe;//个性签名
@property (nonatomic) NSString *strangerRelative;//患者相似度
@property (nonatomic) NSString *strangerLocation;//患者位置
@property (nonatomic,strong) NSArray *strangermedicalArray;//用药数组
@property (nonatomic,strong) NSArray *strangerdiseaseArray;//患病数组


@end
