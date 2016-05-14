//
//  FormattingHelper.h
//  weatherApp
//
//  Created by Adriana Elizondo Aguayo on 5/13/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//
#import "ConditionStatus.h"
#import "MeasurementModel.h"
#import "WeatherModel.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FormattingHelper : NSObject

+(NSString *)currentTime;
+(NSString *)currentDate;
+(NSString*)maxMinTemperatureWithMeasurement:(MeasurementModel *)measurement andUnit:(NSString *)unit;
+(NSArray *)filterResultsForToday:(NSArray *)arrayToFilter;
+(NSString*)formatedTimeWithDate:(NSString *)date;
+(ConditionStatus *)conditionStatusWithWeather:(WeatherModel *)weather;

@end
