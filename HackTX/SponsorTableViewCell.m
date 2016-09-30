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

    self.backgroundColor = [UIColor clearColor];
    self.cardView.backgroundColor = [UIColor whiteColor];
    self.cardView.layer.cornerRadius = 2.5;
    
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
//    self.contentView.frame = UIEdgeInsetsInsetRect(self.contentView.frame, UIEdgeInsetsMake(2.5, 10, 0, 10));

//    [self updateShadowPath];
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 5;
    frame.origin.y += 2.5;
    
    frame.size.width -= 2 * 5;
    frame.size.height -= 2 * 2.5;
    [super setFrame:frame];
}

- (void)updateShadowPath {
//    self.cardView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.cardView.bounds].CGPath;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
