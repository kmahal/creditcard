//
//  NSArray+Reverse.m
//  KMCardAdder
//
//  Created by Kabir Mahal on 1/14/15.
//  Copyright (c) 2015 KM. All rights reserved.
//

#import "NSArray+Reverse.h"

@implementation NSArray (Reverse)

- (NSArray *)reversedArray {
    
    NSArray *array = self.copy;

    return [[array reverseObjectEnumerator] allObjects];

}

@end
