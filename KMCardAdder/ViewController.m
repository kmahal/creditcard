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

typedef void (^BlurCompletionBlock)(void);


@interface ViewController ()

@property (strong, nonatomic) UIView *blurredContainerView;
@property (strong, nonatomic) UIImageView *blurredImageView;
@property (strong, nonatomic) UIButton *cancelCameraButton;
@property (strong, nonatomic) CardIOView *cardIOView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self setupvView];
    

}


-(void)setupvView{
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor venmoBlue]];
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self.navigationController setTitle:@"Add A card"];
    
    self.title = @"Add A Card";
    
    UITextField *textField = [[UITextField alloc] init];
    
    textField.placeholder = @"Enter Card #";
    textField.backgroundColor = [UIColor whiteColor];
    
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    
    [textField setKeyboardType:UIKeyboardTypeNumberPad];
    
    
    [self.view addSubview:textField];
    
    self.view.backgroundColor = [UIColor venmoGray];
    
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0];
    
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:0.1f constant:0];
    
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0 constant:40];
    
    [self.view addConstraint:constraint1];
    [self.view addConstraint:constraint2];
    [self.view addConstraint:constraint3];
    

    
    
    if ([CardIOUtilities canReadCardWithCamera]){
        
        UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cameraButton.translatesAutoresizingMaskIntoConstraints = NO;
        [cameraButton setBackgroundColor:[UIColor venmoBlue]];
        [cameraButton setTitle:@"Or Scan Your Card" forState:UIControlStateNormal];
        [cameraButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cameraButton addTarget:self action:@selector(showCamera) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:cameraButton];
        
        
        NSLayoutConstraint *constraint1x = [NSLayoutConstraint constraintWithItem:cameraButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0];
        
        NSLayoutConstraint *constraint2x = [NSLayoutConstraint constraintWithItem:cameraButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:-20];
        
        NSLayoutConstraint *constraint3x = [NSLayoutConstraint constraintWithItem:cameraButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0 constant:40];
        
        [self.view addConstraint:constraint1x];
        [self.view addConstraint:constraint2x];
        [self.view addConstraint:constraint3x];
        
    }
    
    
    
}

-(void)showCamera{
    

    
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


-(void)blurWindowWithCompletionBlock:(BlurCompletionBlock)block{
    
    _blurredContainerView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:_blurredContainerView];
    [_blurredContainerView setAlpha:0.0f];
    
    _blurredImageView = [[UIImageView alloc] initWithFrame:_blurredContainerView.bounds];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIGraphicsBeginImageContext([UIScreen mainScreen].bounds.size);
        
        [[[[[UIApplication sharedApplication] delegate] window] layer] renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        _blurredImageView.image = [image blurredImageWithRadius:10.0f iterations:1 tintColor:[UIColor clearColor]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_blurredContainerView addSubview:_blurredImageView];
            
            [UIView animateWithDuration:0.5f animations:^{
                [_blurredContainerView setAlpha:1.0f];
                
            } completion:^(BOOL finished) {
                block();
            }];

        });
      
    });
    
   
    
    
}


-(void)removeBlurredWindow{
    
    [UIView animateWithDuration:0.5f animations:^{
        [_blurredContainerView setAlpha:0.0f];
    } completion:^(BOOL finished) {
        _blurredImageView.image = nil;
        _cardIOView = nil;
        [_cardIOView removeFromSuperview];
    }];
    
}

#pragma mark delegate method callback

- (void)cardIOView:(CardIOView *)cardIOView didScanCard:(CardIOCreditCardInfo *)info {
    if (info) {
        // The full card number is available as info.cardNumber, but don't log that!
        NSLog(@"Received card info. Number: %@, expiry: %02i/%i, cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv);
        // Use the card info...
    }
    else {
        NSLog(@"User cancelled payment info");
        // Handle user cancellation here...
    }
    
    [cardIOView removeFromSuperview];
}




-(void)viewWillAppear:(BOOL)animated{
    
    
    [super viewWillAppear:animated];
    
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
