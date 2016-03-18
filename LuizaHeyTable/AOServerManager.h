//
//  AOServerManager.h
//  LuizaHeyTable
//
//  Created by admin on 3/7/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AOServerManager : NSObject

+ (AOServerManager*)sharedManager;

- (void) getPictureFromServerOnSuccess:(void(^)(NSDictionary* response)) success orFailure:(void(^)(NSError* error)) failure;

@end
