//
//  G8ViewController.m
//  Template Framework Project
//
//  Created by Daniele on 14/10/13.
//  Copyright (c) 2013 Daniele Galiotto - www.g8production.com.
//  All rights reserved.
//

#import "G8ViewController.h"

@interface G8ViewController ()

{
    //为使图片居中显示，load背景图时计算x，y偏离值
    float x_delta;
    float y_delta;
    __block NSString *ocrResult;
    MBProgressHUD *hud;
}

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end


/**
 *  For more information about using `G8Tesseract`, visit the GitHub page at:
 *  https://github.com/gali8/Tesseract-OCR-iOS
 */
@implementation G8ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create a queue to perform recognition operations
    self.operationQueue = [[NSOperationQueue alloc] init];
    [self recognizeImageWithTesseract:_ocrModifyImage];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //常用的设置
    //小矩形的背景色
    hud.color = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];//背景色
    //显示的文字
    hud.labelText = NSLocalizedString(@"识别机器人CC被工头揍醒", @"");
    //是否有庶罩
    hud.dimBackground = NO;
}

-(void)recognizeImageWithTesseract:(UIImage *)image
{
    // Preprocess the image so Tesseract's recognition will be more accurate
    
    UIImage *bwImage = [image g8_blackAndWhite];//因为之前已经用opencv二值化等处理过了，所以此处并不需要再次处理
    
//    UIImage *bwImage = image;
    
    // Animate a progress activity indicator
    [self.activityIndicator startAnimating];

    // Display the preprocessed image to be recognized in the view
    self.imageToRecognize.image = bwImage;

    // Create a new `G8RecognitionOperation` to perform the OCR asynchronously
    // It is assumed that there is a .traineddata file for the language pack
    // you want Tesseract to use in the "tessdata" folder in the root of the
    // project AND that the "tessdata" folder is a referenced folder and NOT
    // a symbolic group in your project
    G8RecognitionOperation *operation = [[G8RecognitionOperation alloc] initWithLanguage:@"chi_sim"];

    // Use the original Tesseract engine mode in performing the recognition
    // (see G8Constants.h) for other engine mode options
    operation.tesseract.engineMode = G8OCREngineModeTesseractOnly;
    
    // Let Tesseract automatically segment the page into blocks of text
    // based on its analysis (see G8Constants.h) for other page segmentation
    // mode options
    operation.tesseract.pageSegmentationMode = G8PageSegmentationModeSparseTextOSD;
    
    // Optionally limit the time Tesseract should spend performing the
    // recognition
    //operation.tesseract.maximumRecognitionTime = 1.0;
    
    // Set the delegate for the recognition to be this class
    // (see `progressImageRecognitionForTesseract` and
    // `shouldCancelImageRecognitionForTesseract` methods below)
    operation.delegate = self;

    // Optionally limit Tesseract's recognition to the following whitelist
    // and blacklist of characters
    //operation.tesseract.charWhitelist = @"01234";
    //operation.tesseract.charBlacklist = @"56789";
    
    // Set the image on which Tesseract should perform recognition
    operation.tesseract.image = bwImage;

    // Optionally limit the region in the image on which Tesseract should
    // perform recognition to a rectangle
    //operation.tesseract.rect = CGRectMake(20, 20, 100, 100);

    // Specify the function block that should be executed when Tesseract
    // finishes performing recognition on the image
    operation.recognitionCompleteBlock = ^(G8Tesseract *tesseract) {
        // Fetch the recognized text
        NSString *recognizedText = tesseract.recognizedText;
        ocrResult = recognizedText;

        NSLog(@"此处为ocr的结果,需要加入对ocr结果字符串的处理:%@", ocrResult);

        // Remove the animated progress activity indicator
        [self.activityIndicator stopAnimating];

        // Spawn an alert with the recognized text
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OCR Result"
                                                        message:recognizedText
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    };

    // Finally, add the recognition operation to the queue
    [self.operationQueue addOperation:operation];
}

/**
 *  This function is part of Tesseract's delegate. It will be called
 *  periodically as the recognition happens so you can observe the progress.
 *
 *  @param tesseract The `G8Tesseract` object performing the recognition.
 */
- (void)progressImageRecognitionForTesseract:(G8Tesseract *)tesseract {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (tesseract.progress<35.0) {
                hud.labelText = NSLocalizedString(@"识别机器人CC被工头揍醒", @"");
            }else if (tesseract.progress<45.0){
                hud.labelText = NSLocalizedString(@"识别机器人CC准备干活", @"");
            }else if (tesseract.progress<70){
                hud.labelText = NSLocalizedString(@"识别机器人CC正在卖力干活", @"");
            }else if (tesseract.progress<85){
                hud.labelText = NSLocalizedString(@"识别机器人CC正被工头鞭打", @"");
            }else if (tesseract.progress<90){
                hud.labelText = NSLocalizedString(@"识别机器人CC在整理数据", @"");
            }else{
                [hud hide:YES];
            }
        });
    });
    NSLog(@"此处可以加入进度条：progress: %lu", (unsigned long)tesseract.progress);
}

/**
 *  This function is part of Tesseract's delegate. It will be called
 *  periodically as the recognition happens so you can cancel the recogntion
 *  prematurely if necessary.
 *
 *  @param tesseract The `G8Tesseract` object performing the recognition.
 *
 *  @return Whether or not to cancel the recognition.
 */
- (BOOL)shouldCancelImageRecognitionForTesseract:(G8Tesseract *)tesseract {
    return NO;  // return YES, if you need to cancel recognition prematurely
}

- (IBAction)openCamera:(id)sender
{
    UIImagePickerController *imgPicker = [UIImagePickerController new];
    imgPicker.delegate = self;

    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imgPicker animated:YES completion:nil];
    }
}

- (IBAction)recognizeSampleImage:(id)sender {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //常用的设置
    //小矩形的背景色
    hud.color = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];//背景色
    //显示的文字
    hud.labelText = NSLocalizedString(@"识别机器人CC被工头揍醒", @"");
    //是否有庶罩
    hud.dimBackground = NO;
    [self recognizeImageWithTesseract:_ocrModifyImage];
}

- (IBAction)clearCache:(id)sender
{
    [G8Tesseract clearCache];
}

- (IBAction)backNavigationAct:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self recognizeImageWithTesseract:image];
}
@end
