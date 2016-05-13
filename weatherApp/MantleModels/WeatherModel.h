//
//  Weather.h
//  weatherApp
//
//  Created by Adriana Elizondo Aguayo on 5/13/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface WeatherModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong) NSString *weather;
@property (nonatomic, strong) NSString *weatherDescription;
@end
