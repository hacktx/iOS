//
//  Tweet.m
//  HackTX
//
//  Created by Ashwin Gupta on 9/30/17.
//  Copyright © 2017 HackTX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tweet.h"

@implementation Tweet

+ (NSString *)primaryKey {
    return @"serverID";
}

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end
