//
//  AnnouncementTableViewCell.h
//  HackTX
//
//  Created by Jose Bethancourt on 10/16/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnouncementTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
