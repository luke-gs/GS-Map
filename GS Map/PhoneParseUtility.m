//
//  PhoneParseUtility.m
//  GS Map
//
//  Created by Luke sammut on 11/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//

#import "PhoneParseUtility.h"

@implementation PhoneParseUtility

// Saves a PFObject to Parse given a PFObject
+(void) savePhoneInParse:(PFObject *) phoneObject withCompletion:(void (^)(PFObject *phone)) completion
{
    [phoneObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded)
        {
            NSLog(@"%@ has been saved", phoneObject);
            if(completion)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(phoneObject);
                });
            }
        }
    }];
}

// Updates the Phone object in parse when the user changes the value of the phones found value
+(void) updatePhoneForFound:(Phone*) phone withFound:(BOOL) found withCompletion:(void (^)()) completion
{
    PFQuery *query = [PFQuery queryWithClassName:@"Phone"];
    [query getObjectInBackgroundWithId:phone.code block:^(PFObject * _Nullable phoneObject, NSError * _Nullable error) {
        
        // Whether the phone has been found or not
        phoneObject[@"found"] = @(found);
        
        [phoneObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded)
            {
                if(completion)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion();
                    });
                }
            }
            else
            {
                NSLog(@"%@", error.description);
            }
        }];
    }];
}

// Remove the given phone from the Parse Database
+(void) removePhoneFromParseData:(Phone*) phone withCompletion:(void(^)()) completion
{
    PFQuery *query = [PFQuery queryWithClassName:@"Phone"];
    
    // If the phone passed in is valid
    if(phone)
    {
        [query getObjectInBackgroundWithId:phone.code block:^(PFObject * _Nullable phoneObject, NSError * _Nullable error) {
            [phoneObject deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
            {
                if(succeeded)
                {
                    if(completion)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion();
                        });
                    }
                }
            }];
        }];
    }
}

@end
