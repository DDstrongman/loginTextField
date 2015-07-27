//
//  ViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/6/26.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "OcrTextResultViewController.h"

#import "RZTransitionsInteractionControllers.h"
#import "RZTransitionsAnimationControllers.h"
#import "RZTransitionInteractionControllerProtocol.h"
#import "RZTransitionsManager.h"


#define  ViewHeight [[UIScreen mainScreen] bounds].size.height
#define  ViewWidth [[UIScreen mainScreen] bounds].size.width

@interface OcrTextResultViewController ()

{
    CGFloat cellHeight;
    UIImageView *tableTopImageView; //tableview之上显示的图片（向下拉动时）
    UIVisualEffectView *visualEffectView;
    
    BOOL offsetGoto; //判断拉到之后跳转
}

@property (nonatomic, strong) id<RZTransitionInteractionController> pushPopInteractionController;
@property (nonatomic, strong) id<RZTransitionInteractionController> presentInteractionController;


@end

@implementation OcrTextResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化各个tableview和tableview顶上的uiimagview
    self.navigationController.navigationBarHidden = YES;
    tableTopImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, ViewWidth/2, 0)];
    tableTopImageView.image = [UIImage imageNamed:@"paipai"];//此处改为拍照时候的最后一张照片
    tableTopImageView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:tableTopImageView];
    
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    visualEffectView.frame = CGRectMake(0, 44, ViewWidth, 0);
    visualEffectView.alpha = 1.0;
    [self.view addSubview:visualEffectView];
    
    _nameTable.delegate = self;
    _nameTable.dataSource = self;
    _firstResultTable.delegate = self;
    _firstResultTable.dataSource = self;
    _secondResultTable.delegate = self;
    _secondResultTable.dataSource = self;
    _thirdesultTable.delegate = self;
    _thirdesultTable.dataSource = self;
    
    //设置tableview的frame否则tableview无法显示完全
    _nameTable.frame = CGRectMake(0, 44, 120,ViewHeight -44);
    _firstResultTable.frame = CGRectMake(0, 0, 100,ViewHeight -44);
    _secondResultTable.frame = CGRectMake(100, 0, 100,ViewHeight -44);
    _thirdesultTable.frame = CGRectMake(200, 0, 100,ViewHeight -44);
    _resultScroller.frame = CGRectMake(120, 44, ViewWidth-120,ViewHeight -44);
    
    //初始化两个scrollerview
    _titleScroller.delegate = self;
    _resultScroller.delegate = self;
    
    //tableview有显示不全的问题,原因在于加入了最上方的44height的scrollerview，需要计算tableview的frame高度
//    _nameTable.frame = CGRectMake(0, 44, 120, 2000);
    
    //此处应该加入通过标识符数组传入的cell高度的总和计算出的height，否则tableview显示不完全,目前用的height不正确,只是暂时的特例
    _resultScroller.contentSize = CGSizeMake(1200,300);
    
    
    [_titleButton makeInsetShadowWithRadius:8.0 Color:[UIColor colorWithRed:238.0 green:238.0 blue:238.0 alpha:0.1] Directions:[NSArray arrayWithObjects:@"right", nil]];
    
//    [self initGesture:_titleButton];
    
    
    //添加push等运动动画效果
    self.pushPopInteractionController = [[RZHorizontalInteractionController alloc] init];
    [self.pushPopInteractionController setNextViewControllerDelegate:self];
    [self.pushPopInteractionController attachViewController:self withAction:RZTransitionAction_PushPop];
    [[RZTransitionsManager shared] setInteractionController:self.pushPopInteractionController
                                         fromViewController:[self class]
                                           toViewController:nil
                                                  forAction:RZTransitionAction_PushPop];
    
    
    // Create the presentation interaction controller that allows a custom gesture
    // to control presenting a new VC via a presentViewController
    self.presentInteractionController = [[RZVerticalSwipeInteractionController alloc] init];
    [self.presentInteractionController setNextViewControllerDelegate:self];
    [self.presentInteractionController attachViewController:self withAction:RZTransitionAction_Present];
    
    // Setup the push & pop animations as well as a special animation for pushing a
    // RZSimpleCollectionViewController
//    [[RZTransitionsManager shared] setAnimationController:[[RZCardSlideAnimationController alloc] init]
//                                       fromViewController:[self class]
//     
//                                                forAction:RZTransitionAction_PushPop];
    [[RZTransitionsManager shared] setAnimationController:[[RZZoomPushAnimationController alloc] init]
                                       fromViewController:[self class]
                                         toViewController:[detailViewController class]
                                                forAction:RZTransitionAction_PushPop];
//
//    // Setup the animations for presenting and dismissing a new VC
//    [[RZTransitionsManager shared] setAnimationController:[[RZCirclePushAnimationController alloc] init]
//                                       fromViewController:[self class]
//                                                forAction:RZTransitionAction_PresentDismiss];
    
//    _bottomToolBar.frame = CGRectMake(0, ViewHeight-44, ViewWidth, 44);
    
    //底部工具条
    UIView *bottomToolBar = [[UIView alloc]initWithFrame:CGRectMake(0, ViewHeight-44, ViewWidth, 44)];
    bottomToolBar.backgroundColor = [UIColor colorWithRed:41/255.0 green:187/255.0 blue:207/255.0 alpha:1.0];
    UIButton *firstButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ViewWidth/4, 44)];
    UIButton *secondButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ViewWidth/4, 44)];
    UIButton *thirdButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ViewWidth/4, 44)];
    UIButton *fourthButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ViewWidth/4, 44)];
    
    firstButton.center = CGPointMake(ViewWidth/8*1, 22);
    firstButton.backgroundColor = [UIColor blackColor];
    secondButton.center = CGPointMake(ViewWidth/8*3, 22);
    secondButton.backgroundColor = [UIColor orangeColor];
    thirdButton.center = CGPointMake(ViewWidth/8*5, 22);
    thirdButton.backgroundColor = [UIColor redColor];
    fourthButton.center = CGPointMake(ViewWidth/8*7, 22);
    fourthButton.backgroundColor = [UIColor blueColor];
    
    [firstButton setTitle:NSLocalizedString(@"工具1", @"") forState:UIControlStateNormal];
    [secondButton setTitle:NSLocalizedString(@"工具2", @"") forState:UIControlStateNormal];
    [thirdButton setTitle:NSLocalizedString(@"工具3", @"") forState:UIControlStateNormal];
    [fourthButton setTitle:NSLocalizedString(@"工具4", @"") forState:UIControlStateNormal];
    
    [bottomToolBar addSubview:firstButton];
    [bottomToolBar addSubview:secondButton];
    [bottomToolBar addSubview:thirdButton];
    [bottomToolBar addSubview:fourthButton];
    [self.view addSubview:bottomToolBar];
}

#pragma mark - Next View Controller Logic

- (UIViewController *)nextSimpleViewController
{
    detailViewController* newVC = [[detailViewController alloc] init];
    [newVC setTransitioningDelegate:[RZTransitionsManager shared]];
    return newVC;
}

- (UIViewController *)nextSimpleColorViewController
{
    detailViewController* newColorVC = [[detailViewController alloc] init];
    [newColorVC setTransitioningDelegate:[RZTransitionsManager shared]];
    
    // Create a dismiss interaction controller that will be attached to the presented
    // view controller to allow for a custom dismissal
    RZVerticalSwipeInteractionController *dismissInteractionController = [[RZVerticalSwipeInteractionController alloc] init];
    [dismissInteractionController attachViewController:newColorVC withAction:RZTransitionAction_Dismiss];
    [[RZTransitionsManager shared] setInteractionController:dismissInteractionController
                                         fromViewController:[self class]
                                           toViewController:nil
                                                  forAction:RZTransitionAction_Dismiss];
    return newColorVC;
}

#pragma mark - RZTransitionInteractorDelegate

- (UIViewController *)nextViewControllerForInteractor:(id<RZTransitionInteractionController>)interactor
{
    if ([interactor isKindOfClass:[RZVerticalSwipeInteractionController class]]) {
        return [self nextSimpleColorViewController];
    }
    else {
        return [self nextSimpleViewController];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    offsetGoto = YES;//这个界面出现的时候跳转变量为yes，为no则向下拉动tableview也无法跳转，主要是为了解决tableview offset多次达到判断标准距离的时候多次跳转的问题
    
    tableTopImageView.frame = CGRectMake(0, 44, ViewWidth, 0);
    
    self.navigationController.navigationBarHidden = YES;
    
    [[RZTransitionsManager shared] setInteractionController:self.presentInteractionController
                                         fromViewController:[self class]
                                           toViewController:nil
                                                  forAction:RZTransitionAction_Present];
}



#pragma 去掉statebar
- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //之后通过传入的标识符数组来区分不同cell高度到底选择哪个
    //单个药品用75，两个用135，更多用150
    
    if (indexPath.row%3 == 1) {
        return 75;
    }else if(indexPath.row%3 == 2){
        return 135;
    }else{
        return 155;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    //之后通过传入的标识符数组来区分不同cell高度到底选择哪个
    //单个药品用result，两个用doubleresult，更多用moreresult
    
//    初始化手势识别cell的部件出现问题，需要在cell中加入属性以便识别相关的UILabel,改为给cell加手势即可,问题转化为怎么获取cell中对应的文本
    if (tableView == _nameTable&&indexPath.row%3 == 2 ) {
         cell = [tableView dequeueReusableCellWithIdentifier:@"doubleresult" forIndexPath:indexPath];
        [self initGesture:cell];
        
    }else if(tableView == _nameTable && indexPath.row%3 == 0){
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"moreresult" forIndexPath:indexPath];
    }else{
         cell = [tableView dequeueReusableCellWithIdentifier:@"result" forIndexPath:indexPath];
    }
    
    if (tableView == _nameTable) {
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.layer.borderWidth = 0.25;
        cell.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
        
        //添加阴影
        [cell makeInsetShadowWithRadius:8.0 Color:[UIColor colorWithRed:238.0 green:238.0 blue:238.0 alpha:0.1] Directions:[NSArray arrayWithObjects:@"right", nil]];
        
    }else {
        if (indexPath.row%2 == 0) {
            cell.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
            
//            cell.layer.borderWidth = 0.25;
//            cell.layer.borderColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0].CGColor;
            
        }else{
            cell.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
            
//            cell.layer.borderWidth = 0.25;
//            cell.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
        }
    }
//     cell.nameButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    [cell.nameButton addTarget:self action:@selector(gotoIntroduce) forControlEvents:UIControlEventTouchUpInside];
//    [cell.resultButton addTarget:self action:@selector(gotoResult) forControlEvents:UIControlEventTouchUpInside];
//    [cell.suggestButton addTarget:self action:@selector(gotoSuggest) forControlEvents:UIControlEventTouchUpInside];
//    [cell.detailButton addTarget:self action:@selector(gotoDetail) forControlEvents:UIControlEventTouchUpInside];
//    cell.pathNumber = indexPath.row;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
////    添加阴影
//    cell.layer.shadowColor = [[UIColor blackColor] CGColor];
//    cell.layer.shadowOffset = CGSizeMake(0.0f,0.0f);
//    cell.layer.shadowOpacity = 0.2f;
//    cell.layer.shadowRadius = 3.0f;
    
    return cell;
}

-(void)initGesture:(UIView *)gesTureView
{
//    UIGestureRecognizer
//    添加双击手势，如果需要多手势混合使用则需要加入手势改变的判断，具体判断在之前的项目中有完整demo
    
    NSLog(@"手势初始化");
    UITapGestureRecognizer* doubleClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapFrom:)];
    doubleClick.numberOfTapsRequired = 2; // 双击
    [gesTureView addGestureRecognizer:doubleClick];
}

-(void)handleDoubleTapFrom:(UITapGestureRecognizer *)doubleTap
{
    NSLog(@"双击");
//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    detailViewController *vc = [[detailViewController alloc]init];;
    
    UITableViewCell *cell = (UITableViewCell*)doubleTap.view;
    
    //需要加入判断是否有多个titlelabel，多一个时候viewwithtag：200
    UILabel *titleLable = (UILabel *)[cell.contentView  viewWithTag:100];
    
    vc.titleText = titleLable.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _nameTable|scrollView == _firstResultTable|scrollView == _secondResultTable|scrollView == _thirdesultTable) {
        _nameTable.contentOffset = scrollView.contentOffset;
        _firstResultTable.contentOffset     = scrollView.contentOffset;
        _secondResultTable.contentOffset    = scrollView.contentOffset;
        _thirdesultTable.contentOffset      = scrollView.contentOffset;
        
        //仿微信上部出现模糊图片的功能已取消，故注释掉
//        CGFloat yOffset  = scrollView.contentOffset.y;
////        NSLog(@"yOffset===%f",yOffset);
//        if (yOffset<0) {
//            CGRect bounds = tableTopImageView.bounds;
//            bounds.size.height = -yOffset;
//            tableTopImageView.frame = CGRectMake(ViewWidth/4, 44, ViewWidth/2, -yOffset);
//            visualEffectView.frame = CGRectMake(0, 44, ViewWidth, -yOffset);
//
////            tableTopImageView.frame = CGRectMake(0, 44, ViewWidth, -yOffset);
////            NSLog(@"tableTop ===%f",tableTopImageView.frame.size.height);
//            
////            POPSpringAnimation *popOutAnimation = [POPSpringAnimation animation];
////            popOutAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
////            if (YES) {
////                popOutAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 44, ViewWidth, -yOffset)];
////            }
////
////            popOutAnimation.velocity = [NSValue valueWithCGRect:tableTopImageView.frame];
////            popOutAnimation.springBounciness = 5.0;
////            popOutAnimation.springSpeed = 20.0;
////            
////            [tableTopImageView pop_addAnimation:popOutAnimation forKey:@"slide"];
//            //设置首尾动画
////            [UIView beginAnimations:nil context:nil];
////            tableTopImageView.bounds = bounds;//            [UIView setAnimationDuration:0.1];
////            [UIView commitAnimations];
//            
////判断下拉距离跳转cameraview,目前测试用跳转的是detailview，之后需要修改
//            if(yOffset < -100&&offsetGoto){
//                offsetGoto = NO;
//                NSLog(@"此处跳转cameraview，目前测试跳转的detailview");
//                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                detailViewController *vc = [story instantiateViewControllerWithIdentifier:@"detailview"];
//                
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//        }
        
        
    }
    else if(scrollView == _titleScroller|scrollView == _resultScroller){
//        if(scrollView.contentOffset.x %100 == 0){
//            _titleScroller.contentOffset     = scrollView.contentOffset;
//            _resultScroller.contentOffset     = scrollView.contentOffset;
//        }else{
//            
//        }
        NSLog(@"ten: %f", scrollView.contentOffset.x );
        
        _titleScroller.contentOffset     = scrollView.contentOffset;
        _resultScroller.contentOffset     = scrollView.contentOffset;
    }
    
}

#pragma 仅仅移动的时候触发该delegate
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if(scrollView == _titleScroller|scrollView == _resultScroller){
//        if ((int)(scrollView.contentOffset.x) % 100 !=0) {
//            int tempNumber = (int)(scrollView.contentOffset.x)/100 + 1;
//            _titleScroller.contentOffset = CGPointMake(tempNumber*100, scrollView.contentOffset.y);
//            _resultScroller.contentOffset = CGPointMake(tempNumber*100, scrollView.contentOffset.y);
//        }
//    }
//}

#pragma 有滚动的时候滚动完毕之后触发delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    if(scrollView == _titleScroller|scrollView == _resultScroller){
        if ((int)(scrollView.contentOffset.x) % 100 !=0) {
            int tempNumber = (int)(scrollView.contentOffset.x)/100 + 1;
            
//            _titleScroller.contentOffset = CGPointMake(tempNumber*100, scrollView.contentOffset.y);
//            _resultScroller.contentOffset = CGPointMake(tempNumber*100, scrollView.contentOffset.y);
            
            //设置了_titlescroller和resultscroller一样的offset，所以此处只能设置一次animate，否则出错
            [_titleScroller setContentOffset:scrollView.contentOffset animated:YES];
            
            [_resultScroller setContentOffset:CGPointMake(tempNumber*100, scrollView.contentOffset.y) animated:YES];
            
//            _titleScroller.contentOffset = CGPointMake(tempNumber*100, scrollView.contentOffset.y);
//            _resultScroller.contentOffset = CGPointMake(tempNumber*100, scrollView.contentOffset.y);
            
//            POPSpringAnimation *popOutAnimation = [POPSpringAnimation animation];
//            popOutAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
//            if (YES) {
//                popOutAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0, scrollView.contentOffset.y)];
//                NSLog(@"tempNumber == %d",tempNumber*100);
//            }
//        
//            popOutAnimation.velocity = [NSValue valueWithCGPoint:scrollView.contentOffset];
//            popOutAnimation.springBounciness = 5.0;
//            popOutAnimation.springSpeed = 3.0;
//            
//            [_resultScroller pop_addAnimation:popOutAnimation forKey:@"slide"];
        }
    }
}

#pragma 返回函数
-(IBAction)goBack:(id)sender{
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}

@end
