//
//  LocationHelper.m
//  weatherApp
//
//  Created by Adriana Elizondo Aguayo on 5/13/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//

#import "LocationHelper.h"
#import <UIKit/UIKit.h>

@interface LocationHelper()

@property CLLocationManager *locationManager;

@end

@implementation LocationHelper

static id sharedInstance;
static dispatch_once_t onceToken;

+ (instancetype)sharedInstance
{
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(instancetype)init{
    if (self = [super init]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.delegate = self;
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
    }
    return self;
}

#pragma mark - Location manager delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error){
             NSLog(@"Geocode failed with error: %@", error);
             return;
         }
         
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
        [self.delegate updatedLocationWithCity:placemark.locality];
     }];
}

-(void)stopUpdatingLocation{
    [self.locationManager stopUpdatingLocation];
}
@end
