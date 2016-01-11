//
//  PhoneDetailsViewController.h
//  GS Map
//
//  Created by Luke sammut on 8/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Phone.h"

@interface PhoneDetailsViewController : UIViewController

-(instancetype)initWithMapView:(MKMapView*)mapView;

@property (strong, nonatomic) Phone *phone;

@property (nonatomic, copy) void (^updatePhone)(Phone *phone);

@end
