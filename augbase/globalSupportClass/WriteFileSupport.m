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
    NSString *returnString=[self createFile:fileName DirName:Dirname PictureData:pictureData];
    return returnString;
}

-(NSString *)writeImageAndReturn:(NSString *)Dirname FileName:(NSString *)fileName Contents:(NSData *)contents{
    [self createDir:Dirname];
    NSString *returnString=[self createFile:fileName DirName:Dirname PictureData:contents];
    return returnString;
}

//创建文件
-(NSString *)createFile:(NSString *)FileName DirName:(NSString *)dirName PictureData:(NSData *)pictureData
{
    NSString *documentsPath =[self dirDoc];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:dirName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testPath =testDirectory;
    NSString *filePath = [testPath stringByAppendingFormat:@"/%@.png",FileName];
    BOOL res;
    if(![fileManager fileExistsAtPath:filePath]) //如果不存在
        res = [fileManager createFileAtPath:filePath contents:pictureData attributes:nil];
    return filePath;
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
    NSString *picturePath;
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:filePath error:&error];
    for(int i=0;i<fileList.count;i++){
        picturePath=[NSString stringWithFormat:@"%@%@%@",filePath,@"/",fileList[i]];
    }
    return nil;
}

//删除文件
-(void)removePicture:(NSString *)filePath{
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
-(NSString *)getTimeAndDeviceString{
    return [self getDateTimeStr];
}

//取得当前时间字符串
-(NSString*)getDateTimeStr{
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

//获取documents路径
-(NSString *)dirDoc{
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
    BOOL res = [fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    if (res){
        
    }
    else{
        NSLog(@"文件夹创建失败");
    }
}

//写数组
-(NSString *)writeArray:(NSArray *)contents DirName:(NSString *)dirName FileName:(NSString *)fileName
{
    NSString *documentsPath =[self dirDoc];
    if (!_FileCache) {
        _FileCache = [[NSCache alloc]init];
    }
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:dirName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:testDirectory]) {
        [self createDir:dirName];
    }
    NSString *testPath = [testDirectory stringByAppendingPathComponent:fileName];
    BOOL res = [contents writeToFile:testPath atomically:YES];
    
    if (fileName != nil&&contents != nil) {
        [_FileCache setObject:contents forKey:fileName];
    }
    if (res){
        
    }
    else{
        NSLog(@"数组写入失败");
    }
    return testPath;
}

//写字典
-(NSString *)writeDictionary:(NSDictionary *)contents DirName:(NSString *)dirName FileName:(NSString *)fileName
{
    NSString *documentsPath =[self dirDoc];
    if (!_FileCache) {
        _FileCache = [[NSCache alloc]init];
    }
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:dirName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:testDirectory]) {
        [self createDir:dirName];
    }
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:contents];
    NSString *testPath = [testDirectory stringByAppendingPathComponent:fileName];
    BOOL res = [myData writeToFile:testPath atomically:YES];
    if (fileName != nil&&contents != nil) {
        [_FileCache setObject:contents forKey:fileName];
    }
    if (res){
        
    }
    else{
        NSLog(@"字典写入失败");
    }
    return testPath;
}

-(NSString *)writeData:(NSData *)contents DirName:(NSString *)dirName FileName:(NSString *)fileName{
    NSString *documentsPath =[self dirDoc];
    if (!_FileCache) {
        _FileCache = [[NSCache alloc]init];
    }
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:dirName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:testDirectory]) {
        [self createDir:dirName];
    }
    NSString *testPath = [testDirectory stringByAppendingPathComponent:fileName];
    BOOL res = [contents writeToFile:testPath atomically:YES];
    if (fileName != nil&&contents != nil) {
        [_FileCache setObject:contents forKey:fileName];
    }
    if (res){
        
    }
    else{
        NSLog(@"data写入失败");
    }
    return testPath;
}

-(BOOL)isFileExist:(NSString *)fileName{
    BOOL isExist;
    NSString *documentsPath =[self dirDoc];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    isExist = [fileManager fileExistsAtPath:testDirectory];
    return isExist;
}

-(NSMutableArray *)readArray:(NSString *)dirName FileName:(NSString *)fileName{
    NSMutableArray *tempArray = [NSMutableArray array];
    BOOL isExist;
    NSString *documentsPath =[self dirDoc];
    if (!_FileCache) {
        _FileCache = [[NSCache alloc]init];
    }
    NSString *tempPath = [documentsPath stringByAppendingPathComponent:dirName];
    NSString *testDirectory = [tempPath stringByAppendingPathComponent:fileName];
    
    NSMutableArray *cacheData = [_FileCache objectForKey:fileName];
    if(cacheData){
        return cacheData;
    }else{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        isExist = [fileManager fileExistsAtPath:testDirectory];
        if (isExist) {
            tempArray = [NSMutableArray arrayWithContentsOfFile:testDirectory];
            [_FileCache setObject:tempArray forKey:fileName];
            return tempArray;
        }else{
            return nil;
        }
    }
}

-(NSMutableDictionary *)readDictionary:(NSString *)dirName FileName:(NSString *)fileName{
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    BOOL isExist;
    NSString *documentsPath =[self dirDoc];
    if (!_FileCache) {
        _FileCache = [[NSCache alloc]init];
    }
    NSString *tempPath = [documentsPath stringByAppendingPathComponent:dirName];
    NSString *testDirectory = [tempPath stringByAppendingPathComponent:fileName];
    
    NSMutableDictionary *cacheData = [_FileCache objectForKey:fileName];
    if(cacheData){
        return cacheData;
    }else{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        isExist = [fileManager fileExistsAtPath:testDirectory];
        if (isExist) {
            tempDic = (NSMutableDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:testDirectory]];
            [_FileCache setObject:tempDic forKey:fileName];
            return tempDic;
        }else{
            return nil;
        }
    }
}

-(NSData *)readData:(NSString *)dirName FileName:(NSString *)fileName{
    NSData *tempData;
    BOOL isExist;
    NSString *documentsPath =[self dirDoc];
    if (!_FileCache) {
        _FileCache = [[NSCache alloc]init];
    }
    NSString *tempPath = [documentsPath stringByAppendingPathComponent:dirName];
    NSString *testDirectory = [tempPath stringByAppendingPathComponent:fileName];
    NSData *cacheData = [_FileCache objectForKey:fileName];
    if(cacheData){
        return cacheData;
    }else{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        isExist = [fileManager fileExistsAtPath:testDirectory];
        if (isExist) {
            tempData = [NSData dataWithContentsOfFile:testDirectory];
            [_FileCache setObject:tempData forKey:fileName];
            return tempData;
        }else{
            return nil;
        }
    }
}

-(void)removeDirFile:(NSString *)dirName FileName:(NSString *)fileName{
    BOOL isExist;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [self dirDoc];
    NSString *tempPath = [documentsPath stringByAppendingPathComponent:dirName];
    NSString *finalPath = [tempPath stringByAppendingPathComponent:fileName];
    isExist = [fileManager fileExistsAtPath:finalPath];
    if (isExist)
        [fileManager removeItemAtPath:finalPath error:NULL];
}

-(void)flushCache{
    [_FileCache removeAllObjects];
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
        NSString *temp = [documentsDirectory stringByAppendingPathComponent:filename];
        [fileManager removeItemAtPath:temp error:NULL];
    }
}
//计算缓存大小
-(float)countAllDirDocuments{
    NSString *documentsDirectory = [self dirDoc];
    float size = [self folderSizeAtPath:documentsDirectory];
    return size;
}

-(float)countSingleDirDocuments:(NSString *)fileName{
    NSString *documentsDirectory = [self dirDoc];
    NSString *temp = [documentsDirectory stringByAppendingPathComponent:fileName];
    float size = [self folderSizeAtPath:temp];
    return size;
}

-(float)countSingleDirFile:(NSString *)fileName{
    NSString *documentsDirectory = [self dirDoc];
    NSString *temp = [documentsDirectory stringByAppendingPathComponent:fileName];
    float size = [self fileSizeAtPath:temp];
    return size/(1024.0*1024.0);
}

-(void)removeCache:(NSString *)fileName{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSError *err;
    NSString *documentsDirectory = [self dirDoc];
    NSString *temp = [documentsDirectory stringByAppendingPathComponent:fileName];
    BOOL bRet = [fileMgr fileExistsAtPath:temp];
    if (bRet){
        [fileMgr removeItemAtPath:temp error:&err];
    }
}

//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//遍历文件夹获得文件夹大小，返回多少M
-(float )folderSizeAtPath:(NSString*) folderPath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
        
    }
    return folderSize/(1024.0*1024.0);
}


@end
