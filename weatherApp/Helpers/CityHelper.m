//
//  CityHelper.m
//  weatherApp
//
//  Created by Adriana Elizondo Aguayo on 5/13/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//
#import "BaseRequestParameters.h"
#import "City.h"
#import "CityHelper.h"
#import "CoreDataHelper.h"
#import "ForecastModel.h"
#import "FormattingHelper.h"
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

@interface NextDaysRequestParameters : BaseRequestParameters

@property (nonatomic, strong) NSString *queryParameter;
@property (nonatomic, assign) int count;

@end

@implementation NextDaysRequestParameters

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *baseKeyPaths = [super JSONKeyPathsByPropertyKey];
    NSDictionary *classKeyPath = @{
                                   @"queryParameter": @"q",
                                   @"count": @"cnt",
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

+(void)forecastForNextDaysForCity:(NSString *)cityName WithCompletion:(ForecastCompletion)completionBlock{
    
    NextDaysRequestParameters *parameters = [[NextDaysRequestParameters alloc] init];
    parameters.queryParameter = cityName;
    parameters.count = 7;
    
    [RequestHelper getRequestWithUrl:@"http://api.openweathermap.org/data/2.5/forecast/daily" parameters:[parameters parametersDictionary] andCompletionBlock:^(id responseObject, NSError *error) {
        NSError *parseError = nil;
        ForecastModel *cityResponse = [MTLJSONAdapter modelOfClass:[ForecastModel class] fromJSONDictionary:responseObject error:&parseError];
        
        if (parseError || error) {
            completionBlock(nil, error);
        }else{
            completionBlock(cityResponse, nil);
        }
        
    }];
    
}

+(City *)getCityWithName:(NSString *)name isCurrentLocation:(BOOL)isCurrentLocation{
    City *city= (City *)[CoreDataHelper entityWithName:@"City" attribute:@"name" value:name];
    
    if (!city) {
        city = [City MR_createEntity];
        city.name = [FormattingHelper parsedCityWithName:name];
        city.isUserLocation = @(isCurrentLocation);
        [CoreDataHelper saveCoreDataStackWithCompletion:^(NSError *error) {
            NSLog(@"error to handle in the future %@", error);
        }];
    }
    return city;
}

+(NSArray *)measurementsListWithForecast:(ForecastModel *)forecast{
    return forecast.measureMeantsList;
}
@end
