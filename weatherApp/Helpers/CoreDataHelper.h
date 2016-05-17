//
//  CoreDataHelper.h
//  weatherApp
//
//  Created by Adriana Elizondo on 5/15/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//
#import <MagicalRecord/MagicalRecord.h>
#import <Foundation/Foundation.h>

@interface CoreDataHelper : NSObject
typedef void (^CompletionBlock)(NSError *error);
typedef void (^SaveCompletionBlock)(id object, NSError * error);

+(void)saveCoreDataStackWithCompletion:(CompletionBlock)completion;
+(NSArray *)allFromEntityWithName:(NSString *)name;
+(NSManagedObject *)entityWithName:(NSString *)name attribute:(NSString *)attribute value:(id)value;
+(NSManagedObject *)createNewEntityWithName:(NSString *)name andDictionary:(NSDictionary *)dictionary;
+(BOOL)removeEntity:(NSManagedObject *)obj;

@end
