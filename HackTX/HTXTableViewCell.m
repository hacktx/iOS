//
//  HTXTableViewCell.m
//  HackTX
//
//  Created by Jose Bethancourt on 9/17/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import "HTXTableViewCell.h"

#import "AutolayoutHelper.h"
#import "UIColor+Palette.h"
#import "Sponsor.h"

@interface HTXTableViewCell()

@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *locationLabel;

@end

@implementation HTXTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self mainInit];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self mainInit];
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self mainInit];
    return self;
}

- (void)mainInit {
    _descriptionLabel = [UILabel new];
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.textColor = [UIColor blueColor];
    
    _timeLabel = [UILabel new];
    _timeLabel.textColor = [UIColor yellowColor];
    
    _locationLabel = [UILabel new];
    _locationLabel.textColor = [UIColor lightGrayColor];
    _locationLabel.textAlignment = NSTextAlignmentRight;
    
    [AutolayoutHelper configureView:self subViews:VarBindings(_locationLabel, _timeLabel, _descriptionLabel)
                        constraints:@[@"H:[_locationLabel]-|",
                                      @"H:|-[_descriptionLabel]-|",
                                      @"H:|-[_timeLabel]",
                                      @"V:|-[_timeLabel]-[_descriptionLabel]-|",
                                      @"V:|-[_locationLabel]"]];
}

- (void)configWithSponsor:(Sponsor *)sponsor {
    _descriptionLabel.text = sponsor.name;
    _timeLabel.text = sponsor.website;
    _locationLabel.text = @"";
}

@end
