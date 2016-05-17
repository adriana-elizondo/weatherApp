//
//  CityHelper.h
//  weatherApp
//
//  Created by Adriana Elizondo Aguayo on 5/13/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//
#import "City.h"
#import "ForecastModel.h"
#import <Foundation/Foundation.h>

typedef void (^ForecastCompletion)(ForecastModel *response, NSError *error);

@interface CityHelper : NSObject

+(void)forecastForcityWithName:(NSString *)cityName WithCompletion:(ForecastCompletion)completionBlock;
+(void)forecastForNextDaysForCity:(NSString *)cityName WithCompletion:(ForecastCompletion)completionBlock;
+(City *)getCityWithName:(NSString *)name isCurrentLocation:(BOOL)isCurrentLocation;

@end
