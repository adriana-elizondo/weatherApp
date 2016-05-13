//
//  MainDataModel.h
//  weatherApp
//
//  Created by Adriana Elizondo Aguayo on 5/13/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <UIKit/UIKit.h>

@interface MainDataModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, assign) CGFloat temperature;
@property (nonatomic, assign) CGFloat temperatureMin;
@property (nonatomic, assign) CGFloat temperatureMax;
@property (nonatomic, assign) CGFloat humidity;
@end
