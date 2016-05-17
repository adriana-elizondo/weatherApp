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
#import "SearchHelper.h"
#import "SearchViewController.h"

@interface SearchViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *citiesAddedTableView;

@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) NSMutableArray *citiesAdded;
@property (nonatomic, strong) City *currentCity;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self setUp];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updatedCity" object:self.currentCity.name];
}

-(void)setUp{
    [self.navigationItem setHidesBackButton:YES];
    self.searchResults = [NSMutableArray new];
    self.citiesAddedTableView.tableFooterView = [[UIView alloc] init];
    self.citiesAdded = [[NSMutableArray alloc] initWithArray:[CoreDataHelper allFromEntityWithName:@"City"]];
    [self.citiesAddedTableView reloadData];
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
        
        if (self.searchResults.count > 0) {
            cell.textLabel.text = self.searchResults[indexPath.row];
        }
        
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell"];
        City *city = self.citiesAdded[indexPath.row];
        cell.textLabel.text = city.name;
        cell.textLabel.textColor = [UIColor whiteColor];
        
        UIImageView *imageView = [cell viewWithTag:3];
        if ([city.isUserLocation boolValue]) {
            [imageView setImage:[UIImage imageNamed:@"location"]];
        }else{
            imageView.hidden = YES;
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        City *city = self.citiesAdded[indexPath.row];
        [CoreDataHelper removeEntity:city];
        [self.citiesAdded removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }
}

#pragma mark - tableview delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        City *city =[CityHelper getCityWithName:self.searchResults[indexPath.row] isCurrentLocation:NO];
        if (![self.citiesAdded containsObject:city]) {
            [self.citiesAdded addObject:city];
        }
        [self.searchDisplayController setActive:NO];
        [self.citiesAddedTableView reloadData];
    }else{
        self.currentCity = self.citiesAdded[indexPath.row];
        [self goToCityDetails];
    }
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

#pragma mark - Go to city details
-(void)goToCityDetails{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
