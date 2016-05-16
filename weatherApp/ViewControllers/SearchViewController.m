//
//  SearchViewController.m
//  weatherApp
//
//  Created by Adriana Elizondo on 5/14/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//
#import "City.h"
#import "CityHelper.h"
#import "CoreDataHelper.h"
#import "FormattingHelper.h"
#import "HomeViewController.h"
#import "LocationHelper.h"
#import "SearchHelper.h"
#import "SearchViewController.h"

@interface SearchViewController ()<UITableViewDataSource, UITableViewDelegate, LocationHelperDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITableView *citiesAddedTableView;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;

@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) NSMutableArray *citiesAdded;
@property (nonatomic, strong) City *currentCity;
@property BOOL didUpdateLocation;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUp{
    self.searchResults = [NSMutableArray new];
    self.citiesAddedTableView.tableFooterView = [[UIView alloc] init];
    self.citiesAdded = [[NSMutableArray alloc] initWithArray:[CoreDataHelper allFromEntityWithName:@"City"]];
    [self.citiesAddedTableView reloadData];
}

- (IBAction)searchButtonClicked:(id)sender {
    self.searchBar.hidden = NO;
    self.searchButton.hidden = YES;
    self.locationButton.hidden = YES;
    [self.searchBar becomeFirstResponder];
}

- (IBAction)locationClicked:(id)sender {
    self.didUpdateLocation = NO;
    [LocationHelper sharedInstance].delegate = self;
}

#pragma mark - Searchbar tableview delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.searchResults.count;
    }else{
        return self.citiesAdded.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        cell.textLabel.text = self.searchResults[indexPath.row];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell"];
        City *city = self.citiesAdded[indexPath.row];
        cell.textLabel.text = city.name;
    }
    
    return cell;
}

#pragma mark - Searchbar tableview delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        City *city =[CityHelper getCityWithName:self.searchResults[indexPath.row]];
        if (![self.citiesAdded containsObject:city]) {
            [self.citiesAdded addObject:city];
        }
        [self.searchDisplayController setActive:NO];
        [self.citiesAddedTableView reloadData];
    }else{
        self.currentCity = self.citiesAdded[indexPath.row];
        [self performSegueWithIdentifier:@"cityDetails" sender:self];
    }
}

#pragma mark - UISearchcontroller delegate

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
    [UIView animateWithDuration:.7 animations:^{
        self.searchBar.hidden = YES;
        self.searchButton.hidden = NO;
        self.locationButton.hidden = NO;
    }];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if ([searchString isEqualToString:@""]) {
        return NO;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [SearchHelper getListOfCitiesWithString:searchString withCompletion:^(NSArray *results, NSError *error) {
        [self.searchResults removeAllObjects];
        if (![results[0] isEqualToString:@""]) {
            [self.searchResults addObjectsFromArray:results];
        }else{
            [self.searchResults addObject:self.searchBar.text];
        }
        [self.searchDisplayController.searchResultsTableView reloadData];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    return NO;
}

#pragma mark - Location delegate
-(void)updatedLocationWithCity:(NSString *)city{
    if (self.didUpdateLocation) {
        return;
    }
    self.didUpdateLocation = YES;
    self.currentCity = [CityHelper getCityWithName:city];
    if (![self.citiesAdded containsObject:self.currentCity]) {
        [self.citiesAdded addObject:self.currentCity];
        [self.citiesAddedTableView reloadData];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@ is already in your list! Click on it for more details (:",city] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    [[LocationHelper sharedInstance] stopUpdatingLocation];
}

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"cityDetails"]) {
        HomeViewController *homeViewController = (HomeViewController *)[segue destinationViewController];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        homeViewController.cityName = [FormattingHelper parsedCityWithName:self.currentCity.name];
    }
}

@end
