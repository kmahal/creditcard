//
//  KMCardData.h
//  KMCardAdder
//
//  Created by Kabir Mahal on 1/15/15.
//  Copyright (c) 2015 KM. All rights reserved.
//

typedef enum {
    
    KMCardTypeUnknown = -1,
    KMCardTypeAmericanExpress = 1,
    KMCardTypeDiscover = 2,
    KMCardTypeJCB = 3,
    KMCardTypeMasterCard = 4,
    KMCardTypeVisa = 5
    
} KMCardType;




#import <Foundation/Foundation.h>

@interface KMCardData : NSObject

@property(nonatomic, assign) KMCardType cardType;

@property (nonatomic, copy) NSString *cardNumber;

@property (nonatomic) int expirationMonth;

@property (nonatomic) int expirationYear;

@property (nonatomic, copy) NSString *cvv;




@end
