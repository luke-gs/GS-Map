//
//  Phone+CoreDataProperties.h
//  GS Map
//
//  Created by Luke sammut on 11/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Phone.h"

NS_ASSUME_NONNULL_BEGIN

@interface Phone (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSString *code;
@property (nullable, nonatomic, retain) NSNumber *found;
@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;

@end

NS_ASSUME_NONNULL_END
