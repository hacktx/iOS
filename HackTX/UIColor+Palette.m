//
//  UIColor+Palette.m
//  HackTX
//
//  Created by Jose Bethancourt on 9/8/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import "UIColor+Palette.h"

@implementation UIColor(Palette)

+ (instancetype)menloBlue {
    return [self colorWithRed:11.f / 255.0f green:61.0f / 255.0f blue:145.0f / 255.0f alpha:1.f];
}

+ (instancetype)menloGold {
    return [self colorWithRed:254.f / 255.0f green:166.0f / 255.0f blue:32.0f / 255.0f alpha:1.f];
}

+ (instancetype)emeraldGreen {
    return [self colorWithRed:46.f/255.f green:204.f/255.f blue:133.f/255.f alpha:1];
}


@end
