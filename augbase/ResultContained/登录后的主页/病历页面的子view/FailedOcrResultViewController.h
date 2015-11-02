//
//  FailedOcrResultViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/22.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//
@protocol DeleteFailedReportDele <NSObject>

@required
-(void)deleteReport:(BOOL)result;

@end


@protocol CameraNewReportDele <NSObject>

@required
-(void)cameraNewReport:(BOOL)result;

@end

#import <UIKit/UIKit.h>

@interface FailedOcrResultViewController : UIViewController<UIAlertViewDelegate>

@property (nonatomic,strong)IBOutlet UIImageView *failResultImageView;
@property (nonatomic,strong)IBOutlet UILabel *failCategoryText;
@property (nonatomic,strong)IBOutlet UILabel *failDetailText;
@property (nonatomic,strong)IBOutlet UIButton *cameraAgainButton;

@property (nonatomic,strong) NSString *failedImageUrl;

@property (nonatomic,strong) NSDictionary *detailDic;

@property (nonatomic,weak) id<CameraNewReportDele> cameraNewReportDele;
@property (nonatomic,weak) id<DeleteFailedReportDele> deleteFailedReportDele;

@property (nonatomic,strong) UIViewController *caseRootVC;


@end
