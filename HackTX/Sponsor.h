//
//  Sponsors.h
//  HackTX
//
//  Created by Jose Bethancourt on 9/17/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import <Realm/Realm.h>

@interface Sponsor : RLMObject

@property NSString *serverID;
@property NSString *name;
@property NSString *logoImage;
@property NSString *website;
@property NSInteger level;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Sponsors>
RLM_ARRAY_TYPE(Sponsor)
