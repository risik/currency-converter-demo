//
//  SBCurrencyRateSaver.h
//  SimpleConverter
//
//  Created by Sergei Borisov on 14/02/15.
//  Copyright (c) 2015 Sergei Borisov for 2GIS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "SBCurrencyRateSaverProtocol.h"

typedef enum  {
    SBCurrencyRateSaverParseOk = 0,
    SBCurrencyRateSaverParseErrorInvalidDictionary,
    SBCurrencyRateSaverParseErrorSave,
} SBCurrencyRateSaverParseError;

@interface SBCurrencyRateSaver : NSObject <SBCurrencyRateSaverProtocol>

- (instancetype)initWithContext:(NSManagedObjectContext *)context;

+ (instancetype)saverWithContext:(NSManagedObjectContext *)context;


@end
