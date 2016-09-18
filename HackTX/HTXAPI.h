//
//  HTXAPI.h
//  HackTX
//
//  Created by Jose Bethancourt on 9/17/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTXAPI : NSObject

+ (void)refreshEvents:(void(^)(NSDictionary *response))completion;
+ (void)refreshSponsors:(void(^)(BOOL success))completion;

+ (void)sendRequest:(NSDictionary *)request
         toEndpoint:(NSString *)endpoint
           withType:(NSString *)type
     withCompletion:(void(^)(NSDictionary *response))completion;

@end
