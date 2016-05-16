//
//  HomeViewController.m
//  weatherApp
//
//  Created by Adriana Elizondo Aguayo on 5/13/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//
#import "CityHelper.h"
#import "CityModel.h"
#import "ConditionStatus.h"
#import "ForecastModel.h"
#import "FormattingHelper.h"
#import "HomeViewController.h"
#import "LocationHelper.h"
#import "MainDataModel.h"
#import "MeasurementModel.h"
#import "SearchHelper.h"
#import "WeatherCollectionViewCell.h"

@interface HomeViewController ()<UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
@property (weak, nonatomic) IBOutlet UILabel *currentDate;
@property (weak, nonatomic) IBOutlet UILabel *currentTemperature;
@property (weak, nonatomic) IBOutlet UIButton *celsiusButton;
@property (weak, nonatomic) IBOutlet UIButton *farenheitButton;
@property (weak, nonatomic) IBOutlet UIImageView *conditionImage;
@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UILabel *maxMinTemperature;
@property (weak, nonatomic) IBOutlet UICollectionView *forecastCollectionView;

@property NSString *currentUnit;
@property NSArray *laterTodayForecast;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentUnit = @"°C";
    self.laterTodayForecast = [NSArray new];
    self.searchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateUiWithForecast:(ForecastModel *)forecast{
    self.currentTime.text = [FormattingHelper currentTime];
    self.currentDate.text = [FormattingHelper currentDate];
    self.cityName.text = forecast.city.name;
    
    MeasurementModel *latestMeasurement = [forecast.measureMeantsList objectAtIndex:0];
    [self.view setBackgroundColor:[FormattingHelper conditionStatusWithWeather:latestMeasurement.weather[0]].conditionColor];
    [self.conditionImage setImage:[FormattingHelper conditionStatusWithWeather:latestMeasurement.weather[0]].contidionImage];
    self.currentTemperature.text = [NSString stringWithFormat:@"%i °", (int)latestMeasurement.mainData.temperature];
    self.maxMinTemperature.text = [FormattingHelper maxMinTemperatureWithMeasurement:latestMeasurement andUnit:self.currentUnit];
    
    [self.forecastCollectionView reloadData];
}

#pragma mark - Get city from server
-(void)getCityWithName:(NSString *)name{
    [CityHelper forecastForcityWithName:name WithCompletion:^(ForecastModel *response, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self.searchDisplayController setActive:NO];
    }];
}


#pragma mark - CollectionViewDatasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1.0;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.laterTodayForecast.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WeatherCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"weatherCell" forIndexPath:indexPath];
    
    MeasurementModel *current = [self.laterTodayForecast objectAtIndex:indexPath.row];
    cell.weatherImage.image = [FormattingHelper conditionStatusWithWeather:current.weather[0]].contidionImage;
    cell.maxMinTemperatureLabel.text = [FormattingHelper maxMinTemperatureWithMeasurement:current andUnit:self.currentUnit];
    cell.timeLabel.text = [FormattingHelper formatedTimeWithDate:current.dateUpdated];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = (self.view.bounds.size.width / 3) - 10;
    return CGSizeMake(width, self.forecastCollectionView.frame.size.height);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
@end
