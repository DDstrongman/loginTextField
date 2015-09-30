//
//  PhotoView.m
//  PhotoTweaks
//
//  Created by Tu You on 14/12/2.
//  Copyright (c) 2014年 Tu You. All rights reserved.
//

#import "PhotoTweakView.h"
#import "UIColor+Tweak.h"
#import <math.h>

static const int kCropLines = 2;
static const int kGridLines = 9;

static const CGFloat kCropViewHotArea = 16;
static const CGFloat kMinimumCropArea = 60;
static const CGFloat kMaximumCanvasWidthRatio = 0.9;
static const CGFloat kMaximumCanvasHeightRatio = 0.9;
static const CGFloat kCanvasHeaderHeigth = 60;
static const CGFloat kCropViewCornerLength = 22;

static CGFloat distanceBetweenPoints(CGPoint point0, CGPoint point1)
{
    return sqrt(pow(point1.x - point0.x, 2) + pow(point1.y - point0.y, 2));
}

//#define kInstruction

@implementation PhotoContentView

- (instancetype)initWithImage:(UIImage *)image
{
    if (self = [super init]) {
        _image = image;
        
        self.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.image = self.image;
        _imageView.userInteractionEnabled = YES;
        _imageView.backgroundColor= [UIColor whiteColor];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
}

@end

@interface PhotoScrollView : UIScrollView

@property (strong, nonatomic) PhotoContentView *photoContentView;

@end

@implementation PhotoScrollView

- (void)setContentOffsetY:(CGFloat)offsetY
{
    CGPoint contentOffset = self.contentOffset;
    contentOffset.y = offsetY;
    self.contentOffset = contentOffset;
}

- (void)setContentOffsetX:(CGFloat)offsetX
{
    CGPoint contentOffset = self.contentOffset;
    contentOffset.x = offsetX;
    self.contentOffset = contentOffset;
}

- (CGFloat)zoomScaleToBound
{
    CGFloat scaleW = self.bounds.size.width / self.photoContentView.bounds.size.width;
    CGFloat scaleH = self.bounds.size.height / self.photoContentView.bounds.size.height;
    CGFloat max = MAX(scaleW, scaleH);
    
    return max;
}

@end

typedef NS_ENUM(NSInteger, CropCornerType) {
    CropCornerTypeUpperLeft,
    CropCornerTypeUpperRight,
    CropCornerTypeLowerRight,
    CropCornerTypeLowerLeft
};

@interface CropCornerView : UIView

@end

@implementation CropCornerView

- (instancetype)initWithCornerType:(CropCornerType)type
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, kCropViewCornerLength, kCropViewCornerLength);
        self.backgroundColor = [UIColor clearColor];
        
        CGFloat lineWidth = 2;
        UIView *horizontal = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCropViewCornerLength, lineWidth)];
        horizontal.backgroundColor = [UIColor cropLineColor];
        [self addSubview:horizontal];
        
        UIView *vertical = [[UIView alloc] initWithFrame:CGRectMake(0, 0, lineWidth, kCropViewCornerLength)];
        vertical.backgroundColor = [UIColor cropLineColor];
        [self addSubview:vertical];
        
        if (type == CropCornerTypeUpperLeft) {
            horizontal.center = CGPointMake(kCropViewCornerLength / 2, lineWidth / 2);
            vertical.center = CGPointMake(lineWidth / 2, kCropViewCornerLength / 2);
        } else if (type == CropCornerTypeUpperRight) {
            horizontal.center = CGPointMake(kCropViewCornerLength / 2, lineWidth / 2);
            vertical.center = CGPointMake(kCropViewCornerLength - lineWidth / 2, kCropViewCornerLength / 2);
        } else if (type == CropCornerTypeLowerRight) {
            horizontal.center = CGPointMake(kCropViewCornerLength / 2, kCropViewCornerLength - lineWidth / 2);
            vertical.center = CGPointMake(kCropViewCornerLength - lineWidth / 2, kCropViewCornerLength / 2);
        } else if (type == CropCornerTypeLowerLeft) {
            horizontal.center = CGPointMake(kCropViewCornerLength / 2, kCropViewCornerLength - lineWidth / 2);
            vertical.center = CGPointMake(lineWidth / 2, kCropViewCornerLength / 2);
        }
    }
    return self;
}

@end


@interface CropView ()

@property (nonatomic, strong) CropCornerView *upperLeft;
@property (nonatomic, strong) CropCornerView *upperRight;
@property (nonatomic, strong) CropCornerView *lowerRight;
@property (nonatomic, strong) CropCornerView *lowerLeft;

@property (nonatomic, strong) NSMutableArray *horizontalCropLines;
@property (nonatomic, strong) NSMutableArray *verticalCropLines;

@property (nonatomic, strong) NSMutableArray *horizontalGridLines;
@property (nonatomic, strong) NSMutableArray *verticalGridLines;

@property (nonatomic, weak) id<CropViewDelegate> delegate;

@property (nonatomic, assign) BOOL cropLinesDismissed;
@property (nonatomic, assign) BOOL gridLinesDismissed;


@end

@implementation CropView


- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        self.layer.borderColor = [UIColor cropLineColor].CGColor;
        self.layer.borderWidth = 1;
        
        _horizontalCropLines = [NSMutableArray array];
        for (int i = 0; i < kCropLines; i++) {
            UIView *line = [UIView new];
            line.backgroundColor = [UIColor cropLineColor];
            [_horizontalCropLines addObject:line];
            [self addSubview:line];
        }
        
        _verticalCropLines = [NSMutableArray array];
        for (int i = 0; i < kCropLines; i++) {
            UIView *line = [UIView new];
            line.backgroundColor = [UIColor cropLineColor];
            [_verticalCropLines addObject:line];
            [self addSubview:line];
        }
        
        _horizontalGridLines = [NSMutableArray array];
        for (int i = 0; i < kGridLines; i++) {
            UIView *line = [UIView new];
            line.backgroundColor = [UIColor gridLineColor];
            [_horizontalGridLines addObject:line];
            [self addSubview:line];
        }
        
        _verticalGridLines = [NSMutableArray array];
        for (int i = 0; i < kGridLines; i++) {
            UIView *line = [UIView new];
            line.backgroundColor = [UIColor gridLineColor];
            [_verticalGridLines addObject:line];
            [self addSubview:line];
        }
        
        _cropLinesDismissed = YES;
        _gridLinesDismissed = YES;
        
        _upperLeft = [[CropCornerView alloc] initWithCornerType:CropCornerTypeUpperLeft];
        _upperLeft.center = CGPointMake(kCropViewCornerLength / 2, kCropViewCornerLength / 2);
        _upperLeft.autoresizingMask = UIViewAutoresizingNone;
        [self addSubview:_upperLeft];
        
        _upperRight = [[CropCornerView alloc] initWithCornerType:CropCornerTypeUpperRight];
        _upperRight.center = CGPointMake(self.frame.size.width - kCropViewCornerLength / 2, kCropViewCornerLength / 2);
        _upperRight.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:_upperRight];
        
        _lowerRight = [[CropCornerView alloc] initWithCornerType:CropCornerTypeLowerRight];
        _lowerRight.center = CGPointMake(self.frame.size.width - kCropViewCornerLength / 2, self.frame.size.height - kCropViewCornerLength / 2);
        _lowerRight.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:_lowerRight];
        
        _lowerLeft = [[CropCornerView alloc] initWithCornerType:CropCornerTypeLowerLeft];
        _lowerLeft.center = CGPointMake(kCropViewCornerLength / 2, self.frame.size.height - kCropViewCornerLength / 2);
        _lowerLeft.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:_lowerLeft];
    }

        return self;
}

- (void)updateCropLines:(BOOL)animate
{
    // show crop lines
    if (self.cropLinesDismissed) {
        [self showCropLines];
    }
    
    void (^animationBlock)(void) = ^(void) {
        [self updateLines:self.horizontalCropLines horizontal:YES];
        [self updateLines:self.verticalCropLines horizontal:NO];
    };
    
    if (animate) {
        [UIView animateWithDuration:0.1 animations:animationBlock];
    } else {
        animationBlock();
    }
}

- (void)updateGridLines:(BOOL)animate
{
    // show grid lines
    if (self.gridLinesDismissed) {
        [self showGridLines];
    }
    
    void (^animationBlock)(void) = ^(void) {
        
        [self updateLines:self.horizontalGridLines horizontal:YES];
        [self updateLines:self.verticalGridLines horizontal:NO];
    };
    
    if (animate) {
        [UIView animateWithDuration:0.1 animations:animationBlock];
    } else {
        animationBlock();
    }
}

- (void)updateLines:(NSArray *)lines horizontal:(BOOL)horizontal
{
    [lines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *line = (UIView *)obj;
        if (horizontal) {
            line.frame = CGRectMake(0,
                                    (self.frame.size.height / (lines.count + 1)) * (idx + 1),
                                    self.frame.size.width,
                                    1 / [UIScreen mainScreen].scale);
        } else {
            line.frame = CGRectMake((self.frame.size.width / (lines.count + 1)) * (idx + 1),
                                    0,
                                    1 / [UIScreen mainScreen].scale,
                                    self.frame.size.height);
        }
    }];
}

- (void)dismissCropLines
{
    [UIView animateWithDuration:0.1 animations:^{
        [self dismissLines:self.horizontalCropLines];
        [self dismissLines:self.verticalCropLines];
    } completion:^(BOOL finished) {
        self.cropLinesDismissed = YES;
    }];
}

- (void)dismissGridLines
{
    [UIView animateWithDuration:0.1 animations:^{
        [self dismissLines:self.horizontalGridLines];
        [self dismissLines:self.verticalGridLines];
    } completion:^(BOOL finished) {
        self.gridLinesDismissed = YES;
    }];
}

- (void)dismissLines:(NSArray *)lines
{
    [lines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ((UIView *)obj).alpha = 0.0f;
    }];
}

- (void)showCropLines
{
    self.cropLinesDismissed = NO;
    [UIView animateWithDuration:0.1 animations:^{
        [self showLines:self.horizontalCropLines];
        [self showLines:self.verticalCropLines];
    }];
}

- (void)showGridLines
{
    self.gridLinesDismissed = NO;
    [UIView animateWithDuration:0.1 animations:^{
        [self showLines:self.horizontalGridLines];
        [self showLines:self.verticalGridLines];
    }];
}

- (void)showLines:(NSArray *)lines
{
    [lines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ((UIView *)obj).alpha = 1.0f;
    }];
}

@end

@interface PhotoTweakView () <UIScrollViewDelegate, CropViewDelegate>

@property (nonatomic, strong) PhotoScrollView *scrollView;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UISegmentedControl *rationSegment;

@property (nonatomic, strong) UIButton *resetBtn;
@property (nonatomic, assign) CGSize originalSize;

@property (nonatomic, assign) BOOL manualZoomed;

// masks
@property (nonatomic, strong) UIView *topMask;
@property (nonatomic, strong) UIView *leftMask;
@property (nonatomic, strong) UIView *bottomMask;
@property (nonatomic, strong) UIView *rightMask;

// constants
@property (nonatomic, assign) CGSize maximumCanvasSize;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGPoint originalPoint;


@end

@implementation PhotoTweakView

@synthesize rationSegment;

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image CameraStyle:(CameraSegmentStyle)Style
{
    if (self = [super init]) {
        
        self.frame = frame;
        
        _image = image;
        
        // scale the image
        _maximumCanvasSize = CGSizeMake(kMaximumCanvasWidthRatio * self.frame.size.width,
                                            kMaximumCanvasHeightRatio * self.frame.size.height - kCanvasHeaderHeigth);
        
        CGFloat scaleX = image.size.width / self.maximumCanvasSize.width;
        CGFloat scaleY = image.size.height / self.maximumCanvasSize.height;
        CGFloat scale = MAX(scaleX, scaleY);
        CGRect bounds = CGRectMake(0, 0, image.size.width / scale, image.size.height / scale);
        _originalSize = bounds.size;
        
        _centerY = self.maximumCanvasSize.height / 3 + kCanvasHeaderHeigth+20;
        
        _scrollView = [[PhotoScrollView alloc] initWithFrame:bounds];
        _scrollView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, self.centerY);
        _scrollView.bounces = YES;
        _scrollView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.delegate = self;
        _scrollView.minimumZoomScale = 1;
        _scrollView.maximumZoomScale = 10;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.clipsToBounds = NO;
        _scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        [self addSubview:_scrollView];
#ifdef kInstruction
        _scrollView.layer.borderColor = [UIColor redColor].CGColor;
        _scrollView.layer.borderWidth = 1;
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.showsHorizontalScrollIndicator = YES;
#endif
        
        _photoContentView = [[PhotoContentView alloc] initWithImage:image];
        _photoContentView.frame = self.scrollView.bounds;
        _photoContentView.backgroundColor = [UIColor clearColor];
        _photoContentView.userInteractionEnabled = YES;
        _scrollView.photoContentView = self.photoContentView;
        [self.scrollView addSubview:_photoContentView];
        
        
        NSUserDefaults *defs=[NSUserDefaults standardUserDefaults];
        if ([defs integerForKey:@"Ratio"]==169) {
            _cropView = [[CropView alloc] initWithFrame:CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.width/16*9)];
            _cropView.center = self.scrollView.center;
        }else if([defs integerForKey:@"Ratio"]==11){
            _cropView = [[CropView alloc] initWithFrame:CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.width)];
            _cropView.center = self.scrollView.center;
        }else if([defs integerForKey:@"Ratio"]==916){
            _cropView = [[CropView alloc] initWithFrame:CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y,  ViewHeight*9/16, ViewHeight)];
            _cropView.center = CGPointMake(self.scrollView.center.x,self.scrollView.center.y+10);
        }else if([defs integerForKey:@"Ratio"]==34){
            _cropView = [[CropView alloc] initWithFrame:CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.height*3/4, self.scrollView.frame.size.height)];
            _cropView.center = self.scrollView.center;
        }else{
            _cropView = [[CropView alloc] initWithFrame:CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.width*3/4)];
            _cropView.center = self.scrollView.center;
        }
        
        _cropView.delegate = self;
        [self addSubview:_cropView];
        [self cropEnded:_cropView];
        
        
        UIColor *maskColor = [UIColor maskColor];
        _topMask = [UIView new];
        _topMask.backgroundColor = maskColor;
        [self addSubview:_topMask];
        _leftMask = [UIView new];
        _leftMask.backgroundColor = maskColor;
        [self addSubview:_leftMask];
        _bottomMask = [UIView new];
        _bottomMask.backgroundColor = maskColor;
        [self addSubview:_bottomMask];
        _rightMask = [UIView new];
        _rightMask.backgroundColor = maskColor;
        [self addSubview:_rightMask];
        [self updateMasks:NO];
        
        _slider = [[UISlider alloc] initWithFrame:CGRectMake( 0,0, 200, 20)];
        _slider.center = CGPointMake(ViewWidth/2, CGRectGetHeight(self.bounds) - 95);
        _slider.minimumValue = 0.0f;
        _slider.maximumValue = M_PI;
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(sliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside];
        _slider.value = M_PI/2;
        _slider.tintColor = [UIColor whiteColor];
        [self addSubview:_slider];
        
        //_resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //_resetBtn.frame = CGRectMake(0, 0, 60, 20);
        _resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 30, 30)];
        [_resetBtn setImage:[UIImage imageNamed:@"reset_white"] forState:UIControlStateNormal];
    
        _resetBtn.center = CGPointMake(ViewWidth - 25, ViewHeight - 95);
        _resetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_resetBtn setTitleColor:[UIColor resetButtonColor] forState:UIControlStateNormal];
        [_resetBtn setTitleColor:[UIColor resetButtonHighlightedColor] forState:UIControlStateHighlighted];
        [_resetBtn setTitle:NSLocalizedStringFromTable(@"Reset", @"PhotoTweaks", nil) forState:UIControlStateNormal];
        [_resetBtn addTarget:self action:@selector(resetBtnTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_resetBtn];
        
        NSLog(@"cameraStyle====%ld",(long)Style);
        
        NSArray *segmentArray = [NSArray arrayWithObjects:@"1:1",@"16:9",@"4:3",@"9:16",@"3:4",nil];
        rationSegment =[[UISegmentedControl alloc] initWithItems:segmentArray];
        rationSegment.frame = CGRectMake(0, 0, 240,30);
        rationSegment.center=CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) - 55);
        rationSegment.tintColor = [UIColor whiteColor];
        
        if ([defs integerForKey:@"Ratio"]==11) {
            rationSegment.selectedSegmentIndex = 0; //昭和を選択
        }else if([defs integerForKey:@"Ratio"]==169){
            rationSegment.selectedSegmentIndex = 1;
        }else if([defs integerForKey:@"Ratio"]==916){
            rationSegment.selectedSegmentIndex = 3;
        }else if([defs integerForKey:@"Ratio"]==34){
            rationSegment.selectedSegmentIndex = 4;
        }else{
            rationSegment.selectedSegmentIndex = 2;
        }
        
        rationSegment.enabled = YES;
        //値が変更された時にhogeメソッドを呼び出す
        [rationSegment addTarget:self action:@selector(chooseRatio:) forControlEvents:UIControlEventValueChanged];
//        if(Style!=CameraSegmentStyle11)
//        {
            [self addSubview:rationSegment];
//        }
//        else
//        {
//            //[self addSubview:rationSegment];
//            rationSegment.selectedSegmentIndex=0;
//        }
        //[self bringSubviewToFront:rationSegment];
        
        
        _originalPoint = [self convertPoint:self.scrollView.center toView:self];
    }
    return self;
}

-(void)chooseRatio:(UISegmentedControl*)seg{
    NSUserDefaults *defs=[NSUserDefaults standardUserDefaults];
    switch (seg.selectedSegmentIndex) {
        case 0:
        {
            [defs setInteger:11 forKey:@"Ratio"];
            [_cropView removeFromSuperview];
            _cropView = [[CropView alloc] initWithFrame:CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.width)];
            _cropView.center = self.scrollView.center;
            _cropView.delegate = self;
            [self addSubview:_cropView];
            [self cropEnded:_cropView];
            [self resetBtnTapped];
            break;
        }
            
        case 1:
        {
            [defs setInteger:169 forKey:@"Ratio"];
            [_cropView removeFromSuperview];
            _cropView = [[CropView alloc] initWithFrame:CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.width/16*9)];
            _cropView.center = self.scrollView.center;
            _cropView.delegate = self;
            [self addSubview:_cropView];
            [self cropEnded:_cropView];
            [self resetBtnTapped];
            break;
        }
            
            
        case 2:
        {
            [defs setInteger:43 forKey:@"Ratio"];
            [_cropView removeFromSuperview];
            _cropView = [[CropView alloc] initWithFrame:CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.width/4*3)];
            _cropView.center = self.scrollView.center;
            _cropView.delegate = self;
            [self addSubview:_cropView];
            [self cropEnded:_cropView];
            [self resetBtnTapped];
            break;
        }
            
        case 3:
        {
            [defs setInteger:916 forKey:@"Ratio"];
            [_cropView removeFromSuperview];
            _cropView = [[CropView alloc] initWithFrame:CGRectMake(self.scrollView.frame.origin.x, 10, ViewHeight*9/16, ViewHeight)];
            //_cropView.center = self.scrollView.center;
            _cropView.center = CGPointMake(self.scrollView.center.x,self.scrollView.center.y+10);
            _cropView.delegate = self;
            [self addSubview:_cropView];
            [self cropEnded:_cropView];
            [self resetBtnTapped];
            break;
        }

            
        case 4:
        {
            [defs setInteger:34 forKey:@"Ratio"];
            [_cropView removeFromSuperview];
            _cropView = [[CropView alloc] initWithFrame:CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.height*3/4, self.scrollView.frame.size.height)];
            _cropView.center = self.scrollView.center;
            _cropView.delegate = self;
            [self addSubview:_cropView];
            [self cropEnded:_cropView];
            [self resetBtnTapped];
            break;
        }
            
            
        default:
            break;
    }
    
    
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(self.slider.frame, point)) {
        return self.slider;
    } else if (CGRectContainsPoint(self.resetBtn.frame, point)) {
        return self.resetBtn;
    } else if (CGRectContainsPoint(CGRectInset(self.cropView.frame, -kCropViewHotArea, -kCropViewHotArea), point) && !CGRectContainsPoint(CGRectInset(self.cropView.frame, kCropViewHotArea, kCropViewHotArea), point)) {
        return self.cropView;
    }else if (CGRectContainsPoint(rationSegment.frame, point))
    {
        return rationSegment;
    }
    return self.scrollView;
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.photoContentView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    self.manualZoomed = YES;
}

#pragma mark - Crop View Delegate

- (void)cropMoved:(CropView *)cropView
{
    [self updateMasks:NO];
}

- (void)cropEnded:(CropView *)cropView
{
    CGFloat scaleX = self.originalSize.width / cropView.bounds.size.width;
    CGFloat scaleY = self.originalSize.height / cropView.bounds.size.height;
    CGFloat scale = MIN(scaleX, scaleY);
    
    // calculate the new bounds of crop view
    CGRect newCropBounds = CGRectMake(0, 0, scale * cropView.frame.size.width, scale * cropView.frame.size.height);
    
    // calculate the new bounds of scroll view
    CGFloat width = cos(fabs(self.angle)) * newCropBounds.size.width + sin(fabs(self.angle)) * newCropBounds.size.height;
    CGFloat height = sin(fabs(self.angle)) * newCropBounds.size.width + cos(fabs(self.angle)) * newCropBounds.size.height;
    
    // calculate the zoom area of scroll view
    CGRect scaleFrame = cropView.frame;
    if (scaleFrame.size.width >= self.scrollView.bounds.size.width) {
        scaleFrame.size.width = self.scrollView.bounds.size.width - 1;
    }
    if (scaleFrame.size.height >= self.scrollView.bounds.size.height) {
        scaleFrame.size.height = self.scrollView.bounds.size.height - 1;
    }
    
    CGPoint contentOffset = self.scrollView.contentOffset;
    CGPoint contentOffsetCenter = CGPointMake(contentOffset.x + self.scrollView.bounds.size.width / 2, contentOffset.y + self.scrollView.bounds.size.height / 2);
    CGRect bounds = self.scrollView.bounds;
    bounds.size.width = width;
    bounds.size.height = height;
    self.scrollView.bounds = CGRectMake(0, 0, width, height);
    CGPoint newContentOffset = CGPointMake(contentOffsetCenter.x - self.scrollView.bounds.size.width / 2, contentOffsetCenter.y - self.scrollView.bounds.size.height / 2);
    self.scrollView.contentOffset = newContentOffset;
    
    [UIView animateWithDuration:0.1 animations:^{
        // animate crop view
        cropView.bounds = CGRectMake(0, 0, newCropBounds.size.width, newCropBounds.size.height);
        cropView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, self.centerY);
        
        // zoom the specified area of scroll view
        CGRect zoomRect = [self convertRect:scaleFrame toView:self.scrollView.photoContentView];
        [self.scrollView zoomToRect:zoomRect animated:NO];
    }];

    self.manualZoomed = YES;
    
    // update masks
    [self updateMasks:YES];
    
    [self.cropView dismissCropLines];
    
    CGFloat scaleH = self.scrollView.bounds.size.height / self.scrollView.contentSize.height;
    CGFloat scaleW = self.scrollView.bounds.size.width / self.scrollView.contentSize.width;
    __block CGFloat scaleM = MAX(scaleH, scaleW);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (scaleM > 1) {
            scaleM = scaleM * self.scrollView.zoomScale;
            [self.scrollView setZoomScale:scaleM animated:NO];
        }
        [UIView animateWithDuration:0.1 animations:^{
            [self checkScrollViewContentOffset];
        }];
    });
}

- (void)updateMasks:(BOOL)animate
{
    void (^animationBlock)(void) = ^(void) {
        self.topMask.frame = CGRectMake(0, 0, self.cropView.frame.origin.x + self.cropView.frame.size.width, self.cropView.frame.origin.y);
        self.leftMask.frame = CGRectMake(0, self.cropView.frame.origin.y, self.cropView.frame.origin.x, self.frame.size.height - self.cropView.frame.origin.y);
        self.bottomMask.frame = CGRectMake(self.cropView.frame.origin.x, self.cropView.frame.origin.y + self.cropView.frame.size.height, self.frame.size.width - self.cropView.frame.origin.x, self.frame.size.height - (self.cropView.frame.origin.y + self.cropView.frame.size.height));
        self.rightMask.frame = CGRectMake(self.cropView.frame.origin.x + self.cropView.frame.size.width, 0, self.frame.size.width - (self.cropView.frame.origin.x + self.cropView.frame.size.width), self.cropView.frame.origin.y + self.cropView.frame.size.height);
    };
    
    if (animate) {
        [UIView animateWithDuration:0.1 animations:animationBlock];
    } else {
        animationBlock();
    }
}

- (void)checkScrollViewContentOffset
{
    self.scrollView.contentOffsetX = MAX(self.scrollView.contentOffset.x, 0);
    self.scrollView.contentOffsetY = MAX(self.scrollView.contentOffset.y, 0);
    
    if (self.scrollView.contentSize.height - self.scrollView.contentOffset.y <= self.scrollView.bounds.size.height) {
        self.scrollView.contentOffsetY = self.scrollView.contentSize.height - self.scrollView.bounds.size.height;
    }
    
    if (self.scrollView.contentSize.width - self.scrollView.contentOffset.x <= self.scrollView.bounds.size.width) {
        self.scrollView.contentOffsetX = self.scrollView.contentSize.width - self.scrollView.bounds.size.width;
    }
}

- (void)sliderValueChanged:(id)sender
{
    // update masks
    [self updateMasks:NO];
    
    // update grids
    [self.cropView updateGridLines:NO];
    
    // rotate scroll view
    self.angle = self.slider.value - M_PI/2;
    self.scrollView.transform = CGAffineTransformMakeRotation(self.angle);
    
    // position scroll view
    CGFloat width = cos(fabs(self.angle)) * self.cropView.frame.size.width + sin(fabs(self.angle)) * self.cropView.frame.size.height;
    CGFloat height = sin(fabs(self.angle)) * self.cropView.frame.size.width + cos(fabs(self.angle)) * self.cropView.frame.size.height;
    CGPoint center = self.scrollView.center;
    
    CGPoint contentOffset = self.scrollView.contentOffset;
    CGPoint contentOffsetCenter = CGPointMake(contentOffset.x + self.scrollView.bounds.size.width / 2, contentOffset.y + self.scrollView.bounds.size.height / 2);
    self.scrollView.bounds = CGRectMake(0, 0, width, height);
    CGPoint newContentOffset = CGPointMake(contentOffsetCenter.x - self.scrollView.bounds.size.width / 2, contentOffsetCenter.y - self.scrollView.bounds.size.height / 2);
    self.scrollView.contentOffset = newContentOffset;
    self.scrollView.center = center;
    
    // scale scroll view
    BOOL shouldScale = self.scrollView.contentSize.width / self.scrollView.bounds.size.width <= 1.0 || self.scrollView.contentSize.height / self.scrollView.bounds.size.height <= 1.0;
    if (!self.manualZoomed || shouldScale) {
        [self.scrollView setZoomScale:[self.scrollView zoomScaleToBound] animated:NO];
        self.scrollView.minimumZoomScale = [self.scrollView zoomScaleToBound];

        self.manualZoomed = NO;
    }
    
    [self checkScrollViewContentOffset];
}

- (void)sliderTouchEnded:(id)sender
{
    [self.cropView dismissGridLines];
}

- (void)resetBtnTapped
{
    [UIView animateWithDuration:0.1 animations:^{
        self.angle = 0;
        
        self.scrollView.transform = CGAffineTransformIdentity;
        self.scrollView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, self.centerY);
        self.scrollView.bounds = CGRectMake(0, 0, self.originalSize.width, self.originalSize.height);
        self.scrollView.minimumZoomScale = 1;
        [self.scrollView setZoomScale:1 animated:NO];
        
        //self.cropView.frame = self.scrollView.frame;
        //self.cropView.center = self.scrollView.center;
        [self updateMasks:NO];
        
        [self.slider setValue:M_PI/2 animated:YES];
        [self cropEnded:_cropView];
    }];
}

- (CGPoint)photoTranslation
{
    CGRect rect = [self.photoContentView convertRect:self.photoContentView.bounds toView:self];
    CGPoint point = CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
    CGPoint zeroPoint = CGPointMake(CGRectGetWidth(self.frame) / 2, self.centerY);
    return CGPointMake(point.x - zeroPoint.x, point.y - zeroPoint.y);
}

@end
