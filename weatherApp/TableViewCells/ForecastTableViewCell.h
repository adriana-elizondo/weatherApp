//
//  ForecastTableViewCell.h
//  weatherApp
//
//  Created by Adriana Elizondo on 5/16/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForecastTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *forecastImage;
@property (weak, nonatomic) IBOutlet UIButton *showHideButton;

@end
