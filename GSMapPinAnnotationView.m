//
//  GSMapPinAnnotationView.m
//  GS Map
//
//  Created by Luke sammut on 8/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//

#import "GSMapPinAnnotationView.h"
#import "GSMapCalloutView.h"

@interface GSMapPinAnnotationView()

@property (strong,nonatomic) GSMapCalloutView *callout;

@end

@implementation GSMapPinAnnotationView

// Passes in the annotation and reUse identifier
-(instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.callout = [[GSMapCalloutView alloc]initWithTitle:self.annotation.title subtitle:self.annotation.subtitle];
        self.callout.layer.cornerRadius = 5;
        self.callout.clipsToBounds = YES;
        self.callout.alpha = 0;
    }
    return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if(selected)
    {
        [self addSubview:self.callout];
        
        [UIView animateWithDuration:.5 animations:^{
            self.callout.alpha = 1;
        }];
        
        //----------------------------------------------------
        //                     Constraints
        //----------------------------------------------------
        
        [NSLayoutConstraint activateConstraints:@[

        [NSLayoutConstraint constraintWithItem:self.callout attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
        [NSLayoutConstraint constraintWithItem:self.callout attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-50],
        ]];
        
    }
    else{
        [UIView animateWithDuration:0.5 animations:^{
            self.callout.alpha = 0;
        } completion:^(BOOL finished) {
            [self.callout removeFromSuperview];
        }];
    }
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView* hitView = [super hitTest:point withEvent:event];
    if (hitView != nil)
    {
        [self.superview bringSubviewToFront:self];
    }
    return hitView;
}

// If the point is inside when the user clicks onto the button
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    if(!isInside)
    {
        for (UIView *view in self.subviews)
        {
            isInside = CGRectContainsPoint(view.frame, point);
            if(isInside)
                break;
        }
    }
    return isInside;
}

-(void) addCalloutAction :(void(^) ()) tappedAction {
    self.callout.action = tappedAction;
}

@end
