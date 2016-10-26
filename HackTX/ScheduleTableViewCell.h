//
//  ScheduleTableViewCell.h
//  HackTX
//
//  Created by Jose Bethancourt on 10/12/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UIView *cardView;

@end
