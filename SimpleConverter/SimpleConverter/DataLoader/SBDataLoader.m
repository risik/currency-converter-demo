//
// Created by Sergei Borisov on 15/02/15.
// Copyright (c) 2015 Redmond. All rights reserved.
//

#import "SBDataLoader.h"


@interface SBDataLoader ()
        <
        NSURLConnectionDelegate
        >


@property(nonatomic, copy) NSString *url;

@property(nonatomic, copy) SBDataLoaderCompletion completion;

@end


@implementation SBDataLoader
{
    NSMutableData *_responseData;
}

- (instancetype)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        self.url = url;
    }

    NSAssert(self.url, @"url required");

    return self;
}

+ (instancetype)dataLoaderWithUrl:(NSString *)url
{
    return [[self alloc] initWithUrl:url];
}

#pragma mark implement SBLoadRecipesProtocol

- (void)loadDataWithCompletion:(SBDataLoaderCompletion)completion
{
    self.completion = completion;

    NSURL *url = [[NSURL alloc] initWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
                           {
                               if (error) {
                                   NSLog(@"%@", [error localizedDescription]);
                                   [self fireCompletionWithResult:nil error:error];

                               }
                               else {
                                   [self fireCompletionWithResult:data error:nil];
                               }
                           }];
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self fireCompletionWithResult:_responseData error:nil];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error loading data: %@", error.localizedDescription);
    [self fireCompletionWithResult:nil error:error];
}

- (void)fireCompletionWithResult:(NSData *)result error:(NSError *)error
{
    if (self.completion) {
        self.completion(result, error);
    }
}

@end