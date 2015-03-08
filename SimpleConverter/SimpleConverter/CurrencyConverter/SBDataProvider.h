//
// Created by Sergei Borisov on 08/03/15.
// Copyright (c) 2015 Sergei Borisov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "SBDataProviderProtocol.h"


@interface SBDataProvider : NSObject <SBDataProviderProtocol>

- (instancetype)initWithManagedContext:(NSManagedObjectContext *)managedContext;

+ (instancetype)providerWithManagedContext:(NSManagedObjectContext *)managedContext;

@end