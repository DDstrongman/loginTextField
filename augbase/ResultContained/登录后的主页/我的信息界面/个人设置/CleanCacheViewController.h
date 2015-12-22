//
//  CleanCacheViewController.h
//  Yizhenapp
//
//  Created by 李胜书 on 15/11/24.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CleanCacheViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UITableView *cleanCacheTable;//清除缓存

@end
