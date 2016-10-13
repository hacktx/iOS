//
//  ScheduleTableViewCell.m
//  HackTX
//
//  Created by Jose Bethancourt on 10/12/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import "ScheduleTableViewCell.h"

#import "UIColor+Palette.h"

@implementation ScheduleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.name.font = [UIFont fontWithName:@"JosefinSans" size:18];
    self.desc.font = [UIFont fontWithName:@"JosefinSans" size:15];
    self.time.font = [UIFont fontWithName:@"JosefinSans" size:15];
    self.desc.textColor = [UIColor htx_lightBlue];
    
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
    
    [super layoutSubviews];
    
    //    CGRect boundsWithInsets = CGRectMake(self.bounds.origin.x + 5,
    //                                         self.bounds.origin.y + 2.5,
    //                                         self.bounds.size.width - 2 * 5,
    //                                         self.bounds.size.height - 2 * 2.5);
    //    [super setBounds:boundsWithInsets];
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
