//
//  CurrentDiseaseViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/9/6.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

@protocol CurrentDiseaseDelegate <NSObject>

@required
-(void)currentDiseaseDelegate:(BOOL)result;

@end

#import <UIKit/UIKit.h>

@interface CurrentDiseaseViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *currentDiseaseCollection;
@property (nonatomic,weak) id<CurrentDiseaseDelegate>currentDele;

@end
