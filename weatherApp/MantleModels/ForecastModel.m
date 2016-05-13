//
//  CityModel.m
//  weatherApp
//
//  Created by Adriana Elizondo Aguayo on 5/13/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//
#import "ForecastModel.h"
#import "CityModel.h"
#import "MeasurementModel.h"

@implementation ForecastModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"city": @"city",
             @"measureMeantsList": @"list"
             };
}

+(NSValueTransformer *)measureMeantsListJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[MeasurementModel class]];
}

+(NSValueTransformer *)cityJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[CityModel class]];
}

-(void)setNilValueForKey:(NSString *)key
{
    [self setValue:@0 forKey:key];
}
@end
