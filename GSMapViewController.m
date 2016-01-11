//
//  GSMapViewController.m
//  GS Map
//
//  Created by Luke sammut on 8/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//

#import "GSMapViewController.h"
#import <MagicalRecord/MagicalRecord.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "GSMapPointAnnotation.h"
#import "Phone.h"
#import "Phone+Extended.h"
#import "PhoneDetailsViewController.h"
#import "GSMapLocationManager.h"
#import "PhoneDataUtility.h"
#import "GSMapPinAnnotationView.h"
#import "PhoneParseUtility.h"

// static variables
static NSString *const MapTableViewCellIdentifier = @"mapTableViewCellIdentifier";
static CGFloat const TableViewHeaderHeight = 30.0;
static CGFloat const TableViewMaxHeight = 200;

@interface GSMapViewController () <MKMapViewDelegate, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource>

// The map view property
@property (strong, nonatomic) MKMapView *mapView;

// The location manager property, manages core location
@property (strong, nonatomic) GSMapLocationManager *locationManager;

// Table view properties
@property (strong,nonatomic) UITableView *tableView;
@property (nonatomic) CGFloat tableViewOffset;
@property (nonatomic) CGFloat tableViewHeight;
@property (nonatomic) BOOL isTableViewHidden;

// Fetched results controller for Core Data
@property(strong,nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation GSMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up the view and constraints
    [self setupViews];
    
    self.isTableViewHidden = NO;
    self.tableViewOffset = -TableViewMaxHeight;
}

// Reset the map view when coming back from the phone details view controller
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.mapView.superview)
    {
        [self.view addSubview:self.mapView];
        [self.view sendSubviewToBack:self.mapView];
        
        //----------------------------------------------------
        //                     Constraints
        //----------------------------------------------------
        
        [NSLayoutConstraint activateConstraints:@[
                                                  
          // Map view constraints
          [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
          [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
          [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
          [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
          ]];
    }
}

#pragma mark - Set up views

-(void) setupViews
{
    // Set up the location manager
    self.locationManager = [GSMapLocationManager sharedManager];
    
    // Set up the map view
    self.mapView = [[MKMapView alloc]init];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow];
    [self.view addSubview:self.mapView];
    
    // Sset up the table view
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableViewOffset = -self.view.frame.size.height * 0.3;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.backgroundView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    // Set up a fetched results controller that will fetch all the phones currently in core data
    self.fetchedResultsController = [Phone MR_fetchAllSortedBy:nil ascending:YES withPredicate:nil groupBy:nil delegate:self];
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }

    // Add all the annotations that have been previosuly loaded if there are any
    [self addAllAnnotations];
    
    // Set up the Navigation Bar Button Items
    // Add annotation bar button item
    UIBarButtonItem *addAnnotationBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"LocationIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(addGSMapAnnotation)];
    
    // Tracking location bar button item
    MKUserTrackingBarButtonItem *shouldTrackLocationBarButtonItem = [[MKUserTrackingBarButtonItem alloc]initWithMapView:self.mapView];
    
    // Refresh map view bar button item
    UIBarButtonItem *refreshBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshMapView)];
    
    // Add the bar button items to the navigation item
    self.navigationItem.rightBarButtonItems = @[refreshBarButtonItem, addAnnotationBarButtonItem];
    self.navigationItem.leftBarButtonItem = shouldTrackLocationBarButtonItem;
    
    //----------------------------------------------------
    //                     Constraints
    //----------------------------------------------------
    
        [NSLayoutConstraint activateConstraints:@[
        
        // Map view constraints
        [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
        [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
        [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
        [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
        
        // Table view constraints
        [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
        [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
        [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
        [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-TableViewMaxHeight],
        ]];
}

#pragma mark - Helper Methods

/**
 *   Adds all the previous annotations from the fetched results
 */
-(void) addAllAnnotations
{
    if([self.mapView.annotations count] == 0)
    {
        NSArray *phones = [self.fetchedResultsController fetchedObjects];
        [self.mapView showAnnotations:phones animated:YES];
    }
}

// Helper method that will be called when a user swipes on the table view
-(void) deletePhone:(Phone*) phone
{
    [PhoneParseUtility removePhoneFromParseData:phone withCompletion:^{
        [PhoneDataUtility removePhoneFromCoreData:phone withCompletion:^{
            [self.mapView removeAnnotation:phone];
        }];
    }];
}

#pragma mark - Scroll View Delegate

// Animates the hiding of the table view when a user scrolls down
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y < 0)
    {
        [UIView animateWithDuration:0.6 animations:^{
            CGRect rect = self.tableView.frame;
            rect = CGRectMake(0, self.view.frame.size.height - TableViewHeaderHeight, rect.size.width, TableViewHeaderHeight);
            self.tableView.frame = rect;
        }];
    }
}

#pragma mark - Map View Delegate

/**
 *  Method to add an annotation to the map view
    Checks the map view for existing annotation in that spot and if there isn't it will add one
    Upon adding an annotation phone, it is saved to Parse
    It is also saved to core data
 */
-(void) addGSMapAnnotation
{
    CLLocationCoordinate2D newCoordinate = [self.locationManager currentLocation].coordinate;
    GSMapPointAnnotation *annotation = [[GSMapPointAnnotation alloc]initWithCoordinate:[self.locationManager currentLocation].coordinate];
    CLLocation *newLocation = [[CLLocation alloc]initWithLatitude:newCoordinate.latitude longitude:newCoordinate.longitude];
    
    // Bool to see if there is an existing annotation
    BOOL existingAnnotation = NO;
    
    // This checks whether there is an existing GSMapAnnotation on the map already
    // If there is then it won't add a new one, but if there isn't then it will add a new annotation
    if([[self.mapView annotations] count]>0 )
    {
        for (Phone *storedAnnotation in [self.mapView annotations]) {
            
            //make sure the annotations are the type of GS Map  Annotation
            if([storedAnnotation isKindOfClass:[Phone class]])
            {
                CLLocation *oldLocation = [[CLLocation alloc]initWithLatitude:storedAnnotation.coordinate.latitude longitude:storedAnnotation.coordinate.longitude];
                
                // Compare the two values of locations
                if([newLocation distanceFromLocation:oldLocation] < 10)
                {
                    existingAnnotation = YES;
                    break;
                }
            }
        }
    }
    
    // If there is no existing annotation then it will add a new one
    if(!existingAnnotation)
    {
        __weak GSMapViewController *weakSelf = self;
        [self.locationManager reverseGeocodeWithCompletionHandler:^(NSString *address, NSError *error) {
            annotation.subtitle = address;
            
            // Creating PFObject to save in Parse first
            PFObject *phoneObject = [PFObject objectWithClassName:@"Phone"];
            phoneObject[@"address"] = address;
            phoneObject[@"latitude"] = @(newCoordinate.latitude) ;
            phoneObject[@"longitude"] = @(newCoordinate.longitude);
            phoneObject[@"found"] = [NSNumber numberWithBool:NO];
            
            // Save the phone to Parse
            [PhoneParseUtility savePhoneInParse:phoneObject withCompletion:^(PFObject *phoneObject) {
                
                // Save the PFObject to core data
                [PhoneDataUtility savePFObjectToCoreData:phoneObject withCompletionHandler:^(Phone *phone) {
                    [weakSelf.mapView addAnnotation:phone];
                }];
            }];
        }];
    }
}

/**
 *  Changes the custom annoations to include a detail disclosure button
 *
 *  @param mapView    The view controllers map view
 *  @param annotation A GS Map Point Annotation
 *
 *  @return The annotation view with a detail disclosure button
 */
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    GSMapPinAnnotationView *annotationView = [[GSMapPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.animatesDrop = YES;
    Phone *phone = (Phone*) annotation;
    annotationView.pinTintColor = [phone pinColor];
    
    [annotationView addCalloutAction:^{
        [self showPhoneDetailsWithPhone:(Phone*)annotation];
    }];

    return annotationView;
}

// Sets the maps location back to the current location of the user
-(void) refreshMapView
{
    self.mapView.showsUserLocation = YES;
}

#pragma mark - Tableview Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections]count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MapTableViewCellIdentifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MapTableViewCellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - TableView Delegate

/**
 *  Create a custom view that will be set as the view for the header in the table view
    Adds a label and allows for flexibility
 *
 *  @param tableView view controllers tableview
 *  @param section   In this application there is only one section
 *
 *  @return The view that will be assigned to the header section of the Table view
 */
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIVisualEffectView *headerView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    headerView.backgroundColor = [UIColor clearColor];
    
    // Add a label to the view
    UILabel *headerLabel = [[UILabel alloc]init];
    headerLabel.text = @"iPhones";
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:headerLabel];
    
    //----------------------------------------------------
    //                     Constraints
    //----------------------------------------------------
    
    // Label for header constraints
    [NSLayoutConstraint constraintWithItem:headerLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeTop multiplier:1.0 constant:5].active = YES;
    [NSLayoutConstraint constraintWithItem:headerLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0].active = YES;
    
    return headerView;
}

// Height of the table view header
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

// Handles when the user selects a row in the table view
// Will navigate the user to the phone details page
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhoneDetailsViewController *phoneDetailsVC = [[PhoneDetailsViewController alloc]initWithMapView:self.mapView];
    Phone *phone = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    phoneDetailsVC.phone = phone;

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setHighlighted:NO animated:YES];
    
    [self.navigationController pushViewController:phoneDetailsVC animated:YES];
}

// Handles the deletion of phones from the mapview, Core Data and Parse databases
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Phone *phone = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        [self deletePhone:phone];
    }
}

#pragma mark - Navigation

// When a user clicks on an annotation that is a phone annotation they will be taken to
// a new view controller that will diplay the details of the phone
-(void) showPhoneDetailsWithPhone:(Phone*) phoneFromAnnotation
{
    PhoneDetailsViewController *phoneDetailsVC = [[PhoneDetailsViewController alloc]initWithMapView:self.mapView];
    phoneDetailsVC.phone = phoneFromAnnotation;
    [self.navigationController pushViewController:phoneDetailsVC animated:YES];
}

#pragma mark - Fetched Results Controller Delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo
atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            //insert funcationality
            break;
        case NSFetchedResultsChangeUpdate:
            //insert functioanlity
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

// Change how the cells in the table view will be formatted
- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    Phone *phone = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = phone.code;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.text = phone.address;
    cell.detailTextLabel.textColor = [UIColor whiteColor];
}
@end
