/*
 步骤如下：
 1.导入AVFoundation框架，引入<AVFoundation/AVFoundation.h>
 2.设置一个用于显示扫描的view
 3.实例化AVCaptureSession、AVCaptureVideoPreviewLayer
 */

#import "ScanQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SetupView.h"

#import "DoctorWebViewViewController.h"

@interface ScanQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>

{
    NSTimer *timer;//滚动计时
}

@property (strong, nonatomic) UIView *viewPreview;
@property (strong, nonatomic) UIView *boxView;
@property (nonatomic) BOOL isReading;
@property (strong, nonatomic) CALayer *scanLayer;
//捕捉会话
@property (nonatomic, strong) AVCaptureSession *captureSession;
//展示layer
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end

@implementation ScanQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

-(void)viewWillAppear:(BOOL)animated{
    [self startReading];
}

- (BOOL)startReading {
    NSError *error;
    
    //1.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //2.用captureDevice创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    //3.创建媒体数据输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    //4.实例化捕捉会话
    _captureSession = [[AVCaptureSession alloc] init];
    
    //4.1.将输入流添加到会话
    [_captureSession addInput:input];
    
    //4.2.将媒体输出流添加到会话中
    [_captureSession addOutput:captureMetadataOutput];
    
    //5.创建串行队列，并加媒体输出流添加到队列当中
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    //5.1.设置代理
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    
    //5.2.设置输出媒体数据类型为QRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    //6.实例化预览图层
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    
    //7.设置预览图层填充方式
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //8.设置图层的frame
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    
    //9.将图层添加到预览view的图层上
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    //10.设置扫描范围
    captureMetadataOutput.rectOfInterest = CGRectMake(0.1f, 0.1f, 0.9f, 0.9f);
    
    UIImageView *backImage = [[UIImageView alloc]init];
    backImage.frame = _viewPreview.frame;
    backImage.contentMode = UIViewContentModeScaleAspectFill;
    backImage.image = [UIImage imageNamed:@"erweimazhezhao"];
    [_viewPreview addSubview:backImage];
    
    //10.1.扫描框
    if ([[[SetupView ShareInstance]doDevicePlatform] isEqualToString:@"iPhone 4S"]||[[[SetupView ShareInstance]doDevicePlatform] isEqualToString:@"iPhone 4"]||[[[SetupView ShareInstance]doDevicePlatform] isEqualToString:@"iPhone 3GS"]||[[[SetupView ShareInstance]doDevicePlatform] isEqualToString:@"iPhone 3G"]||[[[SetupView ShareInstance]doDevicePlatform] isEqualToString:@"iPhone"]) {
        _boxView = [[UIView alloc] initWithFrame:CGRectMake(_viewPreview.bounds.size.width * 0.15625f, _viewPreview.bounds.size.height * 0.132f-45, _viewPreview.bounds.size.width - _viewPreview.bounds.size.width * 0.3125f, _viewPreview.bounds.size.width - _viewPreview.bounds.size.width * 0.3125f)];
    }else{
        _boxView = [[UIView alloc] initWithFrame:CGRectMake(_viewPreview.bounds.size.width * 0.15625f, _viewPreview.bounds.size.height * 0.132f, _viewPreview.bounds.size.width - _viewPreview.bounds.size.width * 0.3125f, _viewPreview.bounds.size.width - _viewPreview.bounds.size.width * 0.3125f)];
    }
    
    [backImage addSubview:_boxView];
    
    UILabel *remindLabel = [[UILabel alloc]init];
    remindLabel.textAlignment = NSTextAlignmentCenter;
    remindLabel.textColor = [UIColor whiteColor];
    remindLabel.text = NSLocalizedString(@"将扫描框对准二维码自动扫描", @"");
    [backImage addSubview:remindLabel];
    [remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_boxView.mas_bottom).with.offset(50);
        make.left.equalTo(@5);
        make.right.equalTo(@-5);
        make.height.equalTo(@30);
    }];
    
    //10.2.扫描线
    _scanLayer = [[CALayer alloc] init];
    _scanLayer.frame = CGRectMake(0,-10,_boxView.bounds.size.width, 1);
    _scanLayer.backgroundColor = themeColor.CGColor;
    
    [_boxView.layer addSublayer:_scanLayer];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
    
    [timer fire];
    
    //10.开始扫描
    [_captureSession startRunning];
    _isReading = YES;
    return YES;
}

-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_scanLayer removeFromSuperlayer];
    [_videoPreviewLayer removeFromSuperlayer];
    [timer invalidate];
    timer = nil;
}

-(void)showDoctorDetail:(NSString *)url{
    if (_isReading) {
        _isReading = NO;
        DoctorWebViewViewController *dwv = [[DoctorWebViewViewController alloc]init];
        dwv.url = url;
        [self.navigationController pushViewController:dwv animated:YES];
    }
}

-(void)openAblum:(UIButton *)sender{
    
}

-(void)setupView{
    self.title = NSLocalizedString(@"扫描二维码", @"");
    _viewPreview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight-22-44)];
    [self.view addSubview:_viewPreview];
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    rightButton.contentHorizontalAlignment  = UIControlContentHorizontalAlignmentRight;
    [rightButton setTitle:NSLocalizedString(@"相册", @"") forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(openAblum:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setupData{
    _captureSession = nil;
}

-(void)viewWillDisappear:(BOOL)animated{
    [self stopReading];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        //判断回传的数据类型
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(showDoctorDetail:) withObject:[metadataObj stringValue] waitUntilDone:NO];
        }
    }
}

- (void)moveScanLayer:(NSTimer *)timer
{
    CGRect frame = _scanLayer.frame;
    if (_boxView.frame.size.height-10< _scanLayer.frame.origin.y) {
        frame.origin.y = -10;
        _scanLayer.frame = frame;
    }else{
        frame.origin.y += 10;
        [UIView animateWithDuration:0.1 animations:^{
            _scanLayer.frame = frame;
        }];
    }
}

- (BOOL)shouldAutorotate
{
    return NO;
}
@end
