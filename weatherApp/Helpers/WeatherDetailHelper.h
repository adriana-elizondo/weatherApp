//
//  WeatherDetailHelper.h
//  weatherApp
//
//  Created by Adriana Elizondo Aguayo on 5/17/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//
#import "ForecastModel.h"
#import <Foundation/Foundation.h>

@interface WeatherDetailHelper : NSObject
+(NSString *)weatherDescriptionWithForecastModel:(ForecastModel *)forecastModel;
@end
