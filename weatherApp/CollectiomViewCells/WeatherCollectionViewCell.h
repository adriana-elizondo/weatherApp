//
//  WeatherCollectionViewCell.h
//  weatherApp
//
//  Created by Adriana Elizondo on 5/14/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UILabel *maxMinTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
