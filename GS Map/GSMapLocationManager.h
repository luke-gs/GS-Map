//
//  GSMapLocationManager.h
//  GS Map
//
//  Created by Luke sammut on 8/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GSMapLocationManager : NSObject

+ (instancetype)sharedManager;

// Returns the users current location
-(CLLocation*) currentLocation;

-(void) reverseGeocode:(CLLocation*) location withCompletionHandler:(void (^) (NSString *address, NSError *error)) completionHandler;

@end
