//
//  PhotoTweaksViewController.m
//  PhotoTweaks
//
//  Created by Tu You on 14/12/5.
//  Copyright (c) 2014年 Tu You. All rights reserved.
//

#import "PhotoTweaksViewController.h"
#import "PhotoTweakView.h"
#import "UIColor+Tweak.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface PhotoTweaksViewController ()

@property (strong, nonatomic) PhotoTweakView *photoView;

@end

@implementation PhotoTweaksViewController

@synthesize tag;

- (instancetype)initWithImage:(UIImage *)image
{
    if (self = [super init]) {
        _image = image;
        _autoSaveToLibray = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

  
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor photoTweakCanvasBackgroundColor];

    [self setupSubviews];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)setupSubviews
{
    int Style;
    NSLog(@"tag====%ld",tag);
    if(tag==1)
    {
       Style=0;
    }
    else
    {
       Style=1;
    }
    self.photoView = [[PhotoTweakView alloc] initWithFrame:self.view.bounds image:self.image CameraStyle:Style];
    
    self.photoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.photoView];

    
    
    //UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10,5, 30, 30)];
    cancelBtn.tintColor = themeColor;
    [cancelBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    //cancelBtn.frame = CGRectMake(8, CGRectGetHeight(self.view.frame) - 40, 60, 40);
    //cancelBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    //[cancelBtn setTitle:NSLocalizedStringFromTable(@"Cancel", @"PhotoTweaks", nil) forState:UIControlStateNormal];
    //UIColor *cancelTitleColor = !self.cancelButtonTitleColor ? [UIColor cancelButtonColor] : self.cancelButtonTitleColor;
    //[cancelBtn setTitleColor:cancelTitleColor forState:UIControlStateNormal];
    //UIColor *cancelHighlightTitleColor = !self.cancelButtonHighlightTitleColor ? [UIColor cancelButtonHighlightedColor] : self.cancelButtonHighlightTitleColor;
    //[cancelBtn setTitleColor:cancelHighlightTitleColor forState:UIControlStateHighlighted];
    //cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancelBtn addTarget:self action:@selector(cancelBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];

    
    
    
    //UIButton *cropBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIButton *cropBtn = [[UIButton alloc] initWithFrame:CGRectMake(ViewWidth - 70,5, 60, 30)];
//    [cropBtn setImage:[UIImage imageNamed:@"btn_right"] forState:UIControlStateNormal];
    [cropBtn setTitle:NSLocalizedString(@"完成", @"") forState:UIControlStateNormal];
    cropBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    
    //cropBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    //cropBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 60, CGRectGetHeight(self.view.frame) - 40, 60, 40);
    //[cropBtn setTitle:NSLocalizedStringFromTable(@"Done", @"PhotoTweaks", nil) forState:UIControlStateNormal];
    //UIColor *saveButtonTitleColor = !self.saveButtonTitleColor ?[UIColor saveButtonColor] : self.saveButtonTitleColor;
    //[cropBtn setTitleColor:saveButtonTitleColor forState:UIControlStateNormal];

    //UIColor *saveButtonHighlightTitleColor = !self.saveButtonHighlightTitleColor ?[UIColor saveButtonHighlightedColor] : self.saveButtonHighlightTitleColor;
    //[cropBtn setTitleColor:saveButtonHighlightTitleColor forState:UIControlStateHighlighted];
    //cropBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [cropBtn addTarget:self action:@selector(confirmCamera:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cropBtn];
    
    
    
}

- (void)cancelBtnTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)confirmCamera:(UIButton *)sender{
    //先将未到时间执行前的任务取消。
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(saveBtnTapped) object:sender];
    [self performSelector:@selector(saveBtnTapped) withObject:sender afterDelay:0.2f];
}

- (void)saveBtnTapped
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // time-consuming task
        
        CGAffineTransform transform = CGAffineTransformIdentity;
        
        // translate
        CGPoint translation = [self.photoView photoTranslation];
        transform = CGAffineTransformTranslate(transform, translation.x, translation.y);
        
        // rotate
        transform = CGAffineTransformRotate(transform, self.photoView.angle);
        
        // scale
        CGAffineTransform t = self.photoView.photoContentView.transform;
        CGFloat xScale =  sqrt(t.a * t.a + t.c * t.c);
        CGFloat yScale = sqrt(t.b * t.b + t.d * t.d);
        transform = CGAffineTransformScale(transform, xScale, yScale);
        
        CGImageRef imageRef = [self newTransformedImage:transform
                                            sourceImage:self.image.CGImage
                                             sourceSize:self.image.size
                                      sourceOrientation:self.image.imageOrientation
                                            outputWidth:self.image.size.width
                                               cropSize:self.photoView.cropView.frame.size
                                          imageViewSize:self.photoView.photoContentView.bounds.size];
        
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        NSLog(@"%@",image);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate photoTweaksViewControllerDone:self ModifyPicture:image];
        });
    });
    
    
    
    
}

- (CGImageRef)newScaledImage:(CGImageRef)source withOrientation:(UIImageOrientation)orientation toSize:(CGSize)size withQuality:(CGInterpolationQuality)quality
{
    CGSize srcSize = size;
    CGFloat rotation = 0.0;

    switch(orientation)
    {
        case UIImageOrientationUp: {
            rotation = 0;
        } break;
        case UIImageOrientationDown: {
            rotation = M_PI;
        } break;
        case UIImageOrientationLeft:{
            rotation = M_PI_2;
            srcSize = CGSizeMake(size.height, size.width);
        } break;
        case UIImageOrientationRight: {
            rotation = -M_PI_2;
            srcSize = CGSizeMake(size.height, size.width);
        } break;
        default:
            break;
    }

    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 size.width,
                                                 size.height,
                                                 8,  //CGImageGetBitsPerComponent(source),
                                                 0,
                                                 CGImageGetColorSpace(source),
                                                 (CGBitmapInfo)kCGImageAlphaNoneSkipFirst  //CGImageGetBitmapInfo(source)
                                                 );

    CGContextSetInterpolationQuality(context, quality);
    CGContextTranslateCTM(context,  size.width/2,  size.height/2);
    CGContextRotateCTM(context,rotation);

    CGContextDrawImage(context, CGRectMake(-srcSize.width/2 ,
                                           -srcSize.height/2,
                                           srcSize.width,
                                           srcSize.height),
                       source);

    CGImageRef resultRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);

    return resultRef;
}

- (CGImageRef)newTransformedImage:(CGAffineTransform)transform
                      sourceImage:(CGImageRef)sourceImage
                       sourceSize:(CGSize)sourceSize
                sourceOrientation:(UIImageOrientation)sourceOrientation
                      outputWidth:(CGFloat)outputWidth
                         cropSize:(CGSize)cropSize
                    imageViewSize:(CGSize)imageViewSize
{
    CGImageRef source = [self newScaledImage:sourceImage
                             withOrientation:sourceOrientation
                                      toSize:sourceSize
                                 withQuality:kCGInterpolationNone];

    CGFloat aspect = cropSize.height/cropSize.width;
    CGSize outputSize = CGSizeMake(outputWidth, outputWidth*aspect);

    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 outputSize.width,
                                                 outputSize.height,
                                                 CGImageGetBitsPerComponent(source),
                                                 0,
                                                 CGImageGetColorSpace(source),
                                                 CGImageGetBitmapInfo(source));
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, outputSize.width, outputSize.height));

    CGAffineTransform uiCoords = CGAffineTransformMakeScale(outputSize.width / cropSize.width,
                                                            outputSize.height / cropSize.height);
    uiCoords = CGAffineTransformTranslate(uiCoords, cropSize.width/2.0, cropSize.height / 2.0);
    uiCoords = CGAffineTransformScale(uiCoords, 1.0, -1.0);
    CGContextConcatCTM(context, uiCoords);

    CGContextConcatCTM(context, transform);
    CGContextScaleCTM(context, 1.0, -1.0);

    CGContextDrawImage(context, CGRectMake(-imageViewSize.width/2.0,
                                           -imageViewSize.height/2.0,
                                           imageViewSize.width,
                                           imageViewSize.height)
                       , source);

    CGImageRef resultRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGImageRelease(source);
    return resultRef;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
