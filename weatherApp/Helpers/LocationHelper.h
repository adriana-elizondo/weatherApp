//
//  LocationHelper.h
//  weatherApp
//
//  Created by Adriana Elizondo Aguayo on 5/13/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@interface LocationHelper : NSObject<CLLocationManagerDelegate>

+ (instancetype)sharedInstance;
-(void)getCurrentLocation;

@end
