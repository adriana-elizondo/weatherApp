//
//  SearchHelper.m
//  weatherApp
//
//  Created by Adriana Elizondo on 5/14/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//
#import "RequestHelper.h"
#import "SearchHelper.h"

#define SEARCH_URL @"http://gd.geobytes.com/AutoCompleteCity"

@implementation SearchHelper

+(void)getListOfCitiesWithString:(NSString *)string withCompletion:(SearchResult)completion{
    NSDictionary *parameters = @{@"q":string};
    [RequestHelper getRequestWithUrl:SEARCH_URL parameters:parameters andCompletionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSArray *results = responseObject;
                if (results.count > 0 && ![results[0] isEqualToString:@"%s"]){
                    completion(responseObject, nil);
                }
            }
        }else{
            completion(nil, error);
        }
    }];
}

@end
