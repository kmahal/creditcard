Kabir's Venmo Challenge
========================



Overview
--------

This application lets a user enter in a new (credit or debit) card for payments.  This application was made not just to fulfill the requirements (discussed below), but also to be portable and useable from the start.  I used open source frameworks and libraries for features that already have elegant solutions, but built many components by hand to showcase my technical chops that follow industry standards but conform to the Venmo design aesthetic.  I even tweaked some of Venmo's UX to show some of my own product thinking, and I look forward to hearing what the team thinks!


Supported iOS Versions
---------

This app is built for iOS 7 and newer, which is over 95% coverage, but is compatible with iOS 6.  Works on iPhone4S and newer.

Requirements (copied directly)
---------

1. Your form should support the following networks:
 * Amex, Discover, JCB, MasterCard, Visa

##### The form should contain:
2. A number field
 * Prevent the user from entering more text if the first six digits don't match one of the networks above.
 * Prevent the user from entering too many digits.
  ** American Express cards have 15 digit numbers.
  ** MasterCard, Visa, Discover, and JCB credit and debit cards have 16 digit numbers.
3. A card logo
 * Show VDKGenericCard.png next to the text field when the field is empty.
 * Show the correct card logo when you've identified the card type.
4. An expiration date field
 * Prevent the user from entering an invalid expiration date.
5. A CVV field
 * Prevent the user from entering CVV that is too long.
 * Change the card logo to VDKCVV.png when the user is editing the CVV.
 * Prevent the user from entering too many digits.
  * American Express cards have 4 digit codes.
  * MasterCard, Visa, Discover, and JCB credit and debit cards have 3-digit codes.
6. A submit button
 * When the user taps submit, perform a Luhn validation on the card number.
 * If Luhn validation passes and all other fields are valid, show a "Success!" message. Otherwise, display a helpful error message.2. 



Open Source Frameworks and Libraries Used
---------------

This project uses Cocoapods.

1. [card.io](https://github.com/card-io/card.io-iOS-SDK)
 * Card.io scans credit cards and passes down pertinent data
2. [FXBlurView](https://github.com/nicklockwood/FXBlurView)
 * A great library that creates as gaussian blur image rendering.  Used to support iOS 7 that doensn't have iOS 8's APIs, and used for iOS8 as well.
3. StackOverFlow
 * Not a framework or library, but just as important.  For many things including credit card text styling and cursor saving, there were some great posts on SO that helped with that


KMCardEntryView Usage
----------------

This is the custom class that I created for a user to input their credit card information.

I did a lot of research within apps that use credit cards to see what the industry has for their UX.  Apps like Uber and Sprig (just 2 examples) have one view which animates over the card entry textfield to show the expiration date and cvv fields.  Venmo has a clear design practice of full screen width, white textfields and keeping that aesthetic remained important and so I built my own that duplicates that functionality.

The specific implementation is available in the .m file, which I hope you all can read and see how I built it.  


##### Public methods


###### Get The Card Data

```objective-c
-(void)getCurrentCardDataWithBlock:(KMCardDataResponseBlock)block
```

Since a requirement is a submit button that can give the user feedback, I chose to use a block to pass the current context instead of implementing a protocol and delegate.  The submit button calls this method.  Below is the block type:

```objective-c
typedef void (^KMCardDataResponseBlock)(KMCardData *cardData, KMCardError *error);
```


The application checks for an error, and if it exists then it checks for the error type.  Error types include:
```objective-c
typedef enum {
    
    KMCardErrorCard = 1,
    KMCardErrorDate = 2,
    KMCardErrorCVV = 3,
    KMCardErrorCardAndDate = 4,
    KMCardErrorDateAndCVV = 5,
    KMCardErrorAll = 6
    
} KMErrorType;
```

The application creates an error notification (similar to Venmo's currently) that is shown with the error info and then removed.


If there is not an error then the user should use cardData, which has the following info:
```objective-c

@interface KMCardData : NSObject

@property(nonatomic, assign) KMCardType cardType;
@property (nonatomic, copy) NSString *cardNumber;
@property (nonatomic, copy) NSString *redactedCardNumber;
@property (nonatomic) int expirationMonth;
@property (nonatomic) int expirationYear;
@property (nonatomic, copy) NSString *cvv;

@end
```

With Card Types:
```objective-c
typedef enum {
    
    KMCardTypeUnknown = -1,
    KMCardTypeAmericanExpress = 1,
    KMCardTypeDiscover = 2,
    KMCardTypeJCB = 3,
    KMCardTypeMasterCard = 4,
    KMCardTypeVisa = 5
    
} KMCardType;
```

The application then shows a success notification and clears out the view's fields.



###### Other methods

KMCardEntryView also works with CardIO and can take in the information from a scan:

```objective-c
-(void)insertCardIOData:(CardIOCreditCardInfo *)info;
```

If the application wants the user to restart the entry:

```objective-c
-(void)clearAllFields;
```

Or to close the number entry keyboard:

```objective-c
-(void)resignAllResponders;
```



Security
----------------

Credit card information is sensitive.  So when the application resigns active or goes into the foreground, a blurred image is overlayed on top of the screen to obfuscate any credit card information.


Testing
---------

Testing was done using Kiwi.  I do not have a strong background in testing, and so it was a good challenge to learn a new skill!

I also did reading on UI Automation frameworks like KIF which are really powerful.  To limit the time of this project however I did not dive into that, and wrote simple Kiwi tests.  I plan on reading up more about both and implementing them into my current work projects as well.






