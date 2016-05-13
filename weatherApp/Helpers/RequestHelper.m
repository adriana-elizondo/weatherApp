//
//  RequestHelper.m
//  weatherApp
//
//  Created by Adriana Elizondo Aguayo on 5/13/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//

#import "RequestHelper.h"
#import <AFNetworking/AFNetworking.h>

@implementation RequestHelper

+(void)getRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters andCompletionBlock:(RequestCompletion)completionBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        completionBlock(responseObject, nil);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        completionBlock(nil, error);
    }];
}

@end
