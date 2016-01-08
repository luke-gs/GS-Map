//
//  GSMapPinAnnotationView.h
//  GS Map
//
//  Created by Luke sammut on 8/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface GSMapPinAnnotationView : MKPinAnnotationView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event;

-(void) addCalloutAction :(void(^) ()) tappedAction;

@end
