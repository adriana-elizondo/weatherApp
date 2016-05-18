//
//  WeatherDetailHelper.h
//  weatherApp
//
//  Created by Adriana Elizondo Aguayo on 5/17/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//
#import "ForecastModel.h"
#import "WeatherModel.h"
#import <Foundation/Foundation.h>

@interface WeatherDetailHelper : NSObject
+(NSString *)weatherDescriptionWithForecastModel:(ForecastModel *)forecastModel;
+(WeatherModel *)weatherWithForecastModel:(ForecastModel *)forecastModel;
+(NSInteger)weatherTemperatureWithForecastModel:(ForecastModel *)forecastModel andUnit:(BOOL)isCelsius;
+(NSInteger)weatherHumidityWithForecastModel:(ForecastModel *)forecastModel;
+(NSInteger)weatherMaximumTemperatureWithForecastModel:(ForecastModel *)forecastModel andUnit:(BOOL)isCelsius;
+(NSInteger)weatherMinimumTemperatureWithForecastModel:(ForecastModel *)forecastModel andUnit:(BOOL)isCelsius;
+(NSInteger)weatherMaximumTemperatureWithMeasurementModel:(MeasurementModel *)measurementModel andUnit:(BOOL)isCelsius;
+(NSInteger)weatherMinimumTemperatureWithMeasurementModel:(MeasurementModel *)measurementModel andUnit:(BOOL)isCelsius;
@end
