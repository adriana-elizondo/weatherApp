//
//  WeatherDetailHelper.m
//  weatherApp
//
//  Created by Adriana Elizondo Aguayo on 5/17/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//
#import "FormattingHelper.h"
#import "MeasurementModel.h"
#import "WeatherDetailHelper.h"
#import "WeatherModel.h"

@implementation WeatherDetailHelper

+(NSString *)weatherDescriptionWithForecastModel:(ForecastModel *)forecastModel{
    MeasurementModel *latestMeasurement = (MeasurementModel *)[forecastModel.measureMeantsList objectAtIndex:0];
    WeatherModel *weather = latestMeasurement.weather[0];
    return weather.weatherDescription;
}

+(WeatherModel *)weatherWithForecastModel:(ForecastModel *)forecastModel{
    MeasurementModel *latestMeasurement = (MeasurementModel *)[forecastModel.measureMeantsList objectAtIndex:0];
    WeatherModel *weather = latestMeasurement.weather[0];
    return weather;
}

+(NSInteger)weatherTemperatureWithForecastModel:(ForecastModel *)forecastModel andUnit:(BOOL)isCelsius{
    MeasurementModel *latestMeasurement = (MeasurementModel *)[forecastModel.measureMeantsList objectAtIndex:0];
    
    return isCelsius ? latestMeasurement.mainData.temperature : [FormattingHelper celsiusToFarenheit:latestMeasurement.mainData.temperature];
}

+(NSInteger)weatherMaximumTemperatureWithForecastModel:(ForecastModel *)forecastModel andUnit:(BOOL)isCelsius{
    MeasurementModel *latestMeasurement = (MeasurementModel *)[forecastModel.measureMeantsList objectAtIndex:0];
    return [self weatherMaximumTemperatureWithMeasurementModel:latestMeasurement andUnit:isCelsius];
}

+(NSInteger)weatherMinimumTemperatureWithForecastModel:(ForecastModel *)forecastModel andUnit:(BOOL)isCelsius{
    MeasurementModel *latestMeasurement = (MeasurementModel *)[forecastModel.measureMeantsList objectAtIndex:0];
    return [self weatherMinimumTemperatureWithMeasurementModel:latestMeasurement andUnit:isCelsius];
}

+(NSInteger)weatherMaximumTemperatureWithMeasurementModel:(MeasurementModel *)measurementModel andUnit:(BOOL)isCelsius{
    return isCelsius ? measurementModel.mainData.temperatureMax : [FormattingHelper celsiusToFarenheit:measurementModel.mainData.temperatureMax];
}

+(NSInteger)weatherMinimumTemperatureWithMeasurementModel:(MeasurementModel *)measurementModel andUnit:(BOOL)isCelsius{
    return isCelsius ? measurementModel.mainData.temperatureMax : [FormattingHelper celsiusToFarenheit:measurementModel.mainData.temperatureMin];
}

+(NSInteger)weatherHumidityWithForecastModel:(ForecastModel *)forecastModel{
    MeasurementModel *latestMeasurement = (MeasurementModel *)[forecastModel.measureMeantsList objectAtIndex:0];
    return latestMeasurement.mainData.humidity;
}
@end
