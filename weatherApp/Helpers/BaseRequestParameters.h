//
//  BaseRequestParameters.h
//  weatherApp
//
//  Created by Adriana Elizondo Aguayo on 5/13/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface BaseRequestParameters : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *units;
@property (nonatomic, strong) NSString *apiKey;

-(NSDictionary *)parametersDictionary;

@end
