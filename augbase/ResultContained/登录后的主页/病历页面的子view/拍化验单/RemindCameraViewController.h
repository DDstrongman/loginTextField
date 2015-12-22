//
//  RemindCameraViewController.h
//  Yizhenapp
//
//  Created by 李胜书 on 15/11/19.
//  Copyright © 2015年 李胜书. All rights reserved.
//

@protocol RemindCameraDele <NSObject>

@required
-(void)RemindCameraResult:(BOOL)result;

@end

#import <UIKit/UIKit.h>

@interface RemindCameraViewController : UIViewController<UIScrollViewAccessibilityDelegate>

@property (nonatomic,strong) UIScrollView *guideCameraScroller;//引导的view

@property (nonatomic,weak) id<RemindCameraDele> remindCameraDele;//提示完了之后打开摄像头

@end
