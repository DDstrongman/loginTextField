//
//  HistoryDiseaseViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/9/7.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//
@protocol HistoryDiseaseDelegate <NSObject>

@required
-(void)historyDiseaseDelegate:(BOOL)result;

@end
#import <UIKit/UIKit.h>

@interface HistoryDiseaseViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *historyDiseaseCollection;

@property (nonatomic,weak) id<HistoryDiseaseDelegate>hisDele;

@end
