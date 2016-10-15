//
//  CheckInViewController.m
//  HackTX
//
//  Created by Jose Bethancourt on 10/15/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import "CheckInViewController.h"
#import "UIColor+Palette.h"
#import "Hacker.h"
#import "HTXAPI.h"

@interface CheckInViewController () <UITextFieldDelegate>

@property (nonatomic, retain) CAGradientLayer *gradient;
@property (nonatomic, retain) NSString *hackerEmail;
@property (nonatomic, retain) UIView *ticketView;
@property (nonatomic, retain) Hacker *currentHacker;

@end

@implementation CheckInViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.emailInput.delegate = self;
    [self setupView];
}

-(void)dismissKeyboard {
    [self.emailInput resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self dismissKeyboard];
    self.hackerEmail = textField.text;
    
    [HTXAPI fetchPass:self.hackerEmail withCompletion:^(NSDictionary *response) {
        if ([response[@"data"][@"email"] isEqualToString:self.hackerEmail]) {

            Hacker *newHacker = [[Hacker alloc] init];
            newHacker.name = response[@"data"][@"name"];
            newHacker.email = response[@"data"][@"email"];
            newHacker.school = response[@"data"][@"school"];
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [realm addObject:newHacker];
            [realm commitWriteTransaction];
            
            NSLog(@"%@", response[@"data"]);
        }
    }];

    return YES;
}

- (void)setupView {
    
    self.gradient = [CAGradientLayer layer];
    self.gradient.frame = self.view.bounds;
    self.gradient.colors = [NSArray arrayWithObjects:(id)[UIColor htx_lightBlue].CGColor, (id)[UIColor htx_lightLightBlue].CGColor, nil];
    
    [self.view.layer insertSublayer:self.gradient atIndex:0];
    
    RLMResults<Hacker *> *hackers = [Hacker allObjects];
    
    if (hackers.count > 0) {
        self.currentHacker = hackers[0];
        
        self.message.hidden = YES;
        self.emailInput.hidden = YES;
        
    } else {
        
        self.ticketView.hidden = YES;
        
        self.message.hidden = NO;
        self.emailInput.hidden = NO;
        self.message.textColor = [UIColor htx_lightLightBlue];
        self.emailInput.textColor = [UIColor htx_lightLightBlue];
    
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(dismissKeyboard)];
        [tap setCancelsTouchesInView:NO];
        [self.view addGestureRecognizer:tap];
    }
    
    

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
