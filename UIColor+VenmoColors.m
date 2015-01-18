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
    
    
    return [UIColor colorWithHexString:@"#3D95CE"];
    
}

+(UIColor*)venmoGray{
    
    return [UIColor colorWithHexString:@"#E7EBEE"];
}


+(UIColor*)venmoRed{
    
    return [UIColor colorWithHexString:@"#FF999A"];
}


+(UIColor*)venmoGreen{
    
    return [UIColor colorWithHexString:@"#267E1A"];
    
}

+ (UIColor *)colorWithHexString:(NSString *)str {
    const char *cStr = [str cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    return [UIColor colorWithHex:x];
}



+ (UIColor *)colorWithHex:(long)col {
    unsigned char r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
}

@end
