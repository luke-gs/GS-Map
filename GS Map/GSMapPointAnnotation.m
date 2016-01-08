//
//  GSMapPointAnnotation.m
//  GS Map
//
//  Created by Luke sammut on 8/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//

#import "GSMapPointAnnotation.h"

@implementation GSMapPointAnnotation


-(instancetype)initWithCoordinate:(CLLocationCoordinate2D) coordinate
{
    self = [super init];
    if(self)
    {
        self.coordinate = coordinate;
    }
    return self;
}

-(NSString *)title
{
    return @"Phone";
}

@end
