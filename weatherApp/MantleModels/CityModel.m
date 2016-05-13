//
//  CityModel.m
//  weatherApp
//
//  Created by Adriana Elizondo Aguayo on 5/13/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"cityId": @"id",
             @"name": @"name",
             @"country": @"country",
             @"longitude": @"coord.lon",
             @"latitude": @"coord.lat"
             };
}

-(void)setNilValueForKey:(NSString *)key
{
    [self setValue:@0 forKey:key];
}
@end
