//
//  SBConverterMainViewController.m
//  SimpleConverter
//
//  Created by Sergei Borisov on 20/02/15.
//  Copyright (c) 2015 Sergei Borisov for 2GIS. All rights reserved.
//

#import "SBConverterMainViewController.h"
#import "SBRate.h"
#import <CoreData/CoreData.h>

@interface SBConverterMainViewController ()
        <
        UIPickerViewDataSource,
        UIPickerViewDelegate,
        NSFetchedResultsControllerDelegate
        >

@property(weak, nonatomic) IBOutlet UIPickerView *picker;

@property(weak, nonatomic) IBOutlet UITextField *sourceField;

- (IBAction)sourceChanged:(id)sender;

@property(weak, nonatomic) IBOutlet UILabel *resultLabel;

@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property(nonatomic, strong) NSManagedObjectContext *context;

@property(weak, nonatomic) IBOutlet UIButton *retryButton;

- (IBAction)retryClick:(id)sender;

@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *busyIndicator;

@end

@implementation SBConverterMainViewController

- (instancetype)initWithContext:(NSManagedObjectContext *)context
{
    self = [super init];
    if (self) {
        self.context = context;
    }

    return self;
}

+ (instancetype)controllerWithContext:(NSManagedObjectContext *)context
{
    return [[self alloc] initWithContext:context];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializeFetchController];
}

- (void)initializeFetchController
{
// Initialize Fetch Request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SBRate"];

    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES]]];

    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:self.context
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

- (void)viewWillAppear:(BOOL)animated
{
    [self.busyIndicator stopAnimating];
    self.busyIndicator.hidden = YES;

    self.sourceField.enabled = NO;

    self.picker.userInteractionEnabled = NO;

    self.retryButton.hidden = YES;
    self.retryButton.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sourceChanged:(id)sender
{
}

#pragma mark picker delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *sections = self.fetchedResultsController.sections;
    id sectionInfo = sections[0];
    NSUInteger numberOfObjects = [sectionInfo numberOfObjects];
    return numberOfObjects;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *objects = self.fetchedResultsController.fetchedObjects;
    SBRate *sbRate = objects[(NSUInteger) row];
    return sbRate.name;
}

#pragma mark fetch controller delegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.picker reloadAllComponents];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    [self.picker reloadAllComponents];
}

- (IBAction)retryClick:(id)sender
{
    if (self.delegate) {
        [self.delegate retryPressed];
    }
}

- (void)showBusy
{
    [self.busyIndicator startAnimating];
}

- (void)makeReady
{
    self.sourceField.enabled = YES;
    self.picker.userInteractionEnabled = YES;
}

- (void)enableRetry
{
    self.retryButton.hidden = NO;
    self.retryButton.enabled = YES;
}

@end
