//
//  Location.h
//  HackTX
//
//  Created by Jose Bethancourt on 9/17/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import <Realm/Realm.h>

@interface Location : RLMObject

@property NSString *building;
@property NSString *level;
@property NSString *room;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Location>
RLM_ARRAY_TYPE(Location)
