//
//  CheckInViewController.h
//  HackTX
//
//  Created by Jose Bethancourt on 10/15/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckInViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *emailInput;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UILabel *header;

@property (weak, nonatomic) IBOutlet UIButton *addToWallet;
@property (nonatomic, weak) IBOutlet UIImageView *qrCodeImageView;

@end
