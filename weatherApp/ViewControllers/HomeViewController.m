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
@property (weak, nonatomic) IBOutlet UILabel *personalizedMessage;
@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UILabel *maxMinTemperature;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *forecastCollectionView;

@property UIActivityIndicatorView *activityIndicator;

@property NSString *currentUnit;
@property NSMutableArray *searchResults;
@property NSArray *laterTodayForecast;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentUnit = @"°C";
    self.searchResults = [NSMutableArray new];
    self.laterTodayForecast = [NSArray new];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.hidden = YES;
    self.activityIndicator.center = self.searchBar.center;
    self.activityIndicator.hidesWhenStopped = YES;
    [self.searchBar addSubview:self.activityIndicator];
    self.searchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Get city from server

-(void)getCityWithName:(NSString *)name{
    [CityHelper forecastForcityWithName:name WithCompletion:^(ForecastModel *response, NSError *error) {
        self.laterTodayForecast = [FormattingHelper filterResultsForToday:response.measureMeantsList];
        [self updateUiWithForecast:response];
        [self.activityIndicator stopAnimating];
        [self.searchDisplayController setActive:NO];
    }];
}

-(void)updateUiWithForecast:(ForecastModel *)forecast{
    self.currentTime.text = [FormattingHelper currentTime];
    self.currentDate.text = [FormattingHelper currentDate];
    self.cityName.text = forecast.city.name;
    
    MeasurementModel *latestMeasurement = [forecast.measureMeantsList objectAtIndex:0];
    [self.view setBackgroundColor:[FormattingHelper conditionStatusWithWeather:latestMeasurement.weather[0]].conditionColor];
    self.personalizedMessage.text = [FormattingHelper conditionStatusWithWeather:latestMeasurement.weather[0]].conditionMessage;
    [self.conditionImage setImage:[FormattingHelper conditionStatusWithWeather:latestMeasurement.weather[0]].contidionImage];
    self.currentTemperature.text = [NSString stringWithFormat:@"%i °", (int)latestMeasurement.mainData.temperature];
    self.maxMinTemperature.text = [FormattingHelper maxMinTemperatureWithMeasurement:latestMeasurement andUnit:self.currentUnit];
    
    [self.forecastCollectionView reloadData];
}

- (IBAction)searchButtonClicked:(id)sender {
    self.searchBar.hidden = NO;
    [self.searchBar becomeFirstResponder];
}

#pragma mark - Searchbar tableview delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchResults.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = self.searchResults[indexPath.row];
    return cell;
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.activityIndicator startAnimating];
    [self getCityWithName:self.searchBar.text];
}

#pragma mark - UISearchcontroller delegate

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
    [UIView animateWithDuration:.7 animations:^{
        self.searchBar.hidden = YES;
    }];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if ([searchString isEqualToString:@""]) {
        return NO;
    }
    
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    [SearchHelper getListOfCitiesWithString:searchString withCompletion:^(NSArray *results, NSError *error) {
        [self.searchResults removeAllObjects];
        if (![results[0] isEqualToString:@""]) {
            [self.searchResults addObjectsFromArray:results];
        }else{
             [self.searchResults addObject:self.searchBar.text];
        }
        [self.searchDisplayController.searchResultsTableView reloadData];
        [self.activityIndicator stopAnimating];
    }];
    return NO;
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
