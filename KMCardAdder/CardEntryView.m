//
//  CardEntryView.m
//  KMCardAdder
//
//  Created by Kabir Mahal on 1/13/15.
//  Copyright (c) 2015 KM. All rights reserved.
//

typedef enum {
    
    cardTypeUnknown = -1,
    cardTypeAmericanExpress = 1,
    cardTypeDiscover = 2,
    cardTypeJCL = 3,
    cardTypeMasterCard = 4,
    cardTypeVisa = 5
    
}CardType;

#import "CardEntryView.h"
#import "NSArray+Reverse.h"
#import "NSString+CardValidation.h"
#import "UIColor+VenmoColors.h"

@interface CardEntryView()

@property (strong, nonatomic) UITextField *cardNumberTextField;
@property (strong, nonatomic) UITextField *expirationDateTextField;
@property (strong, nonatomic) UITextField *cvvTextField;
@property (strong, nonatomic) UIImageView *creditCardImageView;
@property (nonatomic) CardType cardTypeStatus;

@property (strong, nonatomic) NSLayoutConstraint *constraint_tf1_initial;
@property (strong, nonatomic) NSLayoutConstraint *constraint_tf1_completed;


@property (strong, nonatomic) UIView *cardContainerView;

@property (strong, nonatomic) NSString *previousTextFieldContent;
@property (strong, nonatomic) UITextRange *previousSelection;


@end

@implementation CardEntryView




-(instancetype)init{
    
    self = [super init];
    
    if (self){
        
        _cardTypeStatus = cardTypeUnknown;
        self.backgroundColor = [UIColor whiteColor];

        [self setupCardImageView];
        [self setupSecondTF];
        [self setupThirdtf];
        [self setupFirstTF];
    }
    
    return self;
    
}



-(void)setupCardImageView{
    
    
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
    
}


-(void)textField1BecameActive:(UITextField*)textfield{
    
    
    if (textfield.text.length >0){
        [self closeCardNumberTextField:NO];
    }
    
}


-(void)setupFirstTF{
    
    _cardNumberTextField = [[UITextField alloc] init];
    _cardNumberTextField.placeholder = @"1234 5678 9760 2892";
    _cardNumberTextField.backgroundColor = [UIColor whiteColor];
    _cardNumberTextField.delegate = self;
    _cardNumberTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [_cardNumberTextField setKeyboardType:UIKeyboardTypeNumberPad];
    
    [self addSubview:_cardNumberTextField];
    
   // self.backgroundColor = [UIColor grayColor];
    
    _constraint_tf1_initial = [NSLayoutConstraint constraintWithItem:_cardNumberTextField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_cardContainerView attribute:NSLayoutAttributeRight multiplier:1.0f constant:20];
    
    NSLayoutConstraint *constraint_tf1_width = [NSLayoutConstraint constraintWithItem:_cardNumberTextField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.7f constant:0];
    
    NSLayoutConstraint *constraint_tf1_top = [NSLayoutConstraint constraintWithItem:_cardNumberTextField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:0.1f constant:0];
    
    NSLayoutConstraint *constraint_tf1_bottom = [NSLayoutConstraint constraintWithItem:_cardNumberTextField attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:0.9 constant:0];
    
     _constraint_tf1_completed = [NSLayoutConstraint constraintWithItem:_cardNumberTextField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_cardContainerView attribute:NSLayoutAttributeRight multiplier:1.0f constant:0];
    
    [self addConstraints:@[_constraint_tf1_initial, constraint_tf1_width, constraint_tf1_top, constraint_tf1_bottom]];
    
    [_cardNumberTextField addTarget:self
                    action:@selector(reformatAsCardNumber:)
          forControlEvents:UIControlEventEditingChanged];
    
    [_cardNumberTextField addTarget:self action:@selector(textField1BecameActive:) forControlEvents:UIControlEventEditingDidBegin];
    
    
}

-(void)setupSecondTF{
    
    _expirationDateTextField = [[UITextField alloc] init];
    _expirationDateTextField.placeholder = @"MM/YY";
    _expirationDateTextField.backgroundColor = [UIColor whiteColor];
    _expirationDateTextField.delegate = self;
    _expirationDateTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [_expirationDateTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [_expirationDateTextField setAlpha:0.0f];
    
    [self addSubview:_expirationDateTextField];
    
    //self.backgroundColor = [UIColor grayColor];
    
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
    
   // self.backgroundColor = [UIColor grayColor];
    
    NSLayoutConstraint *constraint_tf3_width = [NSLayoutConstraint constraintWithItem:_cvvTextField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.2f constant:0];
    
    NSLayoutConstraint *constraint_tf3_centerX = [NSLayoutConstraint constraintWithItem:_cvvTextField attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:0.8f constant:0];
    
    NSLayoutConstraint *constraint_tf3_top = [NSLayoutConstraint constraintWithItem:_cvvTextField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:0.1f constant:0];
    
    NSLayoutConstraint *constraint_tf3_bottom = [NSLayoutConstraint constraintWithItem:_cvvTextField attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:0.9 constant:0];
    
    [self addConstraints:@[constraint_tf3_width, constraint_tf3_centerX, constraint_tf3_top, constraint_tf3_bottom]];
    
}


-(UIImage*)imageForCardStatus{
    
    switch (_cardTypeStatus) {
        case cardTypeUnknown:
            return [UIImage imageNamed:@"GenericCard"];
            break;
        case cardTypeDiscover:
            return [UIImage imageNamed:@"Discover"];
            break;
        case cardTypeJCL:
            return [UIImage imageNamed:@"JCB"];
            break;
        case cardTypeMasterCard:
            return [UIImage imageNamed:@"Mastercard"];
            break;
        case cardTypeAmericanExpress:
            return [UIImage imageNamed:@"Amex"];
            break;
        case cardTypeVisa:
            return [UIImage imageNamed:@"Visa"];
            break;
        default:
            return [UIImage imageNamed:@"GenericCard"];
            break;
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
    
    if (_cardTypeStatus == cardTypeUnknown){
        if ([cardNumberWithoutSpaces length] > 6){
            [textField setText:_previousTextFieldContent];
            textField.selectedTextRange = _previousSelection;
            return;
        }
        
        cardNumberWithSpaces = cardNumberWithoutSpaces;
        
    } else if (_cardTypeStatus == cardTypeAmericanExpress){
        
        if ([cardNumberWithoutSpaces length] > 15){
            [textField setText:_previousTextFieldContent];
            textField.selectedTextRange = _previousSelection;
            
            textField.textColor = [textField.text doesPassLuhnAlgorithm] ? [UIColor blackColor] : [UIColor venmoRed];
            
            [self closeCardNumberTextField:YES];
            return;
        } else {
            textField.textColor = [UIColor blackColor];
        }
        
        cardNumberWithSpaces = [NSString insertSpacesAmexStyleForString:cardNumberWithoutSpaces andPreserveCursorPosition:&targetCursorPosition];

     
    } else {
        
        if ([cardNumberWithoutSpaces length] > 16){
            [textField setText:_previousTextFieldContent];
            textField.selectedTextRange = _previousSelection;
            
            textField.textColor = [textField.text doesPassLuhnAlgorithm] ? [UIColor blackColor] : [UIColor venmoRed];

            
            [self closeCardNumberTextField:YES];

            return;
        } else {
            textField.textColor = [UIColor blackColor];

        }
        
        cardNumberWithSpaces = [NSString insertSpacesEveryFourDigitsIntoString:cardNumberWithoutSpaces andPreserveCursorPosition:&targetCursorPosition];
       
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


-(void)closeCardNumberTextField:(BOOL)close{
    
    [self bringSubviewToFront:_cardContainerView];
    
    UITextPosition *Pos2 = [_cardNumberTextField positionFromPosition: _cardNumberTextField.endOfDocument offset: 0];
    UITextPosition *Pos1 = [_cardNumberTextField positionFromPosition: _cardNumberTextField.endOfDocument offset: -4];
    
    UITextRange *range = [_cardNumberTextField textRangeFromPosition:Pos1 toPosition:Pos2];
    
    CGRect result1 = [_cardNumberTextField firstRectForRange:(UITextRange *)range ];
    
    result1 = CGRectMake(result1.origin.x+_cardNumberTextField.frame.origin.x, result1.origin.y, result1.size.width, result1.size.height);
    
    int constant = result1.size.width + _cardNumberTextField.frame.size.width+_cardNumberTextField.frame.origin.x - result1.size.width - result1.origin.x;
    
    _constraint_tf1_completed.constant = constant;


    
    NSLayoutConstraint *constraintToRemove = close ? _constraint_tf1_initial : _constraint_tf1_completed;
    
    NSLayoutConstraint *constraintToAdd = close ? _constraint_tf1_completed : _constraint_tf1_initial;
    
    [self removeConstraint:constraintToRemove];
    

    
    //return;

    
    //_constraint_tf1_completed.constant = (_cardTypeStatus == cardTypeAmericanExpress) ? 85 : 65;
    
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


-(void)checkCardTypeForString:(NSString*)str{
    
    NSLog(@"str: %@", str);
    
    int ccValue = 0;
    
    switch (str.length) {
        case 1:
        {
            ccValue = [[NSString stringWithFormat:@"%c", [str characterAtIndex:0]] intValue];
            _cardTypeStatus = (ccValue == 4) ? cardTypeVisa : cardTypeUnknown;
        }
            break;
        case 2:
        {
            ccValue = [[str substringToIndex:2] intValue];
            
            if ((ccValue == 34) || (ccValue == 37)){
                _cardTypeStatus = cardTypeAmericanExpress;
            } else if ((NSLocationInRange([[str substringToIndex:2] intValue], NSMakeRange(51, (55-51))))){
                _cardTypeStatus = cardTypeMasterCard;
            } else if (ccValue == 65){
                _cardTypeStatus = cardTypeDiscover;
            }
            
        }
            break;
            
        case 3:
        {
            ccValue = [[str substringToIndex:3] intValue];
            
            _cardTypeStatus = (NSLocationInRange(ccValue, NSMakeRange(644, (649-644)))) ? cardTypeDiscover : _cardTypeStatus;
        }
            break;
            
        case 4:
        {
            ccValue = [[str substringToIndex:4] intValue];

            if ((NSLocationInRange(ccValue, NSMakeRange(3528, (3589-3528))))){
                _cardTypeStatus = cardTypeJCL;
            } else if (ccValue == 6011){
                _cardTypeStatus = cardTypeDiscover;
            }
            
        }
            
            break;
            
        case 6:
        {
            ccValue = [[str substringToIndex:6] intValue];
            
            if ((NSLocationInRange(ccValue, NSMakeRange(622126, (622925-622126))))){
                _cardTypeStatus = cardTypeDiscover;
            }
            break;
        }
        default:
            break;
    }
    
    _creditCardImageView.image = [self imageForCardStatus];

    
    
}


-(BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    // Note textField's current state before performing the change, in case
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
    }
    
    return YES;

    
}




@end
