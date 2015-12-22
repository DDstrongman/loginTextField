//
//  HttpManager.h
//  ResultContained
//
//  Created by 李胜书 on 15/8/21.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpManager : NSObject

+(HttpManager *)ShareInstance;

-(void)AFNetGETSupport:(NSString *)url Parameters:(NSDictionary *)dic SucessBlock:(void(^)(AFHTTPRequestOperation *operation, id responseObject))sucess FailedBlock:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failed;

-(void)AFNetPOSTNobodySupport:(NSString *)url Parameters:(NSDictionary *)dic SucessBlock:(void(^)(AFHTTPRequestOperation *operation, id responseObject))sucess FailedBlock:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failed;

-(void)AFNetPOSTSupport:(NSString *)url Parameters:(NSDictionary *)dic ConstructingBodyWithBlock:(void(^)(id<AFMultipartFormData> formData))bodyblock SucessBlock:(void(^)(AFHTTPRequestOperation *operation, id responseObject))sucess FailedBlock:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failed;
-(void)AFNetPUTSupport:(NSString *)url Parameters:(NSDictionary *)dic SucessBlock:(void(^)(AFHTTPRequestOperation *operation, id responseObject))sucess FailedBlock:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failed;

#pragma 同步缓存get请求
-(NSData *)httpGetSupport:(NSString *)url;
-(NSData *)httpPostSupport:(NSString *)urlString PostName:(NSData *)fileData FileType:(NSString *)fileType FileTrail:(NSString *)fileTrail;

@end
