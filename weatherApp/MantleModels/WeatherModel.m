//
//  Weather.m
//  weatherApp
//
//  Created by Adriana Elizondo Aguayo on 5/13/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//

#import "WeatherModel.h"

@implementation WeatherModel
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"temperature": @"temp",
             @"temperatureMin": @"temp_min",
             @"temperatureMax": @"temp_max",
             @"humidity": @"humidity"
             };
}
@end
