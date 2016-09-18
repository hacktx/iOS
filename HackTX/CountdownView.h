//
//  CountdownView.h
//  HackTX
//
//  Created by Jose Bethancourt on 9/8/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountdownView : UIView

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@end
