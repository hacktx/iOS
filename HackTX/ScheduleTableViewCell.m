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
    
    self.name.textColor = [UIColor htx_red];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.cardView.backgroundColor = [UIColor whiteColor];
    self.cardView.layer.cornerRadius = 2.5;
    self.cardView.layer.masksToBounds = false;
    self.cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cardView.layer.shadowOffset = CGSizeMake(0.0, .25);
    self.cardView.layer.shadowRadius = 1.0;
    self.cardView.layer.shadowOpacity = 0.2;
    
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 7.5;
    frame.origin.y += 4;
    
    frame.size.width -= 2 * 7.5;
    frame.size.height -= 2 * 4;
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
