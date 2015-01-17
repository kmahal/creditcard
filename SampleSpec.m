#import "Kiwi.h"
#import "KMCardData.h"

SPEC_BEGIN(MathSpec)

describe(@"Math", ^{
    it(@"is pretty cool", ^{
        NSUInteger a = 16;
        NSUInteger b = 26;
        [[theValue(a + b) should] equal:theValue(42)];
    });
});

describe(@"Card Data", ^{
    context(@"when first testing", ^{
        it(@"is nil", ^{
            NSString *value = nil;
            
            
            
            [[value should] beNil];
        
        });
        
        it(@"should have length", ^{
            KMCardData *data = [[KMCardData alloc] init];
            
            data.cardNumber = @"1234567890123456";
            
            [[theValue(data.cardNumber.length) should] equal:theValue(16)];
        });
    });
});

SPEC_END