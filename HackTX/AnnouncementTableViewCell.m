//
//  AnnouncementTableViewCell.m
//  HackTX
//
//  Created by Jose Bethancourt on 10/16/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import "AnnouncementTableViewCell.h"

#import "UIColor+Palette.h"

@implementation AnnouncementTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    
//    self.name.font = [UIFont fontWithName:@"JosefinSans" size:18];
//    self.url.font = [UIFont fontWithName:@"JosefinSans" size:18];
    self.time.textColor = [UIColor htx_red];
    
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
