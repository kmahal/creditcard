//
//  UIColor+VenmoColors.m
//  KMCardAdder
//
//  Created by Kabir Mahal on 1/13/15.
//  Copyright (c) 2015 KM. All rights reserved.
//

#import "UIColor+VenmoColors.h"

@implementation UIColor (VenmoColors)

+(UIColor *)venmoBlue{
    
    
    //found the official RGB value on http://brand.venmo.com/styleguide#section-logo-colors but R:61 G:149 B:206
    // did not look right when converted to UICOLOR and shown on the app, so for this app,
    // I have approximated a venmo blue color
    
    return [UIColor colorWithRed:63/155.0f green:120/155.0f blue:206/155.0f alpha:1.0];
}

@end
