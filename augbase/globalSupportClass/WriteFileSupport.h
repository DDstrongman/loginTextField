//
//  WriteFileSupport.h
//  ResultContained
//
//  Created by 李胜书 on 15/8/17.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WriteFileSupport : NSObject

@property (nonatomic,strong) NSCache *FileCache;

+(WriteFileSupport *)ShareInstance;

//写图片啥的就靠它
-(NSString *)writeFileAndReturn:(NSString *)Dirname FileName:(NSString *)fileName Contents:(UIImage *)contents;

-(NSString *)writeImageAndReturn:(NSString *)Dirname FileName:(NSString *)fileName Contents:(NSData *)contents;


//获取documents路径
-(NSString *)dirDoc;
//创建文件夹
-(void)createDir:(NSString *)DirName;
//创建文件
-(NSString *)createFile:(NSString *)FileName DirName:(NSString *)dirName PictureData:(NSData *)pictureData;
//删除文件
-(void)removePicture:(NSString *)filePath;

//读取文件夹下所有图片
-(NSMutableArray *)readPicture:(NSString *)filePath;

//读取图片
-(UIImage *)getLocalMark:(NSString *)filePath;

-(void)removeAllDirDocuments;//删除documents下所有文件，用以重置用户信息

-(float)countAllDirDocuments;//获取documents下所有文件的大小，用来建议用户是否删除缓存
-(float)countSingleDirDocuments:(NSString *)fileName;//获取documents下单个文件夹的大小，用来建议用户是否删除缓存
-(float)countSingleDirFile:(NSString *)fileName;//获取documents下单个文件的大小，用来建议用户是否删除缓存
//写数组保存
-(NSString *)writeArray:(NSArray *)contents DirName:(NSString *)dirName FileName:(NSString *)fileName;
//写字典保存
-(NSString *)writeDictionary:(NSDictionary *)contents DirName:(NSString *)dirName FileName:(NSString *)fileName;
//写二进制文件保存
-(NSString *)writeData:(NSData *)contents DirName:(NSString *)dirName FileName:(NSString *)fileName;

-(BOOL)isFileExist:(NSString *)fileName;//文件是否存在
//读取数组
-(NSMutableArray *)readArray:(NSString *)dirName FileName:(NSString *)fileName;
//读取字典
-(NSMutableDictionary *)readDictionary:(NSString *)dirName FileName:(NSString *)fileName;
//读取data
-(NSData *)readData:(NSString *)dirName FileName:(NSString *)fileName;
//删除缓存文件
-(void)removeCache:(NSString *)fileName;
//删除documents下文件，用以重置本地缓存
-(void)removeDirFile:(NSString *)dirName FileName:(NSString *)fileName;
//刷新nscache
-(void)flushCache;


@end
