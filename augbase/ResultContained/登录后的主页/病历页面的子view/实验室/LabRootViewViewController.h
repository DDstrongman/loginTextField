//
//  LabRootViewViewController.h
//  Yizhenapp
//
//  Created by 李胜书 on 15/11/30.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabRootViewViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong)UITableView *LabTable;

@end
