//
//  MeasurementModel.h
//  weatherApp
//
//  Created by Adriana Elizondo Aguayo on 5/13/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//
#import "MainDataModel.h"
#import "WeatherModel.h"
#import <Mantle/Mantle.h>
#import <UIKit/UIKit.h>

@interface MeasurementModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong) MainDataModel *mainData;
@property (nonatomic, strong) NSArray *weather;
@property (nonatomic, strong) NSString *dateUpdated;

@end
