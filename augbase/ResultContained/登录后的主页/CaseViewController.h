//
//  CaseViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/2.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaseViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

//上方两个image的button和对应下方的button
@property (nonatomic,strong) IBOutlet UIButton *cameraNewButton;
@property (nonatomic,strong) IBOutlet UIButton *checkResultButton;

//此处的collectionview只是代替显示，在主体项目中已经实现（manage里的view）
@property (nonatomic,strong) IBOutlet UICollectionView *settingCollection;

@end
