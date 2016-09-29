//
//  SponsorTableViewCell.m
//  HackTX
//
//  Created by Jose Bethancourt on 9/23/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import "SponsorTableViewCell.h"

@implementation SponsorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.name.font = [UIFont fontWithName:@"JosefinSans" size:20];
    self.url.font = [UIFont fontWithName:@"JosefinSans" size:20];

//
//    self.cardView.layer.masksToBounds = false;
//    self.cardView.layer.cornerRadius = 5.0;
//    self.cardView.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.cardView.layer.shadowOffset = CGSizeMake(0.0, 2);
//    self.cardView.layer.shadowRadius = 4.0;
//    self.cardView.layer.shadowOpacity = 0.5;
//
//    [self updateShadowPath];
}


-(void)layoutSubviews {
//    [self updateShadowPath];
}

- (void)updateShadowPath {
//    self.cardView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.cardView.bounds].CGPath;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
