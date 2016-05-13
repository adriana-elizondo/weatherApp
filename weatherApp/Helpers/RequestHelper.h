//
//  RequestHelper.h
//  weatherApp
//
//  Created by Adriana Elizondo Aguayo on 5/13/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RequestCompletion)(id responseObject, NSError *error);

@interface RequestHelper : NSObject

+(void)getRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters andCompletionBlock:(RequestCompletion)completionBlock;

@end
