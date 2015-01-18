//
//  KMCardEntryView_privateProperties.h
//  KMCardAdder
//
//  Created by Kabir Mahal on 1/17/15.
//  Copyright (c) 2015 KM. All rights reserved.
//

#import "KMCardEntryView.h"

@interface KMCardEntryView ()

@property (strong, nonatomic) UITextField *cardNumberTextField;
@property (strong, nonatomic) UITextField *expirationDateTextField;
@property (strong, nonatomic) UITextField *cvvTextField;
@property (strong, nonatomic) UIImageView *creditCardImageView;
@property (nonatomic) KMCardType cardTypeStatus;

@property (strong, nonatomic) NSLayoutConstraint *constraint_tf1_initial;
@property (strong, nonatomic) NSLayoutConstraint *constraint_tf1_completed;


@property (strong, nonatomic) UIView *cardContainerView;

@property (strong, nonatomic) NSString *previousTextFieldContent;
@property (strong, nonatomic) UITextRange *previousSelection;

@property (strong, nonatomic) KMCardData *cardData;

@property (nonatomic) int cvvLength;
@property (nonatomic) int maxCardLength;

@end
