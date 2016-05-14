//
//  SearchViewController.m
//  weatherApp
//
//  Created by Adriana Elizondo on 5/14/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Searchbar tableview delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.detailTextLabel.text = @"test";
    return cell;
}

@end
