//
//  MeasurementModel.m
//  weatherApp
//
//  Created by Adriana Elizondo Aguayo on 5/13/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//
#import "MainDataModel.h"
#import "MeasurementModel.h"
#import "WeatherModel.h"

@implementation MeasurementModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"mainData": @"main",
             @"weather": @"weather",
             @"dateUpdated": @"dt_txt"
             };
}

+(NSValueTransformer *)mainDataJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[MainDataModel class]];
}

+(NSValueTransformer *)weatherJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WeatherModel class]];
}

-(void)setNilValueForKey:(NSString *)key
{
    [self setValue:@0 forKey:key];
}

@end
