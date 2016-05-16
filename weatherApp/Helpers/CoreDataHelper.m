//
//  CoreDataHelper.m
//  weatherApp
//
//  Created by Adriana Elizondo on 5/15/16.
//  Copyright © 2016 Adriana Elizondo Aguayo. All rights reserved.
//

#import "CoreDataHelper.h"

@implementation CoreDataHelper

+(void)saveCoreDataStackWithCompletion:(CompletionBlock)completion{
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        completion(error);
    }];
}

+(NSArray *)allFromEntityWithName:(NSString *)name{
    return [NSClassFromString(name) MR_findAll];
}

+(NSManagedObject *)entityWithName:(NSString *)name attribute:(NSString *)attribute value:(id)value {
    NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]];
    if (entity) {
        if ([entity.attributesByName.allKeys containsObject:attribute]) {
            return [NSClassFromString(name) MR_findFirstByAttribute:attribute withValue:value];
        }
        else {
            NSLog(@"%@ does not have an attribute named %@", name, attribute);
        }
    }
    else {
        NSLog(@"%@ entity does not exist in the given object graph", name);
    }
    return nil;
}

+(NSManagedObject *)createNewEntityWithName:(NSString *)name andDictionary:(NSDictionary *)dictionary{
    
    __block NSManagedObject *object;
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext)
     {
         NSManagedObject *dataObject = [NSClassFromString(name) MR_importFromObject:dictionary inContext:[NSManagedObjectContext MR_defaultContext]];
         
         if ([[NSManagedObjectContext MR_defaultContext] obtainPermanentIDsForObjects:@[dataObject] error:nil])
         {
             object = dataObject;
         }
     }];
    return object;
}

@end
