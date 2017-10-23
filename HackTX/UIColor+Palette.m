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

// White #EDF2F5 -> rgb (237,242,245)

+ (instancetype) htx_white {
    return [self colorWithRed:237.f/255.f
                        green:242.f/255.f
                         blue:245.f/255.f
                        alpha:1];
}

// Lighter Blue #8AA8BC -> rgb (138,168,188)

+ (instancetype) htx_lighterBlue {
    return [self colorWithRed:138.f/255.f
                        green:168.f/255.f
                         blue:188.f/255.f
                        alpha:1];
}






+ (instancetype) htx17_darkBlue {
    return [self colorWithRed:51.f/255.f
                        green:0.f/255.f
                         blue:128.f/255.f
                        alpha:1];
}

+ (instancetype) htx17_lightBlue {
    return [self colorWithRed:187.f/255.f
                        green:185.f/255.f
                         blue:234.f/255.f
                        alpha:1];
}

+ (instancetype) htx17_pink {
    return [self colorWithRed:255.f/255.f
                        green:8.f/255.f
                         blue:99.f/255.f
                        alpha:1];
}

+ (instancetype) htx17_darkOrange {
    return [self colorWithRed:255.f/255.f
                        green:93.f/255.f
                         blue:71.f/255.f
                        alpha:1];
}

+ (instancetype) htx17_lightOrange {
    return [self colorWithRed:255.f/255.f
                        green:150.f/255.f
                         blue:46.f/255.f
                        alpha:1];
}

@end
