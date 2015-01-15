//
//  NSString+CardValidation.m
//  KMCardAdder
//
//  Created by Kabir Mahal on 1/14/15.
//  Copyright (c) 2015 KM. All rights reserved.
//

#import "NSString+CardValidation.h"
#import "NSArray+Reverse.h"

@implementation NSString (CardValidation)

+(NSString*) filteredDateStringFromString:(NSString*)string WithFilter:(NSString*)filter
{
    NSUInteger onOriginal = 0, onFilter = 0, onOutput = 0;
    char outputString[([filter length])];
    BOOL done = NO;
    
    while(onFilter < [filter length] && !done)
    {
        char filterChar = [filter characterAtIndex:onFilter];
        char originalChar = onOriginal >= string.length ? '\0' : [string characterAtIndex:onOriginal];
        switch (filterChar) {
            case '#':
                if(originalChar=='\0')
                {
                    // We have no more input numbers for the filter.  We're done.
                    done = YES;
                    break;
                }
                if(isdigit(originalChar))
                {
                    outputString[onOutput] = originalChar;
                    onOriginal++;
                    onFilter++;
                    onOutput++;
                }
                else
                {
                    onOriginal++;
                }
                break;
            default:
                // Any other character will automatically be inserted for the user as they type (spaces, - etc..) or deleted as they delete if there are more numbers to come.
                outputString[onOutput] = filterChar;
                onOutput++;
                onFilter++;
                if(originalChar == filterChar)
                    onOriginal++;
                break;
        }
    }
    outputString[onOutput] = '\0'; // Cap the output string
    return [NSString validStringForExpirationDateStr:[NSString stringWithUTF8String:outputString]];
}


+(NSString*)validStringForExpirationDateStr:(NSString*)string{
    
    int value = 0;
    
    switch (string.length) {
        case 1:
        {
            value = [[NSString stringWithFormat:@"%c", [string characterAtIndex:0]] intValue];
            
            if (value != 0 && value != 1){
                return [NSString stringWithFormat:@"0%d", value];
            }
        }
            break;
            
        case 4:{
            value = [[NSString stringWithFormat:@"%c", [string characterAtIndex:3]] intValue];
            
            if (!((value >=1) && (value<=3))){
                return [string substringToIndex:3];
            } else {
                return string;
            }
        }
            break;
            
        case 5:{
            int tempValue = [[NSString stringWithFormat:@"%c", [string characterAtIndex:3]] intValue];
            value = [[NSString stringWithFormat:@"%c", [string characterAtIndex:4]] intValue];
            
            if (tempValue == 1){
                if (!((value >= 5) && (value <=9))){
                    return string;
                } else {
                    return [string substringToIndex:4];
                }
            } else {
                return string;
            }

        }
            
        default:
            return string;
            break;
    }
    
    return string;
    
}

//+(NSString*)insertCorrectDateDigitsForString:(NSString*)string andPreserveCursorPosition:(NSUInteger*)cursorPosition{
//    
//    string = [NSString removeNonDigits:string andPreserveCursorPosition:cursorPosition];
//    
//    NSMutableString *stringWithAddedSpaces = [NSMutableString new];
//    NSUInteger cursorPositionInSpacelessString = *cursorPosition;
//    
//    int value = 0;
//    
//    switch (string.length) {
//        case 1:
//        {
//            value = [[NSString stringWithFormat:@"%c", [string characterAtIndex:0]] intValue];
//            if (value != 0 || value != 1){
//                [stringWithAddedSpaces insertString:@"0" atIndex:0];
//                if (0 < cursorPositionInSpacelessString) {
//                    (*cursorPosition)++;
//                }
//                
//                unichar characterToAdd = [string characterAtIndex:0];
//                NSString *stringToAdd =
//                [NSString stringWithCharacters:&characterToAdd length:1];
//                
//                [stringWithAddedSpaces appendString:stringToAdd];
//                
//                return stringWithAddedSpaces;
//            }
//        }
//            break;
//        case 2:
//        {
//            value = [[string substringToIndex:2] intValue];
//            
//            [stringWithAddedSpaces appendString:@" "];
//            if (2 < cursorPositionInSpacelessString) {
//                (*cursorPosition)++;
//            }
//            
//                unichar characterToAdd = [string characterAtIndex:0];
//                NSString *stringToAdd =
//                [NSString stringWithCharacters:&characterToAdd length:1];
//                
//                [stringWithAddedSpaces appendString:stringToAdd];
//                
//                return stringWithAddedSpaces;
//            }
//        }
//            break;
//            
//            
//        default:
//            break;
//    }
//    
//}

+ (NSString *)insertSpacesAmexStyleForString:(NSString *)string
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


+ (NSString *)insertSpacesEveryFourDigitsIntoString:(NSString *)string
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


+ (NSString *)removeNonDigits:(NSString *)string
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


-(BOOL)doesPassLuhnAlgorithm{
    
    NSArray *arrayOfValues = [self componentsSeparatedByString:@""];
    
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
    
    return (sum %10 == 0) ? YES : NO;

    
    
}




@end
