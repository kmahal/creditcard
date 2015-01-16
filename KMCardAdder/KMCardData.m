//
//  KMCardData.m
//  KMCardAdder
//
//  Created by Kabir Mahal on 1/15/15.
//  Copyright (c) 2015 KM. All rights reserved.
//

#import "KMCardData.h"

@implementation KMCardData

-(instancetype)init{
    
    self = [super init];
    
    return self;
    
}


-(void)setCardType:(KMCardType)cardType{
    _cardType = cardType;
}

@end
