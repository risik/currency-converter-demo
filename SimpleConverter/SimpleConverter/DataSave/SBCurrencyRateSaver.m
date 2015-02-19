//
//  SBCurrencyRateSaver.m
//  SimpleConverter
//
//  Created by Sergei Borisov on 14/02/15.
//  Copyright (c) 2015 Sergei Borisov for 2GIS. All rights reserved.
//

#import "SBCurrencyRateSaver.h"
#import "SBRate.h"
#import "NSDictionary+Utils.h"
#import "NSString+Utils.h"

@interface SBCurrencyRateSaver ()

@property(nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation SBCurrencyRateSaver

- (instancetype)initWithContext:(NSManagedObjectContext *)context
{
    self = [super init];
    if (self) {
        self.context = context;
    }

    NSAssert(self.context, @"managed context required");
    NSAssert(self.context.undoManager, @"managed context have to have undo manager");

    return self;
}

+ (instancetype)saverWithContext:(NSManagedObjectContext *)context
{
    return [[self alloc] initWithContext:context];
}

#pragma mark implement SBRateCreatorProtocol

- (BOOL)saveCurrencies:(NSDictionary *)currenciesDictionary
              andRates:(NSDictionary *)ratesDictionary
                 error:(NSError **)pError
{

    if (![self checkValidityForCurrencies:currenciesDictionary andRates:ratesDictionary error:pError]) {
        return NO;
    }

    NSUndoManager *undoManager = self.context.undoManager;
    [undoManager beginUndoGrouping];

    NSArray *rates = [self getAllRates];
    for (NSManagedObject *rate in rates) {
        [self.context deleteObject:rate];
    }

    NSError *error = nil;

    if (![self saveCurrenciesWithDictionary:currenciesDictionary error:&error]) {
        *pError = error;
        [undoManager endUndoGrouping];
        [undoManager undo];
        return NO;
    }

    if (![self saveRateWithDictionary:ratesDictionary error:&error]) {
        *pError = error;
        [undoManager endUndoGrouping];
        [undoManager undo];
        return NO;
    }

    [undoManager endUndoGrouping];

    if (![self.context save:&error]) {
        *pError = error;
        return NO;
    }

    return YES;
}

- (BOOL)hasData
{
    return [self getAllRates].count > 0;
}

#pragma mark internal

- (BOOL)checkValidityForCurrencies:(NSDictionary *)currenciesDictionary
                          andRates:(NSDictionary *)ratesDictionary
                             error:(NSError **)pError
{
    if ([NSDictionary isEmpty:currenciesDictionary]) {
        NSLog(@"Couldn't parsing currencies: not dictionary");
        [self fillError:pError withErrorCode:SBCurrencyRateSaverParseErrorInvalidDictionary withUserInfo:nil];
        return NO;
    }

    if ([NSDictionary isEmpty:ratesDictionary]) {
        NSLog(@"Couldn't parsing rates: not dictionary");
        [self fillError:pError withErrorCode:SBCurrencyRateSaverParseErrorInvalidDictionary withUserInfo:nil];
        return NO;
    }

    for (NSString *key in currenciesDictionary.allKeys) {
        if (ratesDictionary[key] == nil) {
            [self fillError:pError withErrorCode:SBCurrencyRateSaverParseErrorInvalidDictionary withUserInfo:nil];
            return NO;
        }
    }

    for (NSString *key in ratesDictionary.allKeys) {
        if (currenciesDictionary[key] == nil) {
            [self fillError:pError withErrorCode:SBCurrencyRateSaverParseErrorInvalidDictionary withUserInfo:nil];
            return NO;
        }
    }

    return YES;
}

- (BOOL)saveCurrenciesWithDictionary:(NSDictionary *)dictionary error:(NSError **)pError
{
    if (![self applyCurrencyNamesWithDictionary:dictionary error:pError]) {
        return NO;
    }

    return YES;
}

- (BOOL)saveRateWithDictionary:(NSDictionary *)dictionary error:(NSError **)pError
{
    if (![self applyRatesWithDictionary:dictionary error:pError]) {
        return NO;
    }

    return YES;
}

- (BOOL)applyCurrencyNamesWithDictionary:(NSDictionary *)dictionary error:(NSError **)pError
{
    for (NSString *key in dictionary) {
        if ([NSString isEmpty:key]) {
            NSLog(@"Couldn't parsing rate: invalid key: '%@'", key);
            [self fillError:pError withErrorCode:SBCurrencyRateSaverParseErrorInvalidDictionary withUserInfo:nil];
            return NO;
        }

        SBRate *sbRate = [self rateWithId:key];
        NSString *currencyName = dictionary[key];
        [self updateRate:sbRate withCurrencyName:currencyName];
    }
    return YES;
}

- (BOOL)applyRatesWithDictionary:(NSDictionary *)dictionary error:(NSError **)pError
{
    for (NSString *key in dictionary) {
        if ([NSString isEmpty:key]) {
            NSLog(@"Couldn't parsing rate: invalid key: '%@'", key);
            [self fillError:pError withErrorCode:SBCurrencyRateSaverParseErrorInvalidDictionary withUserInfo:nil];
            return NO;
        }

        SBRate *sbRate = [self rateWithId:key];
        NSNumber *rate = dictionary[key];
        [self updateRate:sbRate withRate:rate];
    }
    return YES;
}

- (SBRate *)rateWithId:(NSString *)code
{
    SBRate *sbRate = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];

    request.entity = [NSEntityDescription entityForName:@"SBRate" inManagedObjectContext:self.context];
    request.predicate = [NSPredicate predicateWithFormat:@"code = %@", code];

    NSError *error = nil;
    sbRate = [[self.context executeFetchRequest:request error:&error] lastObject];

    if (error) {
        NSLog(@"%s error looking up recipe with code: %@ with error: %@", __PRETTY_FUNCTION__, code, error.localizedDescription);
        return nil;
    }

    if (sbRate) {
        return sbRate;
    }

    sbRate = [NSEntityDescription insertNewObjectForEntityForName:@"SBRate" inManagedObjectContext:self.context];
    sbRate.code = code;

    return sbRate;
}

- (NSArray *)getAllRates
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];

    request.entity = [NSEntityDescription entityForName:@"SBRate" inManagedObjectContext:self.context];

    NSError *error = nil;
    NSArray *result = [self.context executeFetchRequest:request error:&error];

    if (error) {
        NSLog(@"error during get currency rate from DB: %@", error.localizedDescription);
        return nil;
    }

    return result;
}

- (void)updateRate:(SBRate *)recipe withCurrencyName:(NSString *)currencyName
{
    recipe.name = currencyName;
}

- (void)updateRate:(SBRate *)recipe withRate:(NSNumber *)rate
{
    recipe.rate = rate;
}

- (void)fillError:(NSError **)pError withErrorCode:(int)errorCode withUserInfo:(NSDictionary *)userInfo
{
    if (!pError) {
        return;
    }
    *pError = [NSError errorWithDomain:@"SBParseCurrencyRate" code:errorCode userInfo:userInfo];
}

@end
