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

@interface CardEntryView()

@property (strong, nonatomic) UITextField *textField1;
@property (strong, nonatomic) UITextField *textField2;
@property (strong, nonatomic) UITextField *textField3;
@property (strong, nonatomic) UIImageView *creditCardImageView;
@property (nonatomic) CardType cardTypeStatus;

@property (strong, nonatomic) NSString *previousTextFieldContent;
@property (strong, nonatomic) UITextRange *previousSelection;


@end

@implementation CardEntryView



-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self){
        
        [self addObserver:self forKeyPath:@"cardTypeStatus" options:NSKeyValueObservingOptionNew context:nil];

        
        _cardTypeStatus = cardTypeUnknown;
        
        UIView *containerView1 = [[UIView alloc] init];
        [containerView1 setBackgroundColor:[UIColor redColor]];
        containerView1.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:containerView1];
        
        NSArray *array1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[cv]" options:0 metrics:nil views:@{@"cv": containerView1}];
        
        NSArray *array2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[cv]" options:0 metrics:nil views:@{@"cv": containerView1}];
        
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:containerView1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0];
        
        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:containerView1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.1f constant:0];
        
        
        [self addConstraints:@[constraint1, constraint2]];
        [self addConstraints:array1];
        [self addConstraints:array2];
        
        _creditCardImageView = [[UIImageView alloc] init];
        _creditCardImageView.image = [self imageForCardStatus];
        _creditCardImageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [containerView1 addSubview:_creditCardImageView];
        
        NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:_creditCardImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:_creditCardImageView.image.size.height];
        
       NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:_creditCardImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:0.0f constant:_creditCardImageView.image.size.width];
        
        NSLayoutConstraint *constraint5 = [NSLayoutConstraint constraintWithItem:_creditCardImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:containerView1 attribute:NSLayoutAttributeRight multiplier:0.5f constant:0];
        
        NSLayoutConstraint *constraint6 = [NSLayoutConstraint constraintWithItem:_creditCardImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:containerView1 attribute:NSLayoutAttributeBottom multiplier:0.5f constant:0];
        
        [containerView1 addConstraints:@[constraint3, constraint4]];
        
        [containerView1 addConstraints:@[constraint5, constraint6]];
        
        _textField1 = [[UITextField alloc] init];
        
        _textField1.placeholder = @"1234 5678 9760 2892";
        _textField1.backgroundColor = [UIColor whiteColor];
        _textField1.delegate = self;
        
        _textField1.translatesAutoresizingMaskIntoConstraints = NO;
        
        [_textField1 setKeyboardType:UIKeyboardTypeNumberPad];
        
        
        [self addSubview:_textField1];
        
        self.backgroundColor = [UIColor grayColor];
        
        NSLayoutConstraint *constraint1tf = [NSLayoutConstraint constraintWithItem:_textField1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:containerView1 attribute:NSLayoutAttributeRight multiplier:1.0f constant:20];
        
        NSLayoutConstraint *constraint4tf = [NSLayoutConstraint constraintWithItem:_textField1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.5f constant:0];
        
        NSLayoutConstraint *constraint2tf = [NSLayoutConstraint constraintWithItem:_textField1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:0.1f constant:0];
        
        NSLayoutConstraint *constraint3tf = [NSLayoutConstraint constraintWithItem:_textField1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:0.9 constant:0];
        
        [self addConstraint:constraint1tf];
        [self addConstraint:constraint4tf];
        [self addConstraint:constraint2tf];
        [self addConstraint:constraint3tf];

       // [self setupSecondTF];
       // [self setupThirdtf];
        
        [_textField1 addTarget:self
                        action:@selector(reformatAsCardNumber:)
              forControlEvents:UIControlEventEditingChanged];
        
        
    }
    
    return self;
    
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"cardTypeStatus"]){
        
    }
    
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
    
    NSString *cardNumberWithoutSpaces =
    [self removeNonDigits:textField.text
andPreserveCursorPosition:&targetCursorPosition];
    
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
            return;
        }
        
        cardNumberWithSpaces =
        [self insertSpacesAmexStyleForString:cardNumberWithoutSpaces
                   andPreserveCursorPosition:&targetCursorPosition];
     
    } else {
        
        if ([cardNumberWithoutSpaces length] > 16){
            [textField setText:_previousTextFieldContent];
            textField.selectedTextRange = _previousSelection;
            return;
        }
        
        cardNumberWithSpaces =
        [self insertSpacesEveryFourDigitsIntoString:cardNumberWithoutSpaces
                          andPreserveCursorPosition:&targetCursorPosition];
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
            if ((NSLocationInRange(ccValue, NSMakeRange(622126, (622925-5352622126))))){
                _cardTypeStatus = cardTypeDiscover;
            }
            break;
        }
        default:
            break;
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

/*
 Removes non-digits from the string, decrementing `cursorPosition` as
 appropriate so that, for instance, if we pass in `@"1111 1123 1111"`
 and a cursor position of `8`, the cursor position will be changed to
 `7` (keeping it between the '2' and the '3' after the spaces are removed).
 */
- (NSString *)removeNonDigits:(NSString *)string
    andPreserveCursorPosition:(NSUInteger *)cursorPosition
{
    NSUInteger originalCursorPosition = *cursorPosition;
    NSMutableString *digitsOnlyString = [NSMutableString new];
    for (NSUInteger i=0; i<[string length]; i++) {
        unichar characterToAdd = [string characterAtIndex:i];
        if (isdigit(characterToAdd)) {
            NSString *stringToAdd =
            [NSString stringWithCharacters:&characterToAdd
                                    length:1];
            
            [digitsOnlyString appendString:stringToAdd];
        }
        else {
            if (i < originalCursorPosition) {
                (*cursorPosition)--;
            }
        }
    }
    
    return digitsOnlyString;
}

/*
 Inserts spaces into the string to format it as a credit card number,
 incrementing `cursorPosition` as appropriate so that, for instance, if we
 pass in `@"111111231111"` and a cursor position of `7`, the cursor position
 will be changed to `8` (keeping it between the '2' and the '3' after the
 spaces are added).
 */
- (NSString *)insertSpacesEveryFourDigitsIntoString:(NSString *)string
                          andPreserveCursorPosition:(NSUInteger *)cursorPosition
{
    NSMutableString *stringWithAddedSpaces = [NSMutableString new];
    NSUInteger cursorPositionInSpacelessString = *cursorPosition;
    for (NSUInteger i=0; i<[string length]; i++) {
        if ((i>0) && ((i % 4) == 0)) {
            [stringWithAddedSpaces appendString:@" "];
            if (i < cursorPositionInSpacelessString) {
                (*cursorPosition)++;
            }
        }
        unichar characterToAdd = [string characterAtIndex:i];
        NSString *stringToAdd =
        [NSString stringWithCharacters:&characterToAdd length:1];
        
        [stringWithAddedSpaces appendString:stringToAdd];
    }
    
    return stringWithAddedSpaces;
}


- (NSString *)insertSpacesAmexStyleForString:(NSString *)string
                          andPreserveCursorPosition:(NSUInteger *)cursorPosition
{
    NSMutableString *stringWithAddedSpaces = [NSMutableString new];
    NSUInteger cursorPositionInSpacelessString = *cursorPosition;
    for (NSUInteger i=0; i<[string length]; i++) {
        if (((i>0) && (i == 4) && ((i % 4) == 0)) || ((i>0) && (i==10) && (i%10) == 0)) {
            [stringWithAddedSpaces appendString:@" "];
            if (i < cursorPositionInSpacelessString) {
                (*cursorPosition)++;
            }
        }
        unichar characterToAdd = [string characterAtIndex:i];
        NSString *stringToAdd =
        [NSString stringWithCharacters:&characterToAdd length:1];
        
        [stringWithAddedSpaces appendString:stringToAdd];
    }
    
    return stringWithAddedSpaces;
}








@end
