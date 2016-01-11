//
//  PhoneParseUtility.h
//  GS Map
//
//  Created by Luke sammut on 11/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Phone.h"
#import "PhoneDataUtility.h"
#import <Parse/Parse.h>

@interface PhoneParseUtility : NSObject

+(void) savePhoneInParse:(PFObject*) phoneObject withCompletion:(void (^)(PFObject *phoneObject)) completion;

+(void) updatePhoneForFound:(Phone*) phone withFound:(BOOL) found withCompletion:(void (^)()) completion;

+(void) removePhoneFromParseData:(Phone*) phone withCompletion:(void(^)()) completion;

@end
