//
//  HttpManager.m
//  ResultContained
//
//  Created by 李胜书 on 15/8/21.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "HttpManager.h"

@implementation HttpManager

+(HttpManager *) ShareInstance{
    static HttpManager *sharedHttpManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedHttpManagerInstance = [[self alloc] init];
    });
    return sharedHttpManagerInstance;
}

-(void)AFNetGETSupport:(NSString *)url Parameters:(NSDictionary *)dic SucessBlock:(void(^)(AFHTTPRequestOperation *operation, id responseObject))sucess FailedBlock:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failed{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 60;
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:url parameters:dic success:sucess failure:failed];
}

-(void)AFNetPOSTNobodySupport:(NSString *)url Parameters:(NSDictionary *)dic SucessBlock:(void(^)(AFHTTPRequestOperation *operation, id responseObject))sucess FailedBlock:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failed{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 60;
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:url parameters:dic success:sucess failure:failed];
}

-(void)AFNetPOSTSupport:(NSString *)url Parameters:(NSDictionary *)dic ConstructingBodyWithBlock:(void(^)(id<AFMultipartFormData> formData))bodyblock SucessBlock:(void(^)(AFHTTPRequestOperation *operation, id responseObject))sucess FailedBlock:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failed{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 60;
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:url parameters:dic constructingBodyWithBlock:bodyblock success:sucess failure:failed];
}

-(void)AFNetPUTSupport:(NSString *)url Parameters:(NSDictionary *)dic SucessBlock:(void(^)(AFHTTPRequestOperation *operation, id responseObject))sucess FailedBlock:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failed{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 60;
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager PUT:url parameters:dic success:sucess failure:failed];
}

-(NSData *)httpGetSupport:(NSString *)urlString{
    //第一步，创建URL
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    //第二步，通过URL创建网络请求
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:3];
    //NSURLRequest初始化方法第一个参数：请求访问路径，第二个参数：缓存协议，第三个参数：网络请求超时时间（秒）
    
    //            其中缓存协议是个枚举类型包含：
    //
    //            NSURLRequestUseProtocolCachePolicy（基础策略）
    //
    //            NSURLRequestReloadIgnoringLocalCacheData（忽略本地缓存）
    //
    //            NSURLRequestReturnCacheDataElseLoad（首先使用缓存，如果没有本地缓存，才从原地址下载）
    //
    //            NSURLRequestReturnCacheDataDontLoad（使用本地缓存，从不下载，如果本地没有缓存，则请求失败，此策略多用于离线操作）
    //
    //            NSURLRequestReloadIgnoringLocalAndRemoteCacheData（无视任何缓存策略，无论是本地的还是远程的，总是从原地址重新下载）
    //
    //            NSURLRequestReloadRevalidatingCacheData（如果本地缓存是有效的则不下载，其他任何情况都从原地址重新下载）
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return received;
}

-(NSData *)httpPostSupport:(NSString *)urlString PostName:(NSData *)fileData FileType:(NSString *)fileType FileTrail:(NSString *)fileTrail{
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:3];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@%@\"\r\n",fileTrail,[self gettime],@""]];
    //声明上传文件的格式
    [body appendFormat:[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n",fileType]];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:fileData];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return received;
}

-(NSString *)gettime{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *strUrl = [currentDateStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSString *newdate=[strUrl substringToIndex:8];
    return newdate;
    
}

@end
