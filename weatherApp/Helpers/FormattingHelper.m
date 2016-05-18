//
//  FormattingHelper.m
//  weatherApp
//
//  Created by Adriana Elizondo Aguayo on 5/13/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//
#import "FormattingHelper.h"

@implementation FormattingHelper

+(NSString *)currentTime{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

+(NSString *)currentDate{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

+(NSString *)datePlusDays:(NSInteger)days{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd"];
    NSDate *dateDaysAgo = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay
                                                                    value:days
                                                                   toDate:[NSDate date]
                                                                  options:0];
    return [dateFormatter stringFromDate:dateDaysAgo];
}

+(NSString *)parsedCityWithName:(NSString *)cityName{
    if ([cityName containsString:@","]) {
        return [cityName substringToIndex:[cityName rangeOfString:@","].location];
    }
    return cityName;
}

+(NSString*)maxMinTemperatureWithMax:(NSInteger)max andMin:(NSInteger)min{
    return [NSString stringWithFormat:@"%li° MAX / %li° MIN", (long)max, min];
}

+(NSString*)formatedTimeWithDate:(NSString *)date{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFromString = [dateFormatter dateFromString:date];
    [dateFormatter setDateFormat:@"HH:mm"];
    return [dateFormatter stringFromDate:dateFromString];
}

+(NSArray *)filterResultsForToday:(NSArray *)arrayToFilter{
    NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *todaysDate = [dateFormatter stringFromDate:[NSDate date]];
    return [[arrayToFilter filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"self.dateUpdated CONTAINS '%@'", todaysDate]]] copy];
}

+(ConditionStatus *)conditionStatusWithWeather:(WeatherModel *)weather{
    ConditionStatus *status = [[ConditionStatus alloc] init];
    if ([weather.weather isEqualToString:@"Clear"]) {
        status.contidionImage = [UIImage imageNamed:@"clear"];
        status.conditionMessage = [NSString stringWithFormat:@"%@! Go out and enjoy the nice day!!", weather.weatherDescription];
        status.conditionColor = [UIColor colorWithRed:229/255.0f green:200/255.0f blue:81/255.0f alpha:1.0];
        return status;
    }
    
    if ([weather.weather isEqualToString:@"Rain"]) {
        if ([weather.description containsString:@"heavy"]) {
            status.contidionImage = [UIImage imageNamed:@"heavy_rain"];
            status.conditionMessage = @"";
            
        }else if ([weather.description containsString:@"very heavy"]){
            status.contidionImage = [UIImage imageNamed:@"storm"];
            status.conditionMessage = @"RUUUUN FOR YOOOOUR LIIIIFEEEE";
            
        }else if ([weather.description containsString:@"light"]){
            status.contidionImage = [UIImage imageNamed:@"light_rain"];
            status.conditionMessage = @"It's only light rain don't be a baby and go outside!";
            
        }else if ([weather.description containsString:@"moderate"]){
            status.contidionImage = [UIImage imageNamed:@"moderate_rain"];
            status.conditionMessage = [NSString stringWithFormat:@"%@! Don't worry you can still survive", weather.weatherDescription];;
        }else{
            status.contidionImage = [UIImage imageNamed:@"moderate_rain"];
            status.conditionMessage = weather.description;
        }
        
        status.conditionColor = [UIColor colorWithRed:25/255.0f green:95/255.0f blue:165/255.0f alpha:1.0];
        return status;

    }
    
    if ([weather.weather isEqualToString:@"Clouds"]) {
        if ([weather.description containsString:@"broken"]) {
            status.contidionImage = [UIImage imageNamed:@"overcast_clouds"];
            status.conditionMessage = @"";
            
        }else if ([weather.description containsString:@"scattered"]){
            status.contidionImage = [UIImage imageNamed:@"scattered_clouds"];
            status.conditionMessage = @"RUUUUN FOR YOOOOUR LIIIIFEEEE";
            
        }else if ([weather.description containsString:@"few"]){
            status.contidionImage = [UIImage imageNamed:@"few_clouds"];
            status.conditionMessage = @"It's only light rain don't be a baby and go outside!";
            
        }else if ([weather.description containsString:@"overcast"]){
            status.contidionImage = [UIImage imageNamed:@"overcast_clouds"];
            status.conditionMessage = @"";
        }else{
            status.contidionImage = [UIImage imageNamed:@"cloud"];
            status.conditionMessage = @"";
        }
        
        if ([weather.weather isEqualToString:@"Snow"]) {
            status.contidionImage = [UIImage imageNamed:@"snow"];
            status.conditionColor = [UIColor colorWithRed:50/255.0f green:190/255.0f blue:188/255.0f alpha:1.0];
            return status;
        }
        
        status.conditionColor = [UIColor colorWithRed:83/255.0f green:92/255.0f blue:104/255.0f alpha:1.0];
        return status;

    }
    
    
    return status;
}

+(NSInteger)celsiusToFarenheit:(CGFloat)celsius{
    return (int)((celsius * 9.0f) / 5.0f) + 32.0f;
}
@end
