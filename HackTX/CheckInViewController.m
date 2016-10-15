//
//  CheckInViewController.m
//  HackTX
//
//  Created by Jose Bethancourt on 10/15/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import "CheckInViewController.h"
#import "UIColor+Palette.h"
#import "HTXAPI.h"

@interface CheckInViewController () <UITextFieldDelegate>

@property (nonatomic, retain) CAGradientLayer *gradient;

@end

@implementation CheckInViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
    
    self.emailInput.delegate = self;
    [self styleView];
}

-(void)dismissKeyboard {
    [self.emailInput resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self dismissKeyboard];
    
    [HTXAPI fetchPass:textField.text withCompletion:^(NSDictionary *data) {
        if (data[@"success"]) {
            
        }
    }];

    return YES;
}
- (void)styleView {
    
    self.message.textColor = [UIColor htx_lightLightBlue];
    self.emailInput.textColor = [UIColor htx_lightLightBlue];
    
    self.gradient = [CAGradientLayer layer];
    
    self.gradient.frame = self.view.bounds;

    self.gradient.colors = [NSArray arrayWithObjects:(id)[UIColor htx_lightBlue].CGColor, (id)[UIColor htx_lightLightBlue].CGColor, nil];
    [self.view.layer insertSublayer:self.gradient atIndex:0];

}

-(void)viewWillLayoutSubviews {
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
