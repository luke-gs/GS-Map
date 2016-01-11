//
//  GSMapCalloutView.m
//  GS Map
//
//  Created by Luke sammut on 8/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//

#import "GSMapCalloutView.h"

@implementation GSMapCalloutView

// Init the callout with a title and a subtitle
-(instancetype)initWithTitle:(NSString*) title subtitle:(NSString*) subtitle
{
    // Create a visual effect view that is applied to the callout
    UIVisualEffect *visualEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    self = [super initWithEffect:visualEffect];
    if(self)
    {
        [self setupViewWithTitle:title withSubtitle:subtitle];
    }
    return self;
}

#pragma  mark - Set up views

-(void) setupViewWithTitle:(NSString*) title withSubtitle:(NSString*) subtitle
{
    self.backgroundColor = [UIColor clearColor];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    // Set up the title label
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightThin];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:titleLabel];
    
    // Set up the subtitle label
    UILabel *subtitleLabel = [[UILabel alloc]init];
    subtitleLabel.text = subtitle;
    subtitleLabel.textColor = [UIColor whiteColor];
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    subtitleLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightThin];
    [subtitleLabel adjustsFontSizeToFitWidth];
    [self addSubview:subtitleLabel];
    
    // Set up the disclosure button
    UIImage *detailImage = [[UIImage imageNamed:@"chevron"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [detailButton setImage:detailImage forState:UIControlStateNormal];
    detailButton.translatesAutoresizingMaskIntoConstraints = NO;
    [detailButton addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:detailButton];
    
    //----------------------------------------------------
    //                     Constraints
    //----------------------------------------------------
    [NSLayoutConstraint activateConstraints:@[
    
        // Title label constraints
        [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:5],
        [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10],


        // Subtitle constraints
        [NSLayoutConstraint constraintWithItem:subtitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5],
        [NSLayoutConstraint constraintWithItem:subtitleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],

        // Detail button constraints
        [NSLayoutConstraint constraintWithItem:detailButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:subtitleLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:5],
        [NSLayoutConstraint constraintWithItem:detailButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
        [NSLayoutConstraint constraintWithItem:detailButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20],
        [NSLayoutConstraint constraintWithItem:detailButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20],

        // Callout View Constraints
        [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:detailButton attribute:NSLayoutAttributeRight multiplier:1.0 constant:10],
        [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:subtitleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5],
    ]];
    
}

-(void) buttonTapped
{
    self.action();
}

@end
