//
//  WriteFileSupport.m
//  ResultContained
//
//  Created by 李胜书 on 15/8/17.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "WriteFileSupport.h"

@implementation WriteFileSupport

+(WriteFileSupport *) ShareInstance{
    static WriteFileSupport *sharedWriteFileInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedWriteFileInstance = [[self alloc] init];
    });
    return sharedWriteFileInstance;
}

#pragma 文件存储操作,documents存储常用文件，tmp存储临时文件，Library/Caches：存放缓存文件，保存应用的持久化数据
//dirName存储的文件夹名字；fileName这个还要解释么，白痴！
-(NSString *)writeFileAndReturn:(NSString *)Dirname FileName:(NSString *)fileName Contents:(UIImage *)contents{
    [self createDir:Dirname];
    NSData *pictureData=[self transformPNG:contents];
    
//    UIImage *jpgContent=[self imageByScalingProportionallyToSize:CGSizeMake(200, 200) sourceImage:contents];
//    NSData *pictureCropData=[self transformJEPG:jpgContent];
    NSString *returnString=[self createFile:fileName DirName:Dirname PictureData:pictureData];
    
//    NSString *returnCropString=[self createCropFile:[fileName stringByAppendingString:@"_th"] DirName:Dirname PictureData:pictureCropData];
    //    NSString *returnString=[self writeFile:contents DirName:Dirname FileName:fileName];
    return returnString;
}

-(NSString *)writeImageAndReturn:(NSString *)Dirname FileName:(NSString *)fileName Contents:(NSData *)contents{
    [self createDir:Dirname];
    NSString *returnString=[self createFile:fileName DirName:Dirname PictureData:contents];
    return returnString;
}

-(NSString *)writeMP3AndReturn:(NSString *)Dirname FileName:(NSString *)fileName Contents:(NSData *)contents{
    [self createDir:Dirname];
    NSString *returnString=[self createMP3File:fileName DirName:Dirname MP3Data:contents];
    return returnString;
}

//创建文件
-(NSString *)createFile:(NSString *)FileName DirName:(NSString *)dirName PictureData:(NSData *)pictureData
{
    NSString *documentsPath =[self dirDoc];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:dirName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testPath =testDirectory;
    BOOL res=[fileManager createFileAtPath:[testPath stringByAppendingFormat:@"/%@.png",FileName] contents:pictureData attributes:nil];
    if (res)
    {
        NSLog(@"文件创建成功: %@" ,testPath);
    }else
    {
        NSLog(@"文件创建失败");
    }
    return [testPath stringByAppendingFormat:@"/%@.png",FileName];
}

//创建文件
-(NSString *)createMP3File:(NSString *)FileName DirName:(NSString *)dirName MP3Data:(NSData *)mp3Data
{
    NSString *documentsPath =[self dirDoc];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:dirName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testPath =testDirectory;
    BOOL res=[fileManager createFileAtPath:[testPath stringByAppendingFormat:@"/%@.mp3",FileName] contents:mp3Data attributes:nil];
    if (res)
    {
        NSLog(@"文件创建成功: %@" ,testPath);
    }else
    {
        NSLog(@"文件创建失败");
    }
    return [testPath stringByAppendingFormat:@"/%@.png",FileName];
}

//创建缩略图
-(NSString *)createCropFile:(NSString *)FileName DirName:(NSString *)dirName PictureData:(NSData *)pictureData
{
    NSString *documentsPath =[self dirDoc];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:dirName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testPath =testDirectory;
    BOOL res=[fileManager createFileAtPath:[testPath stringByAppendingFormat:@"/%@.jpg",FileName] contents:pictureData attributes:nil];
    if (res)
    {
        NSLog(@"文件创建成功: %@" ,testPath);
    }else
    {
        NSLog(@"文件创建失败");
    }
    return [testPath stringByAppendingFormat:@"/%@.jpg",FileName];
}

//读取文件夹下所有图片
-(NSMutableArray *)readPicture:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //在这里获取应用程序Documents文件夹里的文件及文件夹列表
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    //    NSMutableArray *returnPictureArray=[[NSMutableArray alloc] init];
    NSString *picturePath;
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:filePath error:&error];
    //    NSLog(@"%@",fileList);
    NSMutableArray *returnAllInfoArry=[[NSMutableArray alloc]init];
    for(int i=0;i<fileList.count;i++)
    {
        picturePath=[NSString stringWithFormat:@"%@%@%@",filePath,@"/",fileList[i]];
//        UIImage *img = [UIImage imageWithContentsOfFile:picturePath];
//        Item *getMessage=[[Item alloc]init];
//        //        if ([fileList[i] rangeOfString:@".png"].length > 0)
//        //        {
//        //            NSLog(@"格式为png");
//        //            getMessage.fileName=fileList[i];
//        //
//        //        }
//        if([fileList[i] rangeOfString:@".jpg"].length > 0)
//        {
//            //NSLog(@"格式为jpg");
//            getMessage.thFileName=[NSString stringWithFormat:@"%@",fileList[i]];
//            getMessage.fileName=[getMessage.thFileName stringByReplacingOccurrencesOfString:@"_th.jpg" withString:@".png"];
//            //NSLog(@"写入thFileName====%@",getMessage.thFileName);
//            
//            if(img)
//            {
//                getMessage.picture=img;
//                //NSLog(@"img====%@",getMessage.picture);
//                getMessage.thFilePath=picturePath;
//                getMessage.filePath=[getMessage.thFilePath stringByReplacingOccurrencesOfString:@"_th.jpg" withString:@".png"];
//                [returnAllInfoArry addObject:getMessage];
//            }
//        }
//        else
//        {
//            //NSLog(@"读取图片格式出错,非png,jpg");
//        }
        
    }
    
    
//    NSArray *sortedArray = [returnAllInfoArry sortedArrayUsingComparator:^NSComparisonResult(Item *p1, Item *p2){
//        return [p2.fileName compare:p1.fileName];
//    }];
    
    
//    return sortedArray;
    return nil;
}

-(NSInteger)getPictureNumber
{
    NSInteger PictureNumber;
    NSString *documentsPath =[self dirDoc];
    NSError *err;
    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:[documentsPath stringByAppendingPathComponent:kPNGDir] error:&err];
//    PictureNumber=fileList.count;
    
    return PictureNumber/2;
}


//删除文件
-(void)removePicture:(NSString *)filePath
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSError *err;
    BOOL bRet = [fileMgr fileExistsAtPath:filePath];
    if (bRet)
    {
        [fileMgr removeItemAtPath:filePath error:&err];
    }
}

#pragma 剪切
- (UIImage *) imageByScalingProportionallyToSize:(CGSize)targetSize sourceImage:(UIImage *)sourceImage {
    
    UIGraphicsBeginImageContext(targetSize);
    [sourceImage drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma 获取当前时间和设备id处理为需要的字符串
-(NSString *)getTimeAndDeviceString
{
    //    NSString *deviceID  =[[[UIDevice currentDevice] identifierForVendor] UUIDString];
    //    CocoaSecurityResult *sha1 = [CocoaSecurity sha1:[NSString stringWithFormat:@"%@ %@",[self getDateTimeStr],deviceID]];
    //
    //    //16进制变小写
    return [self getDateTimeStr];
}

//取得当前时间字符串
-(NSString*)getDateTimeStr
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    
    NSDate *now = [NSDate date];
    
    NSString *theDate = [dateFormatter stringFromDate:now];
    
    return theDate;
}

#pragma 转化UIImage为NSData样例,方案废弃,改用文件存储image，数据库存储图片存储路径

#pragma PNG
-(NSData *)transformPNG:(UIImage *)image
{
    NSData *insertPngImageData=UIImagePNGRepresentation(image);
    return insertPngImageData;
}

#pragma JEPG
-(NSData *)transformJEPG:(UIImage *)image
{
    NSData *insertJepgImageData=UIImageJPEGRepresentation(image,1.0);
    return insertJepgImageData;
}


//获取根目录路径
-(void)dirHome
{
    NSString *dirHome=NSHomeDirectory();
}

//获取documents路径
-(NSString *)dirDoc
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

//获取Library目录
-(void)dirLib{
    //[NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    NSLog(@"app_home_lib: %@",libraryDirectory);
}

//获取Cache目录
-(void)dirCache{
    NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cacPath objectAtIndex:0];
    NSLog(@"app_home_lib_cache: %@",cachePath);
}

//获取Tmp目录
-(void)dirTmp{
    //[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
    NSString *tmpDirectory = NSTemporaryDirectory();
    NSLog(@"app_home_tmp: %@",tmpDirectory);
}

//创建文件夹
-(void)createDir:(NSString *)DirName
{
    NSString *documentsPath =[self dirDoc];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:DirName];
    // 创建目录
    BOOL res=[fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    if (res)
    {
        NSLog(@"文件夹创建成功 %@",DirName);
    }
    else
    {
        NSLog(@"文件夹创建失败");
    }
}


//写文件
-(NSString *)writeFile:(NSString *)fileDirectory DirName:(NSString *)dirName FileName:(NSString *)fileName
{
    NSString *documentsPath =[self dirDoc];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:dirName];
    NSString *testPath = [testDirectory stringByAppendingPathComponent:fileName];
    NSString *content = fileDirectory;
    BOOL res = [content writeToFile:testPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if (res)
    {
        NSLog(@"文件写入成功,%@",testPath);
    }
    else
    {
        NSLog(@"文件写入失败");
    }
    return testPath;
}

#pragma 读取文件
-(UIImage *)getLocalMark:(NSString *)filePath
{
    UIImage *returnImage;
    returnImage = [UIImage imageNamed:filePath];
    return returnImage;
}

//删除所有documents下文件用以重置用户信息
-(void)removeAllDirDocuments{
    NSString *documentsDirectory = [self dirDoc];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
    }
}

@end
