//
//  SearchViewController.m
//  weatherApp
//
//  Created by Adriana Elizondo on 5/14/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//
#import "CityHelper.h"
#import "CoreDataHelper.h"
#import "SearchHelper.h"
#import "SearchViewController.h"

@interface SearchViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITableView *citiesAddedTableView;

@property NSMutableArray *searchResults;
@property NSMutableArray *citiesAdded;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchResults = [NSMutableArray new];
    self.citiesAdded = [[NSMutableArray alloc] initWithArray:[CoreDataHelper allFromEntityWithName:@"City"]];
    self.citiesAddedTableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchButtonClicked:(id)sender {
    self.searchBar.hidden = NO;
    self.searchButton.hidden = YES;
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
        
        cell.textLabel.text = self.searchResults[indexPath.row];
    }
    
    return cell;
}

#pragma mark - Searchbar tableview delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSDictionary *newCityDictionary = @{@"name" : self.searchBar.text};
        [CoreDataHelper createNewEntityWithName:@"City" andDictionary:newCityDictionary];
        
        [self.citiesAdded addObject:self.searchBar.text];
        [self.searchBar resignFirstResponder];
    }
}

#pragma mark - UISearchcontroller delegate

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
    [UIView animateWithDuration:.7 animations:^{
        self.searchBar.hidden = YES;
        self.searchButton.hidden = NO;
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


@end
