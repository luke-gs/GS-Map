//
//  GSMapViewController.m
//  GS Map
//
//  Created by Luke sammut on 8/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//

#import "GSMapViewController.h"
#import <MapKit/MapKit.h>

@interface GSMapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) MKMapView *mapView;

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
    // Set up the map view
    self.mapView = [[MKMapView alloc]initWithFrame:self.view.frame];
    self.mapView.delegate = self;
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.mapView];
    
    // Set up the Navigation Bar Button Items
    // Add annotation bar button item
    UIBarButtonItem *addAnnotationBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];
    
    // Refresh map view bar button item
    UIBarButtonItem *refreshBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:nil];
    
    // Add the bar button items to the navigation item
    self.navigationItem.rightBarButtonItems = @[refreshBarButtonItem, addAnnotationBarButtonItem];
    
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


@end
