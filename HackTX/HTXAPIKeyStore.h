//
//  HTXAPIKeyStore.h
//  HackTX
//
//  Created by Jose Bethancourt on 10/12/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTXAPIKeyStore : NSObject

+ (instancetype)sharedHTXAPIKeyStore;

- (NSString *)getGMSKey;

@end
