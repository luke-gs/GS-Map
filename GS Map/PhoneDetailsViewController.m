//
//  PhoneDetailsViewController.m
//  GS Map
//
//  Created by Luke sammut on 8/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//

#import "PhoneDetailsViewController.h"
#import <MagicalRecord/MagicalRecord.h>
#import "PhoneDataUtility.h"
#import "PhoneParseUtility.h"

@interface PhoneDetailsViewController ()

@property (strong,nonatomic) MKMapView* mapView;
@property (strong,nonatomic) UILabel *foundLabel;
@property (strong, nonatomic) UISwitch *foundSwitch;

@end

@implementation PhoneDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupViews];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mapView removeFromSuperview];
}

// Custom init that will provide the overlay effect with the map view from
// the previous VC
-(instancetype)initWithMapView:(MKMapView*)mapView
{
    self = [super init];
    if(self)
    {
        self.mapView = mapView;
    }
    return self;
}

#pragma mark - Helper Methods

// Method that is called when the switch is selected and changed by the user
-(IBAction)switchChanged:(id)sender
{
    UISwitch *switchButton = (UISwitch*) sender;
    [self updatePhoneMissingInformation:switchButton.on];
}

// If the user switches the phone to found, update the information in the core data
-(void) updatePhoneMissingInformation:(BOOL) found
{
    if(!found)
    {
        self.phone.found = @0;
        self.foundLabel.text = @"Missing";
    }else{
        self.phone.found = @1;
        self.foundLabel.text = @"Found";
    }
    
    // Calls both the parse and the core data variants of the update methods to update data
    __weak PhoneDetailsViewController *weakSelf = self;
    [PhoneParseUtility updatePhoneForFound:self.phone withFound:found withCompletion:^{
        [PhoneDataUtility updatePhoneWhenFound:weakSelf.phone forFoundBool:found withCompletion:^{

        }];
    }];
}

#pragma mark - Setup views

-(void) setupViews
{
    // Set up the map kit and the blur effect
    // This is used to create a blur effect that will be layered on top of the map view that has been passed in
    // from the previous view controller
    UIView *superView = self.view;
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark ];
    UIVisualEffectView *overlayEffect = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    
    // The overlay effect
    overlayEffect.backgroundColor = [UIColor clearColor];
    overlayEffect.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Add the views to the superview
    [superView addSubview:self.mapView];
    [superView addSubview:overlayEffect];
    
    // Setup phone Name Label
    UILabel * phoneNameLabel = [[UILabel alloc]init];
    phoneNameLabel.textColor = [UIColor whiteColor];
    phoneNameLabel.text = self.phone.code;
    phoneNameLabel.font = [UIFont systemFontOfSize:30 weight:UIFontWeightBold];
    phoneNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [superView addSubview:phoneNameLabel];
    
    // Set up the Phone Image
    UIImageView *phoneImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iPhone"]];
    phoneImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [superView addSubview:phoneImageView];
    
    // Setup address Label
    UILabel *addressLabel = [[UILabel alloc]init];
    addressLabel.textColor = [UIColor whiteColor];
    addressLabel.numberOfLines = 0;
    addressLabel.textAlignment = NSTextAlignmentCenter;
    addressLabel.text = self.phone.address;
    addressLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightMedium];
    addressLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [addressLabel adjustsFontSizeToFitWidth];
    [superView addSubview:addressLabel];
    
    // Setup missing Label
    self.foundLabel = [[UILabel alloc]init];
    self.foundLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightMedium];
    self.foundLabel.textColor = [UIColor whiteColor];
    self.foundLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [superView addSubview:self.foundLabel];
    
    // Setup switch
    self.foundSwitch = [[UISwitch alloc]init];
    self.foundSwitch.on = self.phone.found;
    self.foundSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.foundSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    
    // Depending on whether the switch is on or off change the label
    if([self.phone.found  isEqual: @0]) {
        self.foundLabel.text = @"Missing";
        self.foundSwitch.on = NO;
    }else{
        self.foundLabel.text = @"Found";
        self.foundSwitch.on = YES;
    }
    [superView addSubview:self.foundSwitch];
    
    
    //----------------------------------------------------
    //                     Constraints
    //----------------------------------------------------
    [NSLayoutConstraint activateConstraints:@[
    
                                              
    // Map view constraints
    [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
    [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem: superView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
    [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
    [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
    
    //Overlay blur effects constraints
    [NSLayoutConstraint constraintWithItem:overlayEffect attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
    [NSLayoutConstraint constraintWithItem:overlayEffect attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
    [NSLayoutConstraint constraintWithItem:overlayEffect attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
    [NSLayoutConstraint constraintWithItem:overlayEffect attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
    
    // Phone Name label constraints
    [NSLayoutConstraint constraintWithItem:phoneNameLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
    [NSLayoutConstraint constraintWithItem:phoneNameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1.0 constant:40],
    
    //Phone image constraints
    [NSLayoutConstraint constraintWithItem:phoneImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:phoneNameLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:15],
    [NSLayoutConstraint constraintWithItem:phoneImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
    
    // Address Label
    [NSLayoutConstraint constraintWithItem:addressLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:5],
    [NSLayoutConstraint constraintWithItem:addressLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-5],
    [NSLayoutConstraint constraintWithItem:addressLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:phoneImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:30],
    
    // Missing label
    [NSLayoutConstraint constraintWithItem:self.foundLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
    [NSLayoutConstraint constraintWithItem:self.foundLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:addressLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:30],
    
    // Switch constraints
    [NSLayoutConstraint constraintWithItem:self.foundSwitch attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
    [NSLayoutConstraint constraintWithItem:self.foundSwitch attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.foundLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:30],
    [NSLayoutConstraint constraintWithItem:self.foundSwitch attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-30],
    ]];
}

@end
