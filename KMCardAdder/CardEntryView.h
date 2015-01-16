//
//  CardEntryView.h
//  KMCardAdder
//
//  Created by Kabir Mahal on 1/13/15.
//  Copyright (c) 2015 KM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardIO.h"


@interface CardEntryView : UIView <UITextFieldDelegate>

-(void)clearAllFields;
-(void)resignAllResponders;

-(void)insertCardIOData:(CardIOCreditCardInfo *)info;



@end
