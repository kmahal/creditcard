#import "Kiwi.h"
#import "KMCardData.h"
#import "KMCardEntryView.h"
#import "KMCardEntryView_privateProperties.h"

SPEC_BEGIN(AppSpec)


describe(@"Card Data", ^{
    
    __block KMCardData *cardData;
    
    beforeEach(^{
        cardData = [[KMCardData alloc] init];
    });
    
    afterEach(^{
        cardData = nil;
    });
    
    it(@"should exist", ^{
        [[cardData shouldNot] beNil];
    });
    
    context(@"allows for card entry", ^{
        
        it(@"should be nil", ^{
            
        });
        
    });
    

    

});

SPEC_END