//
//  HttpSupportClass.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/30.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "HttpSupportClass.h"

@implementation HttpSupportClass

#pragma xmppsupport单实例初始化
+(HttpSupportClass *) ShareInstance;{
    static HttpSupportClass *sharedHTTPManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedHTTPManagerInstance = [[self alloc] init];
    });
    return sharedHTTPManagerInstance;
}

#pragma afnetworking
-(void)httpAFPostSupport:(NSString *)url Contents:(NSDictionary *)content{
    //1.管理器
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //2.设置登录参数
//    NSDictionary *dict = @{ @"username":@"xn", @"password":@"123" };

    //3.请求
    [manager POST:url parameters:content success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"POST --> %@, %@", responseObject, [NSThread currentThread]); //自动返回主线程
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

-(void)httpAFGetSupport:(NSString *)url{
    //1.管理器
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //2.设置登录参数
//    NSDictionary *dict = @{ @"username":@"xn", @"password":@"123" };
    
    //3.请求
    [manager GET:url parameters:nil success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"GET --> %@, %@", responseObject, [NSThread currentThread]); //自动返回主线程
//        return responseObject;
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
//        return nil;
    }];
}

#pragma ns原生
-(void)httpNSPostSupport:(NSString *)urlString Contents:(id *)content TimeOut:(NSInteger)timeOut{
    //第一步，创建url
    NSURL *url = [NSURL URLWithString:urlString];
    
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOut];
    [request setHTTPMethod:@"POST"];
#warning 没有设置好内容，需要自给设置content内容
    NSString *str = @"type=focus-c";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    //第三步，连接服务器
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

-(void)httpNSGetSupport:(NSString *)urlString TimeOut:(NSInteger)timeOut{
    //第一步，创建url
    NSURL *url = [NSURL URLWithString:urlString];
    
    //第二步，创建请求
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOut];
    //第三步，连接服务器
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

//接收到服务器回应的时候调用此方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    NSLog(@"%@",[res allHeaderFields]);
//    self.receiveData = [NSMutableData data];
}

//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
//    [self.receiveData appendData:data];
}

//数据传完之后调用此方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
//    NSString *receiveStr = [[NSString alloc]initWithData:self.receiveData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",receiveStr);
}

//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"%@",[error localizedDescription]);
}
@end
