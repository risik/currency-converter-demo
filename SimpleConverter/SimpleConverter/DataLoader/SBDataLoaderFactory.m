//
// Created by Sergei Borisov on 20/02/15.
// Copyright (c) 2015 Sergei Borisov for 2GIS. All rights reserved.
//

#import "SBDataLoaderFactory.h"
#import "SBDataLoader.h"


@interface SBDataLoaderFactory ()

@property (nonatomic, copy) NSString *baseUrl;

@property (nonatomic, copy) NSString *suffix;

@end

@implementation SBDataLoaderFactory
{

}

- (instancetype)initWithBaseUrl:(NSString *)baseUrl suffix:(NSString *)suffix
{
    self = [super init];
    if (self) {
        self.baseUrl = baseUrl;
        self.suffix = suffix;
    }

    NSAssert(self.baseUrl, @"baseUrl required");

    return self;
}

+ (instancetype)factoryWithBaseUrl:(NSString *)baseUrl suffix:(NSString *)suffix
{
    return [[self alloc] initWithBaseUrl:baseUrl suffix:suffix];
}

- (id <SBDataLoaderProtocol>)createDataLoaderWithUrl:(NSString *)url
{
    NSString *fullUrl = nil;
    if (self.suffix) {
        fullUrl = [NSString stringWithFormat:@"%@/%@%@", self.baseUrl, url, self.suffix];
    }
    else {
        fullUrl = [NSString stringWithFormat:@"%@/%@", self.baseUrl, url];
    }
    return [SBDataLoader dataLoaderWithUrl:fullUrl];
}

@end