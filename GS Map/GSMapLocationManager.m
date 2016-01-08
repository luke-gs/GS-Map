//
//  GSMapLocationManager.m
//  GS Map
//
//  Created by Luke sammut on 8/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//

#import "GSMapLocationManager.h"

@interface GSMapLocationManager() <CLLocationManagerDelegate>

@property (strong,nonatomic) CLLocationManager *locationManager;

@property (strong,nonatomic) CLGeocoder *geoCoder;

@end

@implementation GSMapLocationManager

+ (instancetype)sharedManager {
    static GSMapLocationManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[GSMapLocationManager alloc] init];
    });
    
    return _sharedManager;
}

-(CLGeocoder*)geoCoder
{
    if(!_geoCoder)
    {
        _geoCoder = [[CLGeocoder alloc] init];
    }
    return _geoCoder;
}

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        self.locationManager.distanceFilter =  100;
        [self.locationManager startUpdatingLocation];
    }
    return self;
}

-(CLLocation*) currentLocation
{
    return self.locationManager.location;
}

-(void) reverseGeocode:(CLLocation*) location withCompletionHandler:(void (^) (NSString *address, NSError *error)) completionHandler
{
        [self.geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(error)
        {
            NSLog(@"Error %@", error);
        }
        else {
            CLPlacemark *placeMark = [placemarks lastObject];
            NSString *addressString = [((NSArray*) placeMark.addressDictionary[@"FormattedAddressLines"]) componentsJoinedByString:@" "];
            completionHandler(addressString, error);
        }
    }];
}


@end