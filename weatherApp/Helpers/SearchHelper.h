//
//  SearchHelper.h
//  weatherApp
//
//  Created by Adriana Elizondo on 5/14/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^SearchResult) (NSArray *results, NSError *error);

@interface SearchHelper : NSObject

+(void)getListOfCitiesWithString:(NSString *)string withCompletion:(SearchResult)completion;

@end
