//
//  PhoneDataUtility.m
//  GS Map
//
//  Created by Luke sammut on 10/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//

#import "PhoneDataUtility.h"
#import <MagicalRecord/MagicalRecord.h>

@implementation PhoneDataUtility

+(void) savePhoneToCoreData:(Phone*) phone withCompletionHandler: (void (^)(Phone* phone)) completion
{
   [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
       Phone *savedPhone = [Phone MR_createEntityInContext:localContext];
       savedPhone = [phone MR_inContext:localContext];
   } completion:^(BOOL contextDidSave, NSError *error) {
       if(contextDidSave)
       {
           NSLog(@"context did save");
           completion(phone);
       }
       
   }];
}

// Save the PFObject to core data
+(void) savePFObjectToCoreData:(PFObject *)phoneObject withCompletionHandler: (void (^)(Phone* phone)) completion
{
    __block NSManagedObjectID *idOfPhone;
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        Phone *phone = [Phone MR_createEntityInContext:localContext];
        phone = [PhoneDataUtility phoneFromPFObject:phoneObject fromPhone:phone];
        
        [localContext obtainPermanentIDsForObjects:@[phone] error:NULL];
        
        idOfPhone = phone.objectID;
        
    } completion:^(BOOL contextDidSave, NSError *error) {
        Phone *phone = (Phone*) [[NSManagedObjectContext MR_defaultContext] objectWithID:idOfPhone];
        if(completion)
        {
            completion(phone);
        }
    }];
}

+(void) updatePhoneWhenFound:(Phone*) phone forFoundBool:(BOOL) found withCompletion:(void (^)()) completion
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        Phone *phoneToChange = [phone MR_inContext:localContext];
        phoneToChange.found = @(found);
    } completion:^(BOOL contextDidSave, NSError *error) {
        if(contextDidSave)
        {
            if(completion)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion();
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


@end
