//
//  ItemTwo.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/24.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemTwo : NSObject

//网络获取或是传输的各个个人数据

@property (nonatomic) NSString *titleText;//文章名称
@property (nonatomic,strong) UIImage *titleImage;//作者头像
@property (nonatomic) NSString *personName;//作者名称
@property (nonatomic) NSString *timeText;//作者名称
@property (nonatomic,strong) NSArray *tagArray;//文章所属分类数组
@property (nonatomic,strong) UIImage *aricleImage;//文章图像
@property (nonatomic) NSString *aricleDescribe;//文章内容

@end
