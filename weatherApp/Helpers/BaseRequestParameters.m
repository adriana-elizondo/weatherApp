//
//  BaseRequestParameters.m
//  weatherApp
//
//  Created by Adriana Elizondo Aguayo on 5/13/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//

#import "BaseRequestParameters.h"

@implementation BaseRequestParameters

-(instancetype)init{
    if (self = [super init]) {
        self.units = @"metric";
        self.apiKey = @"b45fe41f25991f0ca692c3cf2b0b7427";
    }
    
    return self;
}

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"units": @"units",
             @"apiKey": @"APIKEY"
             };
}

-(NSDictionary *)parametersDictionary
{
    NSDictionary *modelDict = [MTLJSONAdapter JSONDictionaryFromModel:self error:nil];
    NSMutableDictionary *dictWithoutEmptyObjects = [NSMutableDictionary dictionary];
    [modelDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (obj != nil && ![obj isKindOfClass:[NSNull class]])
        {
            dictWithoutEmptyObjects[key] = obj;
        }
    }];
    
    return dictWithoutEmptyObjects;
}

@end
