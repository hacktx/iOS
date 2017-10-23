//
//  ScheduleTableViewCell.m
//  HackTX
//
//  Created by Ashwin Gupta on 09/30/17.
//  Copyright © 2017 HackTX. All rights reserved.
//

#import "TwitterFeedTableViewCell.h"

#import "UIColor+Palette.h"

@implementation TwitterFeedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tweetTime.textColor = [UIColor htx_red];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.cardView.backgroundColor = [UIColor whiteColor];
    self.cardView.layer.cornerRadius = 2.5;
    self.cardView.layer.masksToBounds = false;
    self.cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cardView.layer.shadowOffset = CGSizeMake(0.0, .25);
    self.cardView.layer.shadowRadius = 1.0;
    self.cardView.layer.shadowOpacity = 0.2;
    
}


//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//    self.desc.preferredMaxLayoutWidth = self.desc.frame.size.width;
//}
//
//- (void)viewDidLayoutSubviews {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.desc.preferredMaxLayoutWidth = self.desc.frame.size.width;
//    });
//}

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