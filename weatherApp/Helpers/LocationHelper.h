//
//  LocationHelper.h
//  weatherApp
//
//  Created by Adriana Elizondo Aguayo on 5/13/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol LocationHelperDelegate<NSObject>

-(void)updatedLocationWithCity:(NSString *)city;

@end

@interface LocationHelper : NSObject<CLLocationManagerDelegate>

+ (instancetype)sharedInstance;

@property (nonatomic, weak) id <LocationHelperDelegate> delegate;

-(void)startUpdating;
-(void)stopUpdatingLocation;

@end
