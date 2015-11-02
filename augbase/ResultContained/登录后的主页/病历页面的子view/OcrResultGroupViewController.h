//
//  OcrResultGroupViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/22.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRLCollectionViewGridLayout.h"
#import "Cell1.h"

#import "DetailImageOcrViewController.h"
#import "FailedOcrResultViewController.h"

@interface OcrResultGroupViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>


//此处的collectionview只是代替显示，在主体项目中已经实现（manage里的view）
@property (nonatomic,strong) IBOutlet UICollectionView *ocrResultCollection;
//此处的数字代表选择的选项，0代表失败，1代表识别中，2代表识别成功
@property (nonatomic) NSInteger SegIndex;

@property (nonatomic,strong) UIViewController *caseRootVC;//

@end
