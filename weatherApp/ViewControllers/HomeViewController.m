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
#import "ForecastTableViewCell.h"
#import "FormattingHelper.h"
#import "HomeViewController.h"
#import "LocationHelper.h"
#import "MainDataModel.h"
#import "MeasurementModel.h"
#import "SearchHelper.h"
#import "WeatherModel.h"
#import "WeatherCollectionViewCell.h"

@interface HomeViewController ()<UISearchBarDelegate, UISearchDisplayDelegate,UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *currentDate;
@property (weak, nonatomic) IBOutlet UILabel *currentTemperature;
@property (weak, nonatomic) IBOutlet UIImageView *conditionImage;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxMinTemperature;
@property (weak, nonatomic) IBOutlet UICollectionView *forecastCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *foreCastTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forecastTableViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *weatherDescriptionLabel;

@property (nonatomic, strong) NSString *currentUnit;
@property (nonatomic, strong) NSArray *laterTodayForecast;
@property (nonatomic, strong) NSArray *nextDaysForecast;
@property BOOL isForecastShown;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentUnit = @"°C";
    self.laterTodayForecast = [NSArray new];
    self.nextDaysForecast = [NSArray new];
    self.searchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    [self getCityWithName:self.cityName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateUiWithForecast:(ForecastModel *)forecast{
    self.currentDate.text = [FormattingHelper currentDate];
    self.cityNameLabel.text = forecast.city.name;
    
    MeasurementModel *latestMeasurement = (MeasurementModel *)[forecast.measureMeantsList objectAtIndex:0];
    WeatherModel *weather = latestMeasurement.weather[0];
    self.weatherDescriptionLabel.text = weather.weatherDescription;
    
    [self.view setBackgroundColor:[FormattingHelper conditionStatusWithWeather:latestMeasurement.weather[0]].conditionColor];
    [self.foreCastTableView setBackgroundColor:[FormattingHelper conditionStatusWithWeather:latestMeasurement.weather[0]].conditionColor];
    [self.conditionImage setImage:[FormattingHelper conditionStatusWithWeather:latestMeasurement.weather[0]].contidionImage];
    self.currentTemperature.text = [NSString stringWithFormat:@"%i °C", (int)latestMeasurement.mainData.temperature];
    self.maxMinTemperature.text = [FormattingHelper maxMinTemperatureWithMeasurement:latestMeasurement andUnit:self.currentUnit];
    [self.forecastCollectionView reloadData];
}

#pragma mark - Get city from server

-(void)getCityWithName:(NSString *)name{
    [CityHelper forecastForcityWithName:name WithCompletion:^(ForecastModel *response, NSError *error) {
        self.laterTodayForecast = [FormattingHelper filterResultsForToday:response.measureMeantsList];
        [self updateUiWithForecast:response];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
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

#pragma mark - Tableview datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.nextDaysForecast.count > 0 ? self.nextDaysForecast.count : 1.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ForecastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"forecastCell"];
    cell.backgroundColor = indexPath.row %2 == 0 ? [UIColor clearColor] : [UIColor colorWithWhite:5.0 alpha:.5];
    if (indexPath.row == 0) {
        cell.showHideButton.hidden = NO;
        cell.dateLabel.hidden = YES;
        cell.forecastImage.hidden = YES;
        [cell.showHideButton addTarget:self action:@selector(showForecast) forControlEvents:UIControlEventTouchUpInside];
    }else{
        MeasurementModel *current = [self.nextDaysForecast objectAtIndex:indexPath.row];
        cell.showHideButton.hidden = YES;
        cell.forecastImage.image = [FormattingHelper conditionStatusWithWeather:current.weather[0]].contidionImage;
        cell.dateLabel.text = [FormattingHelper datePlusDays:indexPath.row];
    }
    return cell;
}

- (void)showForecast{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if (self.nextDaysForecast.count > 0) {
        [self animateTableView];
    }else{
        [CityHelper forecastForNextDaysForCity:self.cityName WithCompletion:^(ForecastModel *response, NSError *error) {
            if (!error) {
                self.nextDaysForecast = response.measureMeantsList;
                [self.foreCastTableView reloadData];
                [self animateTableView];
            }
        }];
    }
    
    }

-(void)animateTableView{
    self.forecastTableViewHeight.constant = !self.isForecastShown ? self.view.frame.size.height - 125 : 80;
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationOptionTransitionCurlUp animations:^{
        [self.view layoutIfNeeded];
    }completion:^(BOOL finished) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        self.isForecastShown = !self.isForecastShown;

    }];

}

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
