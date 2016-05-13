//
//  CityModel.h
//  weatherApp
//
//  Created by Adriana Elizondo Aguayo on 5/13/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//
#import "CoordinatesModel.h"
#import <Mantle/Mantle.h>

@interface ForecastModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *cityId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) CoordinatesModel *coordinates;
@property (nonatomic, strong) NSArray *measureMeantsList;

@end
