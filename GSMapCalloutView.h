//
//  GSMapCalloutView.h
//  GS Map
//
//  Created by Luke sammut on 8/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSMapCalloutView : UIVisualEffectView

// Init the callout view with a subtitle and a title
-(instancetype)initWithTitle:(NSString*) title subtitle:(NSString*) subtitle;

@property (nonatomic, copy) void (^action)();

@end
