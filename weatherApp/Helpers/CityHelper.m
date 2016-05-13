//
//  CityHelper.m
//  weatherApp
//
//  Created by Adriana Elizondo Aguayo on 5/13/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//
#import "BaseRequestParameters.h"
#import "CityHelper.h"
#import "ForecastModel.h"
#import "RequestHelper.h"

@interface CityRequestParameters : BaseRequestParameters

@property (nonatomic, strong) NSString *queryParameter;

@end

@implementation CityRequestParameters

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *baseKeyPaths = [super JSONKeyPathsByPropertyKey];
    NSDictionary *classKeyPath = @{
                                   @"queryParameter": @"q",
                                   };
    
    NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc] initWithDictionary:baseKeyPaths];
    [resultDictionary addEntriesFromDictionary:classKeyPath];
    return resultDictionary;
}

@end

@implementation CityHelper

+(void)forecastForcityWithName:(NSString *)cityName WithCompletion:(ForecastCompletion)completionBlock{
    
    CityRequestParameters *parameters = [[CityRequestParameters alloc] init];
    parameters.queryParameter = cityName;
    
    [RequestHelper getRequestWithUrl:@"http://api.openweathermap.org/data/2.5/forecast" parameters:[parameters parametersDictionary] andCompletionBlock:^(id responseObject, NSError *error) {
        NSError *parseError = nil;
        ForecastModel *cityResponse = [MTLJSONAdapter modelOfClass:[ForecastModel class] fromJSONDictionary:responseObject error:&parseError];
        
        if (parseError || error) {
            completionBlock(nil, error);
        }else{
            completionBlock(cityResponse, nil);
        }

    }];

}

@end
