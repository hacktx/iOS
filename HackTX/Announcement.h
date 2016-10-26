//
//  Announcement.h
//  HackTX
//
//  Created by Jose Bethancourt on 9/17/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import <Realm/Realm.h>

@interface Announcement : RLMObject

@property NSString *serverID;
@property NSString *text;
@property NSDate *timestamp;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Announcement>
RLM_ARRAY_TYPE(Announcement)
