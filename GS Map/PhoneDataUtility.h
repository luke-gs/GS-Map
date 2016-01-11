//
//  PhoneDataUtility.h
//  GS Map
//
//  Created by Luke sammut on 10/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//

#import "Phone.h"
#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

@interface PhoneDataUtility : NSObject

+(void) savePhoneToCoreData:(Phone*) phone withCompletionHandler: (void (^)(Phone* phone)) completion;

+(void) savePFObjectToCoreData:(PFObject*) phoneObject withCompletionHandler: (void (^)(Phone* phone)) completion;

+(void) updatePhoneWhenFound:(Phone*) phone forFoundBool:(BOOL) found withCompletion:(void (^)()) completion;

+(void) removePhoneFromCoreDataWithID:(NSString*) phoneID withCompletion:(void (^)()) completion;

+(void) removePhoneFromCoreData:(Phone *) phone withCompletion:(void(^)()) completion;

@end
