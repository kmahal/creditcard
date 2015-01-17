//
//  ViewController.m
//  KMCardAdder
//
//  Created by Kabir Mahal on 1/13/15.
//  Copyright (c) 2015 KM. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+VenmoColors.h"
#import "UIImage+BlurredView.h"
#import "CardEntryView.h"

typedef void (^BlurCompletionBlock)(void);


@interface ViewController ()

@property (strong, nonatomic) UIView *blurredContainerView;
@property (strong, nonatomic) UIImageView *blurredImageView;
@property (strong, nonatomic) UIButton *cancelCameraButton;
@property (strong, nonatomic) CardIOView *cardIOView;
@property (strong, nonatomic) CardEntryView *cardEntryView;
@property (strong, nonatomic) UILabel *errorLabel;
@property (strong, nonatomic) NSLayoutConstraint *errorLabelHidden_constraint;
@property (strong, nonatomic) NSLayoutConstraint *errorLabelShown_constraint;
@property (strong, nonatomic) UILabel *successLabel;
@property (strong, nonatomic) NSLayoutConstraint *successLabelHidden_constraint;
@property (strong, nonatomic) NSLayoutConstraint *successLabelShown_constraint;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self setupView];
    
    [self setupCardEntryView];
    
    [self setupErrorView];

    [self registerForApplicationStateNotifications];

    [self setupSuccessMessageView];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark setup methods


-(void)setupView{
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor venmoBlue]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self.navigationController.navigationBar setTranslucent:NO];
        
    //UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self
    // action:@selector(clearFields)];
    //[self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
    self.title = @"Add A Card";
    
    self.view.backgroundColor = [UIColor venmoGray];
    
    
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraButton.translatesAutoresizingMaskIntoConstraints = NO;
    [cameraButton setBackgroundColor:[UIColor venmoBlue]];
    [cameraButton setTitle:@"Add Card" forState:UIControlStateNormal];
    [cameraButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:cameraButton];
    
    
    NSLayoutConstraint *constraint1x = [NSLayoutConstraint constraintWithItem:cameraButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0];
    
    NSLayoutConstraint *constraint2x = [NSLayoutConstraint constraintWithItem:cameraButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:-20];
    
    NSLayoutConstraint *constraint3x = [NSLayoutConstraint constraintWithItem:cameraButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0 constant:40];
    
    [self.view addConstraint:constraint1x];
    [self.view addConstraint:constraint2x];
    [self.view addConstraint:constraint3x];
    
    
    
    if ([CardIOUtilities canReadCardWithCamera]){
        
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camera64"] style:UIBarButtonItemStylePlain target:self action:@selector(showCamera)];
        
        [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
        
        
    }
    
    
}


-(void)setupCardEntryView{
    
    
    _cardEntryView = [[CardEntryView alloc] init];
    _cardEntryView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:_cardEntryView];
    
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:_cardEntryView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0];
    
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:_cardEntryView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.0f constant:40];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:_cardEntryView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:0.5f constant:0];
    
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:_cardEntryView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:0.1f constant:0];
    
    [self.view addConstraints:@[constraint1, constraint2, constraint3, constraint4]];
    
    
    
}

-(void)setupSuccessMessageView{
    
    _successLabel = [[UILabel alloc] init];
    _successLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _successLabel.textAlignment = NSTextAlignmentCenter;
    [_successLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [_successLabel setTextColor:[UIColor whiteColor]];
    [_successLabel setBackgroundColor:[UIColor venmoGreen]];
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:_successLabel];
    
    NSLayoutConstraint *constraint_error_1 = [NSLayoutConstraint constraintWithItem:_successLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:[[[UIApplication sharedApplication] delegate] window] attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0];
    
    NSLayoutConstraint *constraint_error_2 = [NSLayoutConstraint constraintWithItem:_successLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.navigationController.navigationBar attribute:NSLayoutAttributeHeight multiplier:1.0f constant:22];
    
    _successLabelHidden_constraint = [NSLayoutConstraint constraintWithItem:_successLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:[[[UIApplication sharedApplication] delegate] window] attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
    
    [[[[UIApplication sharedApplication] delegate] window] addConstraints:@[constraint_error_1, constraint_error_2, _successLabelHidden_constraint]];
    
    _successLabelShown_constraint = [NSLayoutConstraint constraintWithItem:_successLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:[[[UIApplication sharedApplication] delegate] window] attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
    
}

-(void)setupErrorView{
    
    _errorLabel = [[UILabel alloc] init];
    _errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _errorLabel.textAlignment = NSTextAlignmentCenter;
    [_errorLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    [_errorLabel setBackgroundColor:[UIColor venmoRed]];
    
    [self.view addSubview:_errorLabel];
    
    NSLayoutConstraint *constraint_error_1 = [NSLayoutConstraint constraintWithItem:_errorLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_cardEntryView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0];
    
    NSLayoutConstraint *constraint_error_2 = [NSLayoutConstraint constraintWithItem:_errorLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_cardEntryView attribute:NSLayoutAttributeWidth multiplier:0.0f constant:20];
    
    _errorLabelHidden_constraint = [NSLayoutConstraint constraintWithItem:_errorLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_cardEntryView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
    
    [self.view addConstraints:@[constraint_error_1, constraint_error_2, _errorLabelHidden_constraint]];
    
    _errorLabelShown_constraint = [NSLayoutConstraint constraintWithItem:_errorLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_cardEntryView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
    
    [self.view sendSubviewToBack:_errorLabel];
    
    
    
}





-(void)clearFields{
    
    [_cardEntryView clearAllFields];
}



-(void)registerForApplicationStateNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandling:) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandling:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandling:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)notificationHandling:(NSNotification*)notification{
    
    if ([notification.name isEqualToString: UIApplicationWillResignActiveNotification]){
        [_blurredContainerView setAlpha:1.0f];
    } else {
        [_blurredContainerView setAlpha:0.0f];

    }
}

# pragma mark IBActions

-(IBAction)submitButtonPressed:(id)sender{
    
    
    [_cardEntryView getCurrentCardDataWithBlock:^(KMCardData *cardData, KMCardError *error) {
        
        if (!error){
            
            NSString *string = nil;
            
            switch (cardData.cardType) {
                case KMCardTypeAmericanExpress:
                    string = @"American Express";
                    break;
                case KMCardTypeDiscover:
                    string = @"Discover";
                    break;
                case KMCardTypeJCB:
                    string = @"JCB";
                    break;
                case KMCardTypeVisa:
                    string = @"Visa";
                    break;
                case KMCardTypeMasterCard:
                    string = @"MasterCard";
                default:
                    string = @"Unknown";
                    break;
            }
            
            [self insertSuccessViewWithMessage:[NSString stringWithFormat:@"%@ %@, %d/%d was added!", string, cardData.redactedCardNumber, cardData.expirationMonth, cardData.expirationYear]];
            
        } else {
            
            NSString *errorMessage = nil;
            
            switch (error.errorType) {
                    
                case KMCardErrorCard:{
                    errorMessage = @"card number";
                }
                break;
                    
                case KMCardErrorDate:{
                    errorMessage = @"expiration date";
                }
                break;
                    
                case KMCardErrorCVV:{
                    errorMessage = @"cvv value";

                }
                    break;
                    
                case KMCardErrorCardAndDate:{
                    errorMessage = @"card number and expiration date";

                }
                    break;

                case KMCardErrorDateAndCVV:{
                    errorMessage = @"expiration date and cvv value";

                }
                    break;
                    
                case KMCardErrorAll:{
                    errorMessage = @"card number, expiration date, and cvv value";
                }
                    break;
            }
            
            [self insertErrorViewWithErrorMessage:[NSString stringWithFormat:@"Invalid %@.", errorMessage] withSender:sender];
            
        }
        
    }];
}


-(void)showCamera{
    
    [_cardEntryView resignAllResponders];
    
    
    [self blurWindowWithCompletionBlock:^{
        _cardIOView = [[CardIOView alloc] initWithFrame:self.view.bounds];
        
        _cardIOView.delegate = self;
        _cardIOView.alpha = 0.0f;
        
        [_blurredContainerView addSubview:_cardIOView];
        
        _cancelCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelCameraButton.alpha = 0.0f;
        [_cancelCameraButton addTarget:self action:@selector(removeBlurredWindow) forControlEvents:UIControlEventTouchUpInside];
        _cancelCameraButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_cancelCameraButton setBackgroundColor:[UIColor venmoRed]];
        [_cancelCameraButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelCameraButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_blurredContainerView addSubview:_cancelCameraButton];
        
        
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:_cancelCameraButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_blurredContainerView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0];
        
        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:_cancelCameraButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_blurredContainerView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-20];
        
        NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:_cancelCameraButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_blurredContainerView attribute:NSLayoutAttributeHeight multiplier:0 constant:40];
        
        [_blurredContainerView addConstraint:constraint1];
        [_blurredContainerView addConstraint:constraint2];
        [_blurredContainerView addConstraint:constraint3];
        
        [UIView animateWithDuration:0.5f animations:^{
            _cardIOView.alpha = 1.0f;
            _cancelCameraButton.alpha = 1.0f;
        }];

    }];
    
    
    
}

-(void)insertErrorViewWithErrorMessage:(NSString*)errorMessage withSender:(id)sender{
    
    UIButton *button = (UIButton*)sender;
    button.enabled = NO;
    
    _errorLabel.text = errorMessage;
    
    [self.view removeConstraint:_errorLabelHidden_constraint];
    [self.view addConstraint:_errorLabelShown_constraint];
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        [self.view removeConstraint:_errorLabelShown_constraint];
        [self.view addConstraint:_errorLabelHidden_constraint];
        
        [UIView animateWithDuration:0.3f delay:3.0f options:UIViewAnimationOptionTransitionNone animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            button.enabled = YES;
        }];
    }];
    
    
}


-(void)insertSuccessViewWithMessage:(NSString*)successMessage{
    
    [self clearFields];
    
    _successLabel.text = successMessage;
    
    [[[[UIApplication sharedApplication] delegate] window] removeConstraint:_successLabelHidden_constraint];
    [[[[UIApplication sharedApplication] delegate] window] addConstraint:_successLabelShown_constraint];
    
    [UIView animateWithDuration:0.3f animations:^{
        [[[[UIApplication sharedApplication] delegate] window] layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        [[[[UIApplication sharedApplication] delegate] window] removeConstraint:_successLabelShown_constraint];
        [[[[UIApplication sharedApplication] delegate] window] addConstraint:_successLabelHidden_constraint];
        
        [UIView animateWithDuration:0.3f delay:3.0f options:UIViewAnimationOptionTransitionNone animations:^{
            [[[[UIApplication sharedApplication] delegate] window] layoutIfNeeded];
        } completion:^(BOOL finished) {

        }];
    }];
    
}



#pragma mark blurring methods

-(void)blurWindowWithCompletionBlock:(BlurCompletionBlock)block{
    
    _blurredContainerView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:_blurredContainerView];
    [_blurredContainerView setAlpha:0.0f];
    
    _blurredImageView = [[UIImageView alloc] initWithFrame:_blurredContainerView.bounds];
    
    UIGraphicsBeginImageContext([UIScreen mainScreen].bounds.size);
    
    [[[[[UIApplication sharedApplication] delegate] window] layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _blurredImageView.image = [image blurredImageWithRadius:10.0f iterations:1 tintColor:[UIColor clearColor]];
    [_blurredContainerView addSubview:_blurredImageView];
    
    [UIView animateWithDuration:0.5f animations:^{
        [_blurredContainerView setAlpha:1.0f];
        
    } completion:^(BOOL finished) {
        block();
    }];

    
    
}

-(void)removeBlurredWindow{
    
    [self removeBlurredWindowWithCompletionBlock:nil];
    
}


-(void)removeBlurredWindowWithCompletionBlock:(BlurCompletionBlock)block{
    
    [UIView animateWithDuration:0.5f animations:^{
        [_blurredContainerView setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [_cardIOView removeFromSuperview];
        [_cancelCameraButton removeFromSuperview];
        if (block) block();
    }];
    
}

#pragma mark delegate method callback

- (void)cardIOView:(CardIOView *)cardIOView didScanCard:(CardIOCreditCardInfo *)info {
    
    [self removeBlurredWindowWithCompletionBlock:^{
        
        if (info) {

            [_cardEntryView insertCardIOData:info];

        }


    }];

    
}



@end
