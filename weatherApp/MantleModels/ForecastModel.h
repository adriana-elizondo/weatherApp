//
//  CityModel.h
//  weatherApp
//
//  Created by Adriana Elizondo Aguayo on 5/13/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//
#import "CityModel.h"
#import <Mantle/Mantle.h>

@interface ForecastModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) CityModel *city;
@property (nonatomic, strong) NSArray *measureMeantsList;

@end
