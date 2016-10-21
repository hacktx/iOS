//
//  CheckInViewController.m
//  HackTX
//
//  Created by Jose Bethancourt on 10/15/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import "CheckInViewController.h"
#import "UIColor+Palette.h"
#import "AutolayoutHelper.h"
#import "SVProgressHUD.h"
#import "FCAlertView.h"
#import "Hacker.h"
#import "HTXAPI.h"

#import <Crashlytics/Crashlytics.h>


@import PassKit;

@interface CheckInViewController () <UITextFieldDelegate>

@property (nonatomic, retain) CAGradientLayer *gradient;
@property (nonatomic, retain) NSString *hackerEmail;
@property (nonatomic, retain) Hacker *currentHacker;
@property (nonatomic, retain) UITapGestureRecognizer *tap;

@end

@implementation CheckInViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    self.emailInput.delegate = self;
    [self setupView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self dismissKeyboard];
    [SVProgressHUD show];
    self.hackerEmail = textField.text;
    
    [HTXAPI fetchHacker:self.hackerEmail withCompletion:^(NSDictionary *response) {
        if ([response[@"data"][@"email"] isEqualToString:self.hackerEmail]) {

            [Answers logCustomEventWithName:@"Checked In"
                           customAttributes:@{}];
            
            Hacker *newHacker = [[Hacker alloc] init];
            newHacker.name = response[@"data"][@"name"];
            newHacker.email = response[@"data"][@"email"];
            newHacker.school = response[@"data"][@"school"];
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [realm addObject:newHacker];
            [realm commitWriteTransaction];
            [SVProgressHUD dismiss];
            
            [self updateView];
            [self showPass];
        } else if (![response[@"response"] boolValue]) {
            
            [SVProgressHUD dismiss];
            
            FCAlertView *alert = [[FCAlertView alloc] init];
            
            [alert showAlertInView:self
                         withTitle:@"Sorry"
                      withSubtitle:@"We could not find your email. If you believe this is an error, ask a friendly volunteer. 🙂"
                   withCustomImage:nil
               withDoneButtonTitle:@"Okay"
                        andButtons:nil];
            [alert makeAlertTypeCaution];
            
        } else {
            [SVProgressHUD dismiss];
            
            FCAlertView *alert = [[FCAlertView alloc] init];
            
            [alert showAlertInView:self
                         withTitle:@"Network error"
                      withSubtitle:@"There was an error checking you in, please try again later. 😥"
                   withCustomImage:nil
               withDoneButtonTitle:@"Okay"
                        andButtons:nil];
            [alert makeAlertTypeCaution];
        }
    }];

    return YES;
}


- (void)showPass {
    
    [SVProgressHUD show];
    
    [HTXAPI fetchPass:self.hackerEmail withPassData:^(NSData *data) {
        [SVProgressHUD dismiss];

        if ([PKAddPassesViewController canAddPasses]) {
            PKPass *pass = [[PKPass alloc] initWithData:data error:nil];
            PKAddPassesViewController *passVC = [[[PKAddPassesViewController alloc] init] initWithPass:pass];
            [self presentViewController:passVC animated:YES completion:nil];
            [Answers logCustomEventWithName:@"Added Pass"
                           customAttributes:@{}];
        } else {
            FCAlertView *alert = [[FCAlertView alloc] init];
            
            [alert showAlertInView:self
                         withTitle:@"Sorry"
                      withSubtitle:@"Apple Wallet is not compatible with this device. Sorry about that. 🙁"
                   withCustomImage:nil
               withDoneButtonTitle:@"Okay"
                        andButtons:nil];
            [alert makeAlertTypeCaution];
        }
        
    }];
}

- (void)updateView {
    RLMResults<Hacker *> *hackers = [Hacker allObjects];
    
    if (hackers.count > 0) {
        self.hackerEmail = hackers[0].email;
        
        self.header.text = [NSString stringWithFormat:@"You are all set, %@", hackers[0].name];
        self.message.text = @"Add the pass to your wallet and show it to a volunteer when checking in.";
        self.addToWallet.hidden = NO;
        self.emailInput.hidden = YES;
        
        [self.addToWallet addTarget:self action:@selector(showPass) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view removeGestureRecognizer:self.tap];

        
    } else {
        self.header.text = @"Welcome to HackTX!";
        self.message.text = @"Enter the email you used during registration to fetch your ticket.";
        
        self.message.hidden = NO;
        self.emailInput.hidden = NO;
        self.addToWallet.hidden = YES;
        
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
        
        [self.tap setCancelsTouchesInView:NO];
        [self.view addGestureRecognizer:self.tap];
        

    }
}

- (void)setupView {
    self.gradient = [CAGradientLayer layer];
    self.gradient.frame = self.view.bounds;
    self.gradient.colors = [NSArray arrayWithObjects:(id)[UIColor htx_lightBlue].CGColor, (id)[UIColor htx_lighterBlue].CGColor, nil];

    [self.view.layer insertSublayer:self.gradient atIndex:0];
    
    self.message.textColor = [UIColor htx_white];
    self.header.textColor = [UIColor htx_white];
    self.emailInput.tintColor = [UIColor htx_white];
    self.emailInput.textColor = [UIColor htx_white];
    
    [self updateView];
}

- (void)dismissKeyboard {
    [self.emailInput resignFirstResponder];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.gradient.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
