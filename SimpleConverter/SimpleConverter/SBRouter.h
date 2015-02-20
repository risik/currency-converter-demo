//
// Created by Sergei Borisov on 20/02/15.
// Copyright (c) 2015 Sergei Borisov for 2GIS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>


@interface SBRouter : NSObject

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext window:(UIWindow *)window;

+ (instancetype)routerWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext window:(UIWindow *)window;


- (void)start;

@end