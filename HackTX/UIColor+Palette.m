//
//  UIColor+Palette.m
//  HackTX
//
//  Created by Jose Bethancourt on 9/8/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import "UIColor+Palette.h"

@implementation UIColor(Palette)

// Light Blue #5983A0 -> RGB (89,131,160)

+ (instancetype) htx_lightBlue {
    return [self colorWithRed:89.f/255.f
                        green:131.f/255.f
                         blue:160.f/255.f
                        alpha:1];
}

// Red #cb0922 -> rgb(203,9,34)

+ (instancetype) htx_red {
    return [self colorWithRed:203.f/255.f
                        green:9.f/255.f
                         blue:34.f/255.f
                        alpha:1];
}

// Lighter Blue #cdd9e2 -> rgb (205,217,226)

+ (instancetype) htx_lightLightBlue {
    return [self colorWithRed:205.f/255.f
                        green:217.f/255.f
                         blue:226.f/255.f
                        alpha:1];
}
@end
