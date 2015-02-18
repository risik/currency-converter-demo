//
//  SBRate.h
//  SimpleConverter
//
//  Created by Sergei Borisov on 18/02/15.
//  Copyright (c) 2015 Sergei Borisov for 2GIS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SBRate : NSManagedObject

@property(nonatomic, retain) NSString *code;
@property(nonatomic, retain) NSNumber *rate;
@property(nonatomic, retain) NSString *name;

@end
