//
//  CardEntryView.m
//  KMCardAdder
//
//  Created by Kabir Mahal on 1/13/15.
//  Copyright (c) 2015 KM. All rights reserved.
//


#import "KMCardEntryView.h"
#import "NSArray+Reverse.h"
#import "NSString+CardValidation.h"
#import "UIColor+VenmoColors.h"
#import "cardIO.h"
#import "KMCardData.h"
#import "KMCardEntryView_privateProperties.h"



@implementation KMCardEntryView



-(instancetype)init{
    
    self = [super init];
    
    if (self){
        
        
        self.cardTypeStatus = KMCardTypeUnknown;
        self.backgroundColor = [UIColor whiteColor];

        [self setupCardImageView];
        [self setupSecondTF];
        [self setupThirdtf];
        [self setupFirstTF];
    }
    
    return self;
    
}


#pragma mark setup methods



-(void)setupCardImageView{
    
    _cardData = [[KMCardData alloc] init];
    
    _cvvLength = 3;
    _maxCardLength = 6;
    
    [self addObserver:self forKeyPath:@"self.cardTypeStatus" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];

    
    //setting up the container view that will have the card image view
    
    _cardContainerView = [[UIView alloc] init];

    _cardContainerView.backgroundColor = [UIColor whiteColor];
    _cardContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:_cardContainerView];
    
    NSArray *constraint_cv_array1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[cv]" options:0 metrics:nil views:@{@"cv": _cardContainerView}];
    NSArray *constraint_cv_array2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[cv]" options:0 metrics:nil views:@{@"cv": _cardContainerView}];
    
    NSLayoutConstraint *constraint_cv_height = [NSLayoutConstraint constraintWithItem:_cardContainerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0];
    
    NSLayoutConstraint *constraint_cv_width = [NSLayoutConstraint constraintWithItem:_cardContainerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.1f constant:0];
    
    
    [self addConstraints:@[constraint_cv_height, constraint_cv_width]];
    [self addConstraints:constraint_cv_array1];
    [self addConstraints:constraint_cv_array2];
    
    
    //setting up the credit card image view
    
    _creditCardImageView = [[UIImageView alloc] init];
    _creditCardImageView.image = [self imageForCardStatus];
    _creditCardImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_cardContainerView addSubview:_creditCardImageView];
    
    NSLayoutConstraint *constraint_cc_height = [NSLayoutConstraint constraintWithItem:_creditCardImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:_creditCardImageView.image.size.height];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:_creditCardImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:0.0f constant:_creditCardImageView.image.size.width];
    
    NSLayoutConstraint *constraint5 = [NSLayoutConstraint constraintWithItem:_creditCardImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_cardContainerView attribute:NSLayoutAttributeRight multiplier:0.5f constant:0];
    
    NSLayoutConstraint *constraint6 = [NSLayoutConstraint constraintWithItem:_creditCardImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_cardContainerView attribute:NSLayoutAttributeBottom multiplier:0.5f constant:0];
    
    [_cardContainerView addConstraints:@[constraint_cc_height, constraint4]];
    
    [_cardContainerView addConstraints:@[constraint5, constraint6]];
    
     self.cardTypeStatus = KMCardTypeUnknown;
    
}




-(void)setupFirstTF{
    
    //setting up the credit card number text field
    
    _cardNumberTextField = [[UITextField alloc] init];
    _cardNumberTextField.placeholder = @"1234 5678 9760 2892";
    _cardNumberTextField.backgroundColor = [UIColor whiteColor];
    _cardNumberTextField.delegate = self;
    _cardNumberTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [_cardNumberTextField setKeyboardType:UIKeyboardTypeNumberPad];
    
    [self addSubview:_cardNumberTextField];
    
    
    _constraint_tf1_initial = [NSLayoutConstraint constraintWithItem:_cardNumberTextField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_cardContainerView attribute:NSLayoutAttributeRight multiplier:1.0f constant:20];
    
    NSLayoutConstraint *constraint_tf1_width = [NSLayoutConstraint constraintWithItem:_cardNumberTextField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.58f constant:0];
    
    NSLayoutConstraint *constraint_tf1_top = [NSLayoutConstraint constraintWithItem:_cardNumberTextField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:0.1f constant:0];
    
    NSLayoutConstraint *constraint_tf1_bottom = [NSLayoutConstraint constraintWithItem:_cardNumberTextField attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:0.9 constant:0];
    
    _constraint_tf1_completed = [NSLayoutConstraint constraintWithItem:_cardNumberTextField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_cardContainerView attribute:NSLayoutAttributeRight multiplier:1.0f constant:0];
    
    [self addConstraints:@[_constraint_tf1_initial, constraint_tf1_width, constraint_tf1_top, constraint_tf1_bottom]];
    
    [_cardNumberTextField addTarget:self
                             action:@selector(reformatAsCardNumber:)
                   forControlEvents:UIControlEventEditingChanged];
    
    [_cardNumberTextField addTarget:self action:@selector(textFieldBeganEditing:) forControlEvents:UIControlEventEditingDidBegin];
    
    
}

-(void)setupSecondTF{
    
    //setting up the expiration date text field
    
    _expirationDateTextField = [[UITextField alloc] init];
    _expirationDateTextField.placeholder = @"MM/YY";
    _expirationDateTextField.backgroundColor = [UIColor whiteColor];
    _expirationDateTextField.delegate = self;
    _expirationDateTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [_expirationDateTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [_expirationDateTextField setAlpha:0.0f];
    
    [self addSubview:_expirationDateTextField];
    
    NSLayoutConstraint *constraint_tf2_width = [NSLayoutConstraint constraintWithItem:_expirationDateTextField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.2f constant:0];
    
    NSLayoutConstraint *constraint_tf2_centerX = [NSLayoutConstraint constraintWithItem:_expirationDateTextField attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:0.5f constant:0];
    
    NSLayoutConstraint *constraint_tf2_top = [NSLayoutConstraint constraintWithItem:_expirationDateTextField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:0.1f constant:0];
    
    NSLayoutConstraint *constraint_tf2_bottom = [NSLayoutConstraint constraintWithItem:_expirationDateTextField attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:0.9 constant:0];
    
    [self addConstraints:@[constraint_tf2_width, constraint_tf2_centerX, constraint_tf2_top, constraint_tf2_bottom]];
    
}


-(void)setupThirdtf{
    
    _cvvTextField = [[UITextField alloc] init];
    _cvvTextField.placeholder = @"CVV";
    _cvvTextField.backgroundColor = [UIColor whiteColor];
    _cvvTextField.delegate = self;
    _cvvTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [_cvvTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [_cvvTextField setAlpha:0.0f];
    
    [self addSubview:_cvvTextField];
    
    NSLayoutConstraint *constraint_tf3_width = [NSLayoutConstraint constraintWithItem:_cvvTextField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.2f constant:0];
    
    NSLayoutConstraint *constraint_tf3_centerX = [NSLayoutConstraint constraintWithItem:_cvvTextField attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:0.8f constant:0];
    
    NSLayoutConstraint *constraint_tf3_top = [NSLayoutConstraint constraintWithItem:_cvvTextField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:0.1f constant:0];
    
    NSLayoutConstraint *constraint_tf3_bottom = [NSLayoutConstraint constraintWithItem:_cvvTextField attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:0.9 constant:0];
    
    [self addConstraints:@[constraint_tf3_width, constraint_tf3_centerX, constraint_tf3_top, constraint_tf3_bottom]];
    
    [_cvvTextField addTarget:self action:@selector(textFieldBeganEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [_cvvTextField addTarget:self action:@selector(textFieldEndedEditing:) forControlEvents:UIControlEventEditingDidEnd];
    
}




#pragma mark textfield control events selectors

-(void)textFieldBeganEditing:(UITextField*)textfield{
    
    // if someone taps into the card text field, we want it to open that view for editing.  length check determines if it's already open or not on initial state
    // or if editing month or CVV and going back into the view.
    
    if (textfield == _cardNumberTextField){
        if (textfield.text.length >0){
            [self closeCardNumberTextField:NO];
        }
    } else if (textfield == _cvvTextField){
        _creditCardImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",((self.cardTypeStatus == KMCardTypeAmericanExpress) ? @"AmexCVV" : @"CVV")]];
    }

    
}

-(void)textFieldEndedEditing:(UITextField*)textfield{
    
    if (textfield == _cvvTextField){
        _creditCardImageView.image = [self imageForCardStatus];
    }
    
    
}


-(void)reformatAsCardNumber:(UITextField *)textField
{
    // In order to make the cursor end up positioned correctly, we need to
    // explicitly reposition it after we inject spaces into the text.
    // targetCursorPosition keeps track of where the cursor needs to end up as
    // we modify the string, and at the end we set the cursor position to it.
    NSUInteger targetCursorPosition =
    [textField offsetFromPosition:textField.beginningOfDocument
                       toPosition:textField.selectedTextRange.start];
    
    NSString *cardNumberWithoutSpaces = [NSString removeNonDigits:textField.text andPreserveCursorPosition:&targetCursorPosition];
    
    [self checkCardTypeForString:cardNumberWithoutSpaces];
    
    NSString *cardNumberWithSpaces = nil;
    
    
    if ([cardNumberWithoutSpaces length] >= _maxCardLength){
        
        if ([cardNumberWithoutSpaces length] > _maxCardLength){
            [textField setText:_previousTextFieldContent];
            textField.selectedTextRange = _previousSelection;
        }
        
        
        if (!(self.cardTypeStatus == KMCardTypeUnknown)) {
            
            textField.textColor = [[NSString removeNonDigits:textField.text] doesPassLuhnAlgorithm] ? [UIColor blackColor] : [UIColor venmoRed];
            
            [self closeCardNumberTextField:YES];
        }
        
        return;
        
        
        
    } else {
        
        textField.textColor = [UIColor blackColor];
        
        switch (self.cardTypeStatus) {
            case KMCardTypeAmericanExpress:
                cardNumberWithSpaces = [NSString insertSpacesAmexStyleForString:cardNumberWithoutSpaces andPreserveCursorPosition:&targetCursorPosition];
                break;
            case KMCardTypeUnknown:
                cardNumberWithSpaces = cardNumberWithoutSpaces;
                break;
            default:
                cardNumberWithSpaces = [NSString insertSpacesEveryFourDigitsIntoString:cardNumberWithoutSpaces andPreserveCursorPosition:&targetCursorPosition];
                break;
        }
        
    }
    
    textField.text = cardNumberWithSpaces;
    UITextPosition *targetPosition =
    [textField positionFromPosition:[textField beginningOfDocument]
                             offset:targetCursorPosition];
    
    [textField setSelectedTextRange:
     [textField textRangeFromPosition:targetPosition
                           toPosition:targetPosition]
     ];
}



-(void)checkCardTypeForString:(NSString*)str{
    
    NSLog(@"str: %@", str);
    
    int ccValue = [[str substringToIndex:str.length] intValue];
    
    switch (str.length) {
        case 1:
        {
            self.cardTypeStatus = (ccValue == 4) ? KMCardTypeVisa : KMCardTypeUnknown;
        }
            break;
        case 2:
        {
            
            if ((ccValue == 34) || (ccValue == 37)){
                self.cardTypeStatus = KMCardTypeAmericanExpress;
            } else if ((NSLocationInRange([[str substringToIndex:2] intValue], NSMakeRange(51, (55-51))))){
                self.cardTypeStatus = KMCardTypeMasterCard;
            } else if (ccValue == 65){
                self.cardTypeStatus = KMCardTypeDiscover;
            }
            
        }
            break;
            
        case 3:
        {
            self.cardTypeStatus = (NSLocationInRange(ccValue, NSMakeRange(644, (649-644)))) ? KMCardTypeDiscover : self.cardTypeStatus;
        }
            break;
            
        case 4:
        {
            
            if ((NSLocationInRange(ccValue, NSMakeRange(3528, (3589-3528))))){
                self.cardTypeStatus = KMCardTypeJCB;
            } else if (ccValue == 6011){
                self.cardTypeStatus = KMCardTypeDiscover;
            }
            
        }
            
            break;
            
        case 6:
        {
            
            if ((NSLocationInRange(ccValue, NSMakeRange(622126, (622925-622126))))){
                self.cardTypeStatus = KMCardTypeDiscover;
            }
            break;
        }
        default:
            break;
    }
    
    
}



#pragma mark KVO image for card status


-(UIImage*)imageForCardStatus{
    
    switch (self.cardTypeStatus) {
        case KMCardTypeUnknown:
            return [UIImage imageNamed:@"GenericCard"];
            break;
        case KMCardTypeDiscover:
            return [UIImage imageNamed:@"Discover"];
            break;
        case KMCardTypeJCB:
            return [UIImage imageNamed:@"JCB"];
            break;
        case KMCardTypeMasterCard:
            return [UIImage imageNamed:@"Mastercard"];
            break;
        case KMCardTypeAmericanExpress:
            return [UIImage imageNamed:@"Amex"];
            break;
        case KMCardTypeVisa:
            return [UIImage imageNamed:@"Visa"];
            break;
        default:
            return [UIImage imageNamed:@"GenericCard"];
            break;
    }
    
    
}




-(void)closeCardNumberTextField:(BOOL)close{
    
    //if close is true, then we want to move the text field to the left and expose the CVV and expiration date text fields
    // if close is false we want to hide cvv and expiration date text fields and show the card entry field
    
    [self bringSubviewToFront:_cardContainerView];
    
    if (close){
        
        NSInteger offset = (self.cardTypeStatus == KMCardTypeAmericanExpress) ? -5 : -4;
        
        UITextPosition *Pos2 = [_cardNumberTextField positionFromPosition: _cardNumberTextField.endOfDocument offset: 0];
        UITextPosition *Pos1 = [_cardNumberTextField positionFromPosition: _cardNumberTextField.endOfDocument offset: offset];
        
        UITextRange *range = [_cardNumberTextField textRangeFromPosition:Pos1 toPosition:Pos2];
        
        CGRect result1 = [_cardNumberTextField firstRectForRange:(UITextRange *)range ];
        
        result1 = CGRectMake(result1.origin.x+_cardNumberTextField.frame.origin.x, result1.origin.y, result1.size.width, result1.size.height);
        
        //calculates the length of the last 4 or 5 card digits and the length from the end to the end of the textfield
        int constant =  _cardNumberTextField.frame.size.width+_cardNumberTextField.frame.origin.x - result1.origin.x;
        
        _constraint_tf1_completed.constant = constant;
        
    }

    
    NSLayoutConstraint *constraintToRemove = close ? _constraint_tf1_initial : _constraint_tf1_completed;
    
    NSLayoutConstraint *constraintToAdd = close ? _constraint_tf1_completed : _constraint_tf1_initial;
    
    [self removeConstraint:constraintToRemove];

    
    [self addConstraint:constraintToAdd];
    
    float value = close ? 1.0f : 0.0f;
    
    [UIView animateWithDuration:0.5f animations:^{
        [self layoutIfNeeded];
        _expirationDateTextField.alpha = value;
        _cvvTextField.alpha = value;
        
    } completion:^(BOOL finished) {
        UITextField *responder = close ? _expirationDateTextField : _cardNumberTextField;
        [responder becomeFirstResponder];
    }];
    
    
}


#pragma mark textfield delegate methods


-(BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    // Note card number's current state before performing the change, in case
    // reformatTextField wants to revert it
    
    if (textField == _cardNumberTextField){
        _previousTextFieldContent = textField.text;
        _previousSelection = textField.selectedTextRange;
        
    } else if (textField == _expirationDateTextField){
        NSString *filter = @"##/##";
        
        if(!filter) return YES; // No filter provided, allow anything
        
        NSString *changedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if(range.length == 1 && // Only do for single deletes
           string.length < range.length &&
           [[textField.text substringWithRange:range] rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]].location == NSNotFound)
        {
            // Something was deleted.  Delete past the previous number
            NSInteger location = changedString.length-1;
            if(location > 0)
            {
                for(; location > 0; location--)
                {
                    if(isdigit([changedString characterAtIndex:location]))
                    {
                        break;
                    }
                }
                changedString = [changedString substringToIndex:location];
            }
        }
        
        
        textField.text = [NSString filteredDateStringFromString:changedString WithFilter:filter];
        
        if (textField.text.length == filter.length) [_cvvTextField becomeFirstResponder];
        
        return NO;
        
    } else if (textField == _cvvTextField){
        
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= ((self.cardTypeStatus == KMCardTypeAmericanExpress) ? 4 : 3) || returnKey;
    }
    
    return YES;

    
}



#pragma mark KVO operations

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    
    NSLog(@"change: %@", change);
    

    if ([keyPath isEqualToString:@"self.cardTypeStatus"]){
        _cvvLength = ([[change objectForKey:@"new"] intValue] == KMCardTypeAmericanExpress ) ? 4 : 3;
        
        if (self.cardTypeStatus == KMCardTypeUnknown){
            _maxCardLength = 6;
        } else {
            _maxCardLength = (self.cardTypeStatus == KMCardTypeAmericanExpress) ? 15 : 16;
        }
        
        _creditCardImageView.image = [self imageForCardStatus];
        
    }
    
}


#pragma mark public methods

-(void)getCurrentCardDataWithBlock:(KMCardDataResponseBlock)block{
    
    int errorCount = 0;
    
    BOOL cardValue = (([NSString removeNonDigits:_cardNumberTextField.text].length == _maxCardLength) && [[NSString removeNonDigits:_cardNumberTextField.text] doesPassLuhnAlgorithm]);
    
    BOOL dateValue = (_expirationDateTextField.text.length == 5);
    
    BOOL cvvValue = (_cvvTextField.text.length == _cvvLength);
    
    
    if (cardValue) {
        _cardData.cardNumber = [NSString removeNonDigits:_cardNumberTextField.text];
        _cardData.redactedCardNumber = (self.cardTypeStatus == KMCardTypeAmericanExpress) ? [NSString redactedAmexCardInfo:_cardNumberTextField.text] : [NSString redactedCardInfo:_cardNumberTextField.text];
    } else {
        errorCount += 1;
    }
    if (dateValue){
        _cardData.expirationMonth = [[_expirationDateTextField.text substringToIndex:2] intValue];
        _cardData.expirationYear = [[_expirationDateTextField.text substringFromIndex:3] intValue];
    } else {
        errorCount +=2;
    }
    if (cvvValue){
        _cardData.cvv = _cvvTextField.text;
    } else {
        errorCount += 3;
    }
    
    _cardData.cardType = self.cardTypeStatus;

    
    if (errorCount == 0) {
        block(_cardData, nil);
        return;
    }
    
    
    KMCardError *error = [[KMCardError alloc] init];
    error.errorType = errorCount;
    
    block(_cardData, error);

    
}


-(void)resignAllResponders{
    [_cardNumberTextField resignFirstResponder];
    [_expirationDateTextField resignFirstResponder];
    [_cvvTextField resignFirstResponder];
    
    
}

-(void)clearAllFields{
    _cardNumberTextField.text = @"";
    _expirationDateTextField.text = @"";
    _cvvTextField.text = @"";
    self.cardTypeStatus = KMCardTypeUnknown;
    _creditCardImageView.image = [self imageForCardStatus];
    
    [self closeCardNumberTextField:NO];
}



-(void)insertCardIOData:(CardIOCreditCardInfo *)info{
    
    
    switch (info.cardType) {
        case CardIOCreditCardTypeAmex:
            self.cardTypeStatus = KMCardTypeAmericanExpress;
            break;
        case CardIOCreditCardTypeDiscover:
            self.cardTypeStatus = KMCardTypeDiscover;
            break;
        case CardIOCreditCardTypeJCB:
            self.cardTypeStatus = KMCardTypeJCB;
            break;
        case CardIOCreditCardTypeVisa:
            self.cardTypeStatus = KMCardTypeVisa;
            break;
        case CardIOCreditCardTypeMastercard:
            self.cardTypeStatus = KMCardTypeMasterCard;
        default:
            self.cardTypeStatus = KMCardTypeUnknown;
            break;
    }
    
    _cardNumberTextField.text = (self.cardTypeStatus == KMCardTypeAmericanExpress) ? [NSString insertSpacesAmexStyleForString:info.cardNumber] : [NSString insertSpacesEveryFourDigitsIntoString:info.cardNumber];
    
    _cardNumberTextField.textColor = [[NSString removeNonDigits:_cardNumberTextField.text] doesPassLuhnAlgorithm] ? [UIColor blackColor] : [UIColor venmoRed];
    
    [_cardNumberTextField becomeFirstResponder];
    
    [self closeCardNumberTextField:YES];
    
}





@end
