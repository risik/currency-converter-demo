//
// Created by Sergei Borisov on 15/02/15.
// Copyright (c) 2015 Redmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Testing)

+ (instancetype)testing_inMemoryContext:(NSManagedObjectContextConcurrencyType)concurrencyType error:(NSError **)error;

@end