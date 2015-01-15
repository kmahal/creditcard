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

@interface CardEntryView()

@property (strong, nonatomic) UITextField *textField1;
@property (strong, nonatomic) UITextField *textField2;
@property (strong, nonatomic) UITextField *textField3;
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
        [self initialSetup];
    }
    
    return self;
    
}



-(void)initialSetup{
    
    _cardTypeStatus = cardTypeUnknown;
    
    _cardContainerView = [[UIView alloc] init];
    [_cardContainerView setBackgroundColor:[UIColor redColor]];
    _cardContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:_cardContainerView];
    
    NSArray *array1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[cv]" options:0 metrics:nil views:@{@"cv": _cardContainerView}];
    
    NSArray *array2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[cv]" options:0 metrics:nil views:@{@"cv": _cardContainerView}];
    
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:_cardContainerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0];
    
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:_cardContainerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.1f constant:0];
    
    
    [self addConstraints:@[constraint1, constraint2]];
    [self addConstraints:array1];
    [self addConstraints:array2];
    
    _creditCardImageView = [[UIImageView alloc] init];
    _creditCardImageView.image = [self imageForCardStatus];
    _creditCardImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_cardContainerView addSubview:_creditCardImageView];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:_creditCardImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:_creditCardImageView.image.size.height];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:_creditCardImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:0.0f constant:_creditCardImageView.image.size.width];
    
    NSLayoutConstraint *constraint5 = [NSLayoutConstraint constraintWithItem:_creditCardImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_cardContainerView attribute:NSLayoutAttributeRight multiplier:0.5f constant:0];
    
    NSLayoutConstraint *constraint6 = [NSLayoutConstraint constraintWithItem:_creditCardImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_cardContainerView attribute:NSLayoutAttributeBottom multiplier:0.5f constant:0];
    
    [_cardContainerView addConstraints:@[constraint3, constraint4]];
    
    [_cardContainerView addConstraints:@[constraint5, constraint6]];
    
    
    [self setupSecondTF];
    _textField2.alpha = 0.0f;
    
    [self setupThirdtf];
    
    _textField3.alpha = 0.0f;
    
    [self setupTextField1WithContainerView:_cardContainerView];
    
    
    
}


-(void)textField1BecameActive:(UITextField*)textfield{
    
    NSLog(@"hit notification");
    
    if (textfield.text.length >0){
        [self animateTextField1Closed:NO];
    }
    
}


-(void)setupTextField1WithContainerView:(UIView*)containerView1{
    
    _textField1 = [[UITextField alloc] init];
    
    _textField1.placeholder = @"1234 5678 9760 2892";
    _textField1.backgroundColor = [UIColor whiteColor];
    _textField1.delegate = self;
    
    _textField1.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_textField1 setKeyboardType:UIKeyboardTypeNumberPad];
    
    
    [self addSubview:_textField1];
    
    self.backgroundColor = [UIColor grayColor];
    
    _constraint_tf1_initial = [NSLayoutConstraint constraintWithItem:_textField1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:containerView1 attribute:NSLayoutAttributeRight multiplier:1.0f constant:20];
    
    NSLayoutConstraint *constraint4tf = [NSLayoutConstraint constraintWithItem:_textField1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.5f constant:0];
    
    NSLayoutConstraint *constraint2tf = [NSLayoutConstraint constraintWithItem:_textField1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:0.1f constant:0];
    
    NSLayoutConstraint *constraint3tf = [NSLayoutConstraint constraintWithItem:_textField1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:0.9 constant:0];
    
     _constraint_tf1_completed = [NSLayoutConstraint constraintWithItem:_textField1 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_cardContainerView attribute:NSLayoutAttributeRight multiplier:1.0f constant:60];
    
    [self addConstraint:_constraint_tf1_initial];
    [self addConstraint:constraint4tf];
    [self addConstraint:constraint2tf];
    [self addConstraint:constraint3tf];
    
    [_textField1 addTarget:self
                    action:@selector(reformatAsCardNumber:)
          forControlEvents:UIControlEventEditingChanged];
    
    [_textField1 addTarget:self action:@selector(textField1BecameActive:) forControlEvents:UIControlEventEditingDidBegin];
    
    
}

-(void)setupSecondTF{
    
    [_textField1 setAlpha:0.0f];
    
    _textField2 = [[UITextField alloc] init];
    
    _textField2.placeholder = @"MM/YY";
    _textField2.backgroundColor = [UIColor whiteColor];
    _textField2.delegate = self;
    
    _textField2.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_textField2 setKeyboardType:UIKeyboardTypeNumberPad];
    
    
    [self addSubview:_textField2];
    
    self.backgroundColor = [UIColor grayColor];
    
    NSLayoutConstraint *constraint1tf = [NSLayoutConstraint constraintWithItem:_textField2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.2f constant:0];
    
    
    NSLayoutConstraint *constraint4tf = [NSLayoutConstraint constraintWithItem:_textField2 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:0.5f constant:0];
    
    NSLayoutConstraint *constraint2tf = [NSLayoutConstraint constraintWithItem:_textField2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:0.1f constant:0];
    
    NSLayoutConstraint *constraint3tf = [NSLayoutConstraint constraintWithItem:_textField2 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:0.9 constant:0];
    
    [self addConstraint:constraint1tf];
    [self addConstraint:constraint4tf];
    [self addConstraint:constraint2tf];
    [self addConstraint:constraint3tf];
    

    
    
}


-(void)setupThirdtf{
    
    _textField3 = [[UITextField alloc] init];
    
    _textField3.placeholder = @"CVV";
    _textField3.backgroundColor = [UIColor whiteColor];
    _textField3.delegate = self;
    
    _textField3.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_textField3 setKeyboardType:UIKeyboardTypeNumberPad];
    
    
    [self addSubview:_textField3];
    
    self.backgroundColor = [UIColor grayColor];
    
    NSLayoutConstraint *constraint1tf = [NSLayoutConstraint constraintWithItem:_textField3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.2f constant:0];
    
    NSLayoutConstraint *constraint4tf = [NSLayoutConstraint constraintWithItem:_textField3 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:0.8f constant:0];
    
    NSLayoutConstraint *constraint2tf = [NSLayoutConstraint constraintWithItem:_textField3 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:0.1f constant:0];
    
    NSLayoutConstraint *constraint3tf = [NSLayoutConstraint constraintWithItem:_textField3 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:0.9 constant:0];
    
    [self addConstraint:constraint1tf];
    [self addConstraint:constraint4tf];
    [self addConstraint:constraint2tf];
    [self addConstraint:constraint3tf];
    

    
    
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
    
    _creditCardImageView.image = [self imageForCardStatus];
    
//    if ([cardNumberWithoutSpaces length] > 16) {
//        // If the user is trying to enter more than 19 digits, we prevent
//        // their change, leaving the text field in  its previous state.
//        // While 16 digits is usual, credit card numbers have a hard
//        // maximum of 19 digits defined by ISO standard 7812-1 in section
//        // 3.8 and elsewhere. Applying this hard maximum here rather than
//        // a maximum of 16 ensures that users with unusual card numbers
//        // will still be able to enter their card number even if the
//        // resultant formatting is odd.
//        [textField setText:_previousTextFieldContent];
//        textField.selectedTextRange = _previousSelection;
//        return;
//    }
    
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
            
            [self animateTextField1Closed:YES];
            return;
        }
        
        cardNumberWithSpaces = [NSString insertSpacesAmexStyleForString:cardNumberWithoutSpaces andPreserveCursorPosition:&targetCursorPosition];

     
    } else {
        
        if ([cardNumberWithoutSpaces length] > 16){
            [textField setText:_previousTextFieldContent];
            textField.selectedTextRange = _previousSelection;
            
            [self animateTextField1Closed:YES];

            return;
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


-(void)animateTextField1Closed:(BOOL)close{
    
    [self bringSubviewToFront:_cardContainerView];

    
    NSLayoutConstraint *constraintToRemove = close ? _constraint_tf1_initial : _constraint_tf1_completed;
    
    NSLayoutConstraint *constraintToAdd = close ? _constraint_tf1_completed : _constraint_tf1_initial;
    
    [self removeConstraint:constraintToRemove];
    
//    UITextPosition *Pos2 = [_textField1 positionFromPosition: _textField1.endOfDocument offset: 0];
//    UITextPosition *Pos1 = [_textField1 positionFromPosition: _textField1.endOfDocument offset: -5];
//    
//    UITextRange *range = [_textField1 textRangeFromPosition:Pos1 toPosition:Pos2];
//    
//    CGRect result1 = [_textField1 firstRectForRange:(UITextRange *)range ];
//
//    _constraint_tf1_completed.constant = result1.size.width;
    
    [self addConstraint:constraintToAdd];
    
    float value = close ? 1.0f : 0.0f;
    
    [UIView animateWithDuration:0.5f animations:^{
        [self layoutIfNeeded];
        _textField2.alpha = value;
        _textField3.alpha = value;
        
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
    
    
}


-(BOOL)doesPassLuhnAlgorithm:(NSString*)str{
    
    NSArray *arrayOfValues = [str componentsSeparatedByString:@""];
    
    arrayOfValues = [arrayOfValues reversedArray];
    
    int sum = 0;
    
    for (int i =0; i <arrayOfValues.count; i++){
        
        int value = [[arrayOfValues objectAtIndex:i] intValue];

        if (i %2 != 0){
            
            value = value*2;
            
            if (value/10 == 1){
                value = 1 + (value %10);
            }
            
        }
        
        sum = sum + value;
        
    }
    
    if (sum %10 == 0){
        return YES;
    } else {
        return NO;
    }
    
    
}

-(BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    // Note textField's current state before performing the change, in case
    // reformatTextField wants to revert it
    
    if (textField == _textField1){
        _previousTextFieldContent = textField.text;
        _previousSelection = textField.selectedTextRange;
        
    }
    
    return YES;

    
}




@end
