//
//  HAPaperCollectionViewController.h
//  Paper
//
//  Created by Heberti Almeida on 11/02/14.
//  Copyright (c) 2014 Heberti Almeida. All rights reserved.
//

@import UIKit;

@interface HAPaperCollectionViewController : UICollectionViewController

- (UICollectionViewController*)nextViewControllerAtPoint:(CGPoint)point;

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *imageButton;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIView *labelButtonView;//存放labelButton的view，需要自适应高度来显示各个labelButton;
@property (nonatomic,strong) UIButton *labelButton;
@property (nonatomic,strong) UIImageView *articleImageView;
@property (nonatomic,strong) UILabel *detailLabel;

@end
