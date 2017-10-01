//
//  TwitterFeedTableViewCell.h
//  HackTX
//
//  Created by Ashwin Gupta on 9/30/17.
//  Copyright © 2017 HackTX. All rights reserved.
//

#ifndef TwitterFeedTableViewCell_h
#define TwitterFeedTableViewCell_h

#import <UIKit/UIKit.h>

@interface TwitterFeedTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *tweeterName;
@property (weak, nonatomic) IBOutlet UILabel *tweetTime;
@property (weak, nonatomic) IBOutlet UILabel *tweetDesc;
@property (weak, nonatomic) IBOutlet UIView *cardView;

@end


#endif /* TwitterFeedTableViewCell_h */
