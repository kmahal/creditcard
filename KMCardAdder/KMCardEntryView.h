//
//  CardEntryView.h
//  KMCardAdder
//
//  Created by Kabir Mahal on 1/13/15.
//  Copyright (c) 2015 KM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardIO.h"
#import "KMCardData.h"
#import "KMCardError.h"


typedef void (^KMCardDataResponseBlock)(KMCardData *cardData, KMCardError *error);


@interface KMCardEntryView : UIView <UITextFieldDelegate>

-(void)clearAllFields;
-(void)resignAllResponders;
-(void)insertCardIOData:(CardIOCreditCardInfo *)info;
-(void)getCurrentCardDataWithBlock:(KMCardDataResponseBlock)block;

@end
