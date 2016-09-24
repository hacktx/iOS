//
//  HTXTableViewCell.h
//  HackTX
//
//  Created by Jose Bethancourt on 9/17/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Sponsor;

@interface HTXTableViewCell : UITableViewCell

- (void)configWithSponsor:(Sponsor *)sponsor;

@end
