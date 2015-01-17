//
//  NSString+CardValidation.h
//  KMCardAdder
//
//  Created by Kabir Mahal on 1/14/15.
//  Copyright (c) 2015 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CardValidation)

+(NSString*)redactedAmexCardInfo:(NSString*)str;

+(NSString*)redactedCardInfo:(NSString*)str;

+ (NSString *)insertSpacesAmexStyleForString:(NSString *)string
                   andPreserveCursorPosition:(NSUInteger *)cursorPosition;

+ (NSString *)insertSpacesAmexStyleForString:(NSString *)string;

+ (NSString *)insertSpacesEveryFourDigitsIntoString:(NSString *)string
                          andPreserveCursorPosition:(NSUInteger *)cursorPosition;

+ (NSString*)insertSpacesEveryFourDigitsIntoString:(NSString*)string;


+ (NSString *)removeNonDigits:(NSString *)string
    andPreserveCursorPosition:(NSUInteger *)cursorPosition;

+ (NSString *)removeNonDigits:(NSString *)string;

-(BOOL)doesPassLuhnAlgorithm;

+(NSString*) filteredDateStringFromString:(NSString*)string WithFilter:(NSString*)filter;

+(NSString*)validStringForExpirationDateStr:(NSString*)string;

@end
