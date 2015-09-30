//
//  VirusCategoryViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/9/7.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

@protocol  VirusCategoryDelegate <NSObject>

@required
-(void)virusCategoryDelegate:(BOOL)result;

@end

#import <UIKit/UIKit.h>

@interface VirusCategoryViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *virusCategoryDiseaseCollection;
@property (nonatomic,weak) id<VirusCategoryDelegate>virusDele;

@end
