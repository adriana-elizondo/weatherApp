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
             @"weather": @"main",
             @"weatherDescription": @"description"
             };
}

-(void)setNilValueForKey:(NSString *)key
{
    [self setValue:@0 forKey:key];
}
@end
