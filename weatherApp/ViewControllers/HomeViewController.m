//
//  HomeViewController.m
//  weatherApp
//
//  Created by Adriana Elizondo Aguayo on 5/13/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//
#import "CityHelper.h"
#import "ConditionStatus.h"
#import "CoreDataHelper.h"
#import "ForecastTableViewCell.h"
#import "FormattingHelper.h"
#import "HomeViewController.h"
#import "LocationHelper.h"
#import "SearchHelper.h"
#import "WeatherCollectionViewCell.h"
#import "WeatherDetailHelper.h"
#import <UIImageView-PlayGIF/UIImageView+PlayGIF.h>

@interface HomeViewController ()<UISearchBarDelegate, UISearchDisplayDelegate,UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, LocationHelperDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currentTemperature;
@property (weak, nonatomic) IBOutlet UIImageView *conditionImage;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxMinTemperature;
@property (weak, nonatomic) IBOutlet UICollectionView *forecastCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *foreCastTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forecastTableViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *weatherDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *humidityImage;
@property (weak, nonatomic) IBOutlet UIButton *showHideButton;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeUnitButton;
@property (weak, nonatomic) IBOutlet UILabel *currentUnitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *loadingGif;

@property (nonatomic, strong) NSArray *laterTodayForecast;
@property (nonatomic, strong) NSArray *nextDaysForecast;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) ForecastModel *currentForecast;

@property BOOL isForecastShown;
@property BOOL isCelsius;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUi];
    self.isCelsius = YES;
    self.laterTodayForecast = [NSArray new];
    self.nextDaysForecast = [NSArray new];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateViewWithCity:) name:@"updatedCity" object:nil];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    if (!self.cityName) {
        [LocationHelper sharedInstance].delegate = self;
        [[LocationHelper sharedInstance] startUpdatingLocation];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setUpUi{
    self.searchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc] init];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.loadingGif.gifPath = [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"];
    [self.loadingGif startGIF];
}

-(void)updateViewWithCity:(NSNotification *)notification{
    NSString *cityName = notification.object;
    self.cityNameLabel.text = cityName;
    [self getCityWithName:cityName];
}

-(void)updateUiWithForecast:(ForecastModel *)forecast{
    self.messageLabel.hidden = YES;
    [self.loadingGif stopGIF];
    self.loadingGif.hidden = YES;
    
    self.weatherDescriptionLabel.text = [WeatherDetailHelper weatherDescriptionWithForecastModel:forecast];
    [self.view setBackgroundColor:[FormattingHelper conditionStatusWithWeather:[WeatherDetailHelper weatherWithForecastModel:forecast]].conditionColor];
    self.foreCastTableView.backgroundColor = self.view.backgroundColor;
    [self.conditionImage setImage:[FormattingHelper conditionStatusWithWeather:[WeatherDetailHelper weatherWithForecastModel:forecast]].contidionImage];
    
    self.currentTemperature.text = [NSString stringWithFormat:@"%lu °", (long)[WeatherDetailHelper weatherTemperatureWithForecastModel:forecast andUnit:self.isCelsius]];
    self.currentUnitLabel.text = self.isCelsius ? @"C" : @"F";
    [self.changeUnitButton setTitle: self.isCelsius ? @"F" : @"C" forState:UIControlStateNormal];
    self.maxMinTemperature.text = [FormattingHelper maxMinTemperatureWithMax:[WeatherDetailHelper weatherMaximumTemperatureWithForecastModel:forecast andUnit:self.isCelsius] andMin:[WeatherDetailHelper weatherMinimumTemperatureWithForecastModel:forecast andUnit:self.isCelsius]];
    
    self.humidityLabel.text = [NSString stringWithFormat:@"%lu %%",(long)[WeatherDetailHelper weatherHumidityWithForecastModel:forecast]];
    
    [self.humidityImage setImage:[UIImage imageNamed:@"water"]];
    [self.showHideButton setTitle:@"Forecast!" forState:UIControlStateNormal];
    [self.forecastCollectionView reloadData];
}

#pragma mark - Location helper delegate
-(void)updatedLocationWithCity:(NSString *)city{
    [self getCityWithName:city];
    self.cityName = [CityHelper getCityWithName:city isCurrentLocation:YES].name;
    self.cityNameLabel.text = self.cityName;
    [[LocationHelper sharedInstance] stopUpdatingLocation];
}

#pragma mark - Get city from server

-(void)getCityWithName:(NSString *)name{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [CityHelper forecastForcityWithName:name WithCompletion:^(id response, NSError *error) {
        self.laterTodayForecast = [FormattingHelper filterResultsForToday:[CityHelper measurementsListWithForecast:response]];
        [self updateUiWithForecast:response];
        self.currentForecast = response;
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
    cell.maxMinTemperatureLabel.text = [FormattingHelper maxMinTemperatureWithMax:[WeatherDetailHelper weatherMaximumTemperatureWithMeasurementModel:current andUnit:self.isCelsius] andMin:[WeatherDetailHelper weatherMinimumTemperatureWithMeasurementModel:current andUnit:self.isCelsius]];
    cell.timeLabel.text = [FormattingHelper formatedTimeWithDate:current.dateUpdated];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = (self.view.bounds.size.width / 3) + 10;
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
    return self.nextDaysForecast.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ForecastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"forecastCell"];
    cell.backgroundColor = indexPath.row %2 == 0 ? [UIColor clearColor] : [UIColor colorWithWhite:5.0 alpha:.5];
    MeasurementModel *current = [self.nextDaysForecast objectAtIndex:indexPath.row];
    cell.showHideButton.hidden = YES;
    cell.forecastImage.image = [FormattingHelper conditionStatusWithWeather:current.weather[0]].contidionImage;
    cell.dateLabel.text = [FormattingHelper datePlusDays:indexPath.row];
    return cell;
}
- (IBAction)toggleTemperature:(id)sender {
    self.isCelsius = !self.isCelsius;
    [self updateUiWithForecast:self.currentForecast];
    [self.forecastCollectionView reloadData];
}


- (IBAction)showHideForecast:(id)sender {
    [self.showHideButton setTitle:@"Loading..." forState:UIControlStateNormal];
    [self.showHideButton setEnabled:NO];
    
    if (self.nextDaysForecast.count > 0) {
        [self animateTableView];
    }else{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
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
    [self.view bringSubviewToFront:self.foreCastTableView];
    self.forecastTableViewHeight.constant = !self.isForecastShown ? self.view.frame.size.height - 125 : 0;
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationOptionTransitionCurlUp animations:^{
        [self.view layoutIfNeeded];
    }completion:^(BOOL finished) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        self.isForecastShown = !self.isForecastShown;
        
        NSString *buttonTitle = self.isForecastShown ? @"Hide me!" : @"Forecast!";
        [self.showHideButton setTitle:buttonTitle forState:UIControlStateNormal];
        self.showHideButton.enabled = YES;
        
    }];
    
}
@end
