//
// Created by Sergei Borisov on 08/03/15.
// Copyright (c) 2015 Sergei Borisov. All rights reserved.
//

#import "SBDataProvider.h"
#import "SBRateDataProtocol.h"
#import "NSObject+DHDUtils.h"

@interface SBDataProvider ()
        <
        NSFetchedResultsControllerDelegate
        >

@property(nonatomic, strong) NSManagedObjectContext *managedContext;

@property(nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;

@property(nonatomic, strong) NSArray *fetchedArray;

@property(nonatomic, strong) NSDictionary *fetchedDictionary;

@end

@implementation SBDataProvider
{
    NSFetchedResultsController *_fetchedResultsController;
}

- (instancetype)initWithManagedContext:(NSManagedObjectContext *)managedContext
{
    self = [super init];
    if (self) {
        self.managedContext = managedContext;
        NSAssert(self.managedContext, @"managedContext required");
    }

    return self;
}

+ (instancetype)providerWithManagedContext:(NSManagedObjectContext *)managedContext
{
    return [[self alloc] initWithManagedContext:managedContext];
}

#pragma mark implement SBDataProviderProtocol

- (NSUInteger)count
{
    return self.fetchedArray.count;
}

- (id <SBRateDataProtocol>)rateByCode:(NSString *)currencyCode
{
    id <SBRateDataProtocol> result = self.fetchedDictionary[currencyCode];
    if (!result) {
        NSString *message = [NSString stringWithFormat:@"Currency for code: '%@' not found", currencyCode];
        @throw [NSException exceptionWithName:@"SBDataProviderCurrencyNotFound"
                                       reason:message
                                     userInfo:nil];
    }
    return result;
}

- (id <SBRateDataProtocol>)rateByIndex:(NSUInteger)index
{
    return self.fetchedArray[index];
}

#pragma mark fetch controller delegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    @synchronized (self) {
        self.fetchedArray = nil;
        self.fetchedDictionary = nil;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    @synchronized (self) {
        self.fetchedArray = nil;
        self.fetchedDictionary = nil;
    }
}

#pragma mark private properties

- (NSArray *)fetchedArray
{
    @synchronized (self) {
        return [self fetchedArrayInternal];
    }
}

- (NSDictionary *)fetchedDictionary
{
    @synchronized (self) {
        return [self fetchedDictionaryInternal];
    }
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController) {
        [self initializeFetchController];
    }

    return _fetchedResultsController;
}

#pragma mark internal

- (NSArray *)fetchedArrayInternal
{
    if (!_fetchedArray) {
        _fetchedArray = self.fetchedResultsController.fetchedObjects;
    }
    return _fetchedArray;
}

- (NSDictionary *)fetchedDictionaryInternal
{
    NSArray *array = [self fetchedArrayInternal];
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:array.count];
    for (id <SBRateDataProtocol> rate in array) {
        if ([NSObject dhd_isNil:rate.code]) {
            continue;
        }
        result[rate.code] = rate;
    }
    return result;
}

- (void)initializeFetchController
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SBRate"];

    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES]]];

    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:self.managedContext
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:nil];

    [self.fetchedResultsController setDelegate:self];

    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];

    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
}

@end