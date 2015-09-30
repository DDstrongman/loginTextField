//
//  DiseaseDescribeViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/9/18.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiseaseDescribeViewController : UIViewController

@property (nonatomic,strong) UITextView *inputText;//输入病史

@property (nonatomic,strong) NSDictionary *infoDic;//传过来的所有数据字典

@end
