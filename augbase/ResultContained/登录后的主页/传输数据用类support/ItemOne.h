//
//  ItemOne.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/15.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemOne : NSObject

//网络获取或是传输的各个个人数据
@property (nonatomic,strong) UIImage *titleImage;//用户头像
@property (nonatomic) NSString *personName;//昵称
@property (nonatomic) NSString *personDescribe;//个性签名
@property (nonatomic) NSString *personRelative;//患者相似度
@property (nonatomic) NSString *personLocation;//患者位置
@property (nonatomic,strong) NSArray *medicalArray;//用药数组
@property (nonatomic,strong) NSArray *diseaseArray;//患病数组

@end
