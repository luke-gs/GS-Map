//
//  GSMapViewController.m
//  GS Map
//
//  Created by Luke sammut on 8/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//

#import "GSMapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "GSMapPointAnnotation.h"
#import "GSMapLocationManager.h"

@interface GSMapViewController () <MKMapViewDelegate>

// The map view property
@property (strong, nonatomic) MKMapView *mapView;

// The location manager property, manages core location
@property (strong, nonatomic) GSMapLocationManager *locationManager;

@end

@implementation GSMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up the view and constraints
    [self setupViews];
}

#pragma mark - Set up views

-(void) setupViews
{
    // Set up the location manager
    self.locationManager = [GSMapLocationManager sharedManager];
    
    
    // Set up the map view
    self.mapView = [[MKMapView alloc]initWithFrame:self.view.frame];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.mapView showsUserLocation];
    [self.view addSubview:self.mapView];
    
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
    ]];
}

#pragma mark - Map View Delegate

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
        for (GSMapPointAnnotation *storedAnnotation in [self.mapView annotations]) {
            
            //make sure the annotations are the type of GS Map  Annotation
            if([storedAnnotation isKindOfClass:[GSMapPointAnnotation class]])
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
    
    // If there is no existig annotation then it will add a new one
    if(!existingAnnotation)
    {
        
        [self.locationManager reverseGeocode:newLocation withCompletionHandler:^(NSString *address, NSError *error) {
            annotation.subtitle = address;
        }];
        [self.mapView addAnnotation: annotation];
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
    
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
}

-(void) refreshMapView
{
    [self.mapView showsUserLocation];
}
@end
