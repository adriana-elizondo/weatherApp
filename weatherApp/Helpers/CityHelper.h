//
//  CityHelper.h
//  weatherApp
//
//  Created by Adriana Elizondo Aguayo on 5/13/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//
#import "ForecastModel.h"
#import <Foundation/Foundation.h>

typedef void (^ForecastCompletion)(ForecastModel *response, NSError *error);

@interface CityHelper : NSObject

+(void)forecastForcityWithName:(NSString *)cityName WithCompletion:(ForecastCompletion)completionBlock;

@end
