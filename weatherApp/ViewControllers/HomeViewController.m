//
//  HomeViewController.m
//  weatherApp
//
//  Created by Adriana Elizondo Aguayo on 5/13/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//
#import "CityHelper.h"
#import "CityModel.h"
#import "ForecastModel.h"
#import "FormattingHelper.h"
#import "HomeViewController.h"
#import "LocationHelper.h"
#import "MainDataModel.h"
#import "MeasurementModel.h"

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
@property (weak, nonatomic) IBOutlet UILabel *currentDate;
@property (weak, nonatomic) IBOutlet UILabel *currentTemperature;
@property (weak, nonatomic) IBOutlet UIButton *celsiusButton;
@property (weak, nonatomic) IBOutlet UIButton *farenheitButton;
@property (weak, nonatomic) IBOutlet UIImageView *conditionImage;
@property (weak, nonatomic) IBOutlet UILabel *personalizedMessage;
@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UILabel *maxMinTemperature;
@property NSString *currentUnit;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.currentUnit = @"°C";
    [CityHelper forecastForcityWithName:@"Shanghai" WithCompletion:^(ForecastModel *response, NSError *error) {
        [self updateUiWithForecast:response];
    }];
    
}

-(void)updateUiWithForecast:(ForecastModel *)forecast{
    self.currentTime.text = [FormattingHelper currentTime];
    self.currentDate.text = [FormattingHelper currentDate];
    
    self.cityName.text = forecast.city.name;
    MeasurementModel *latestMeasurement = [forecast.measureMeantsList objectAtIndex:0];
    self.currentTemperature.text = [NSString stringWithFormat:@"%i °", (int)latestMeasurement.mainData.temperature];
    self.maxMinTemperature.text = [NSString stringWithFormat:@"%i%@ ↑ / %i%@ ↓", (int)latestMeasurement.mainData.temperatureMax,self.currentUnit, (int)latestMeasurement.mainData.temperatureMin, self.currentUnit];
}

@end
