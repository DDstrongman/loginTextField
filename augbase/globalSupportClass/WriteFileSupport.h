//
//  WriteFileSupport.h
//  ResultContained
//
//  Created by 李胜书 on 15/8/17.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WriteFileSupport : NSObject

+(WriteFileSupport *)ShareInstance;

//最终奥义，北斗友情破颜拳！！这个函数就是所有的终极必杀！写图片啥的就靠它
-(NSString *)writeFileAndReturn:(NSString *)Dirname FileName:(NSString *)fileName Contents:(UIImage *)contents;

-(NSString *)writeImageAndReturn:(NSString *)Dirname FileName:(NSString *)fileName Contents:(NSData *)contents;

-(NSString *)writeMP3AndReturn:(NSString *)Dirname FileName:(NSString *)fileName Contents:(NSData *)contents;

//获取documents路径
-(NSString *)dirDoc;
//创建文件夹
-(void)createDir:(NSString *)DirName;
//创建文件
-(NSString *)createFile:(NSString *)FileName DirName:(NSString *)dirName PictureData:(NSData *)pictureData;
//写文件
-(NSString *)writeFile:(NSString *)fileDirectory DirName:(NSString *)dirName FileName:(NSString *)fileName;
//删除文件
-(void)removePicture:(NSString *)filePath;

//读取文件夹下所有图片
-(NSMutableArray *)readPicture:(NSString *)filePath;

-(NSInteger)getPictureNumber;

//读取图片
-(UIImage *)getLocalMark:(NSString *)filePath;

@end
