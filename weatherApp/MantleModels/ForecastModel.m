//
//  CityModel.m
//  weatherApp
//
//  Created by Adriana Elizondo Aguayo on 5/13/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//
#import "ForecastModel.h"
#import "CoordinatesModel.h"
#import "MeasurementModel.h"

@implementation ForecastModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"cityId": @"id",
             @"name": @"name",
             @"country": @"country",
             @"coordinates": @"coord",
             @"measureMeantsList": @"list"
             };
}

+(NSValueTransformer *)coordinatesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[CoordinatesModel class]];
}

+(NSValueTransformer *)measureMeantsListJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[MeasurementModel class]];
}
@end
