//
//  SponsorTableViewCell.h
//  HackTX
//
//  Created by Jose Bethancourt on 9/23/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SponsorTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *url;

@end
