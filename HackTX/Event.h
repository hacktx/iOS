//
//  Event.h
//  HackTX
//
//  Created by Jose Bethancourt on 9/17/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import <Realm/Realm.h>
#import "Location.h"
#import "Speaker.h"

@interface Event : RLMObject

@property NSString *serverID;
@property NSString *name;
@property NSString *desc;
@property NSString *imageURL;
// Swith this to NSDate
@property NSDate *startDate;
@property NSDate *endDate;
@property Location *location;
@property RLMArray<Speaker *><Speaker> *speakers;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Event>
RLM_ARRAY_TYPE(Event)
