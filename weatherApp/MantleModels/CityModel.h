//
//  CityModel.h
//  weatherApp
//
//  Created by Adriana Elizondo Aguayo on 5/13/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//
#import <Mantle/Mantle.h>
#import <UIKit/UIKit.h>

@interface CityModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *cityId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat latitude;

@end
