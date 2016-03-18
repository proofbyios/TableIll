//
//  AOServerManager.m
//  LuizaHeyTable
//
//  Created by admin on 3/7/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "AOServerManager.h"
#import "AFNetworking.h"

@implementation AOServerManager

+ (AOServerManager*)sharedManager {
    
    static AOServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AOServerManager alloc] init];
    });
    
    return manager;
}

- (void) getPictureFromServerOnSuccess:(void(^)(NSDictionary* response)) success orFailure:(void(^)(NSError* error)) failure {
    
    NSString* urlSrting = @"http://sunstorm.tk/api/";
    
    [[AFHTTPSessionManager manager] GET:urlSrting parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
