//
//  UIImage+BlurredView.h
//  KMCardAdder
//
//  Created by Kabir Mahal on 1/13/15.
//  Copyright (c) 2015 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BlurredView)

- (UIImage *)blurredImageWithRadius:(CGFloat)radius
                         iterations:(NSUInteger)iterations
                          tintColor:(UIColor *)tintColor;

@end
