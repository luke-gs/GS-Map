//
//  PhoneParseUtility.m
//  GS Map
//
//  Created by Luke sammut on 11/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//

#import "PhoneParseUtility.h"

@implementation PhoneParseUtility


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

+(Phone*) phoneFromPFObject:(PFObject*)phoneObject fromPhone:(Phone*) phone
{
	if([phoneObject objectId])
    {
        phone.code = [phoneObject objectId];
    }
    
    phone.address = phoneObject[@"address"];
    phone.longitude = phoneObject[@"longitude"];
    phone.latitude = phoneObject[@"latitude"];
    phone.found = phoneObject[@"found"];
    
    return phone;
}

+(void) updatePhoneForFound:(Phone*) phone withFound:(BOOL) found withCompletion:(void (^)()) completion
{
    PFQuery *query = [PFQuery queryWithClassName:@"Phone"];
    [query getObjectInBackgroundWithId:phone.code block:^(PFObject * _Nullable phoneObject, NSError * _Nullable error) {
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

@end
