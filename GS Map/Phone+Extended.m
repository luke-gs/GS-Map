//
//  Phone+Extended.m
//  GS Map
//
//  Created by Luke sammut on 11/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//

#import "Phone+Extended.h"

@implementation Phone (Extended)

-(NSString *)title
{
    NSString *title = [self primitiveValueForKey:@"code"];
    return title;
}

-(NSString *)subtitle
{
    NSString *subtitle = [self primitiveValueForKey:@"address"];
    return  subtitle;
}

-(CLLocationCoordinate2D) coordinate
{
    CLLocationDegrees latitude = [[self primitiveValueForKey:@"latitude"] doubleValue];
    CLLocationDegrees longitude = [[self primitiveValueForKey:@"longitude"] doubleValue];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    return coordinate;
}

-(UIColor*) pinColor
{
    if([self.found isEqualToNumber:[NSNumber numberWithBool:NO]])
    {
        return [UIColor redColor];
    }
    else
    {
        return [UIColor greenColor];
    }
}

@end
