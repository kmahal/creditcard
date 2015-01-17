//
//  KMCardError.h
//  KMCardAdder
//
//  Created by Kabir Mahal on 1/16/15.
//  Copyright (c) 2015 KM. All rights reserved.
//

typedef enum {
    
    KMCardErrorNone = 0,
    KMCardErrorCard = 1,
    KMCardErrorDate = 2,
    KMCardErrorCVV = 3,
    KMCardErrorCardAndDate = 4,
    KMCardErrorDateAndCVV = 5,
    KMCardErrorAll = 6
    
} KMErrorType;

#import <Foundation/Foundation.h>



@interface KMCardError : NSObject

@property (nonatomic) KMErrorType errorType;


@end
