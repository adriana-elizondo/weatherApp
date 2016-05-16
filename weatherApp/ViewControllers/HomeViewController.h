//
//  HomeViewController.h
//  weatherApp
//
//  Created by Adriana Elizondo Aguayo on 5/13/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//
#import "ForecastModel.h"
#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController
@property (nonatomic, strong) ForecastModel *forecastModel;
@end
