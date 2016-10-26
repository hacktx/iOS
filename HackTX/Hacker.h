//
//  Hacker.h
//  HackTX
//
//  Created by Jose Bethancourt on 10/15/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import <Realm/Realm.h>

@interface Hacker : RLMObject

@property NSString *name;
@property NSString *email;
@property NSString *school;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Hacker>
RLM_ARRAY_TYPE(Hacker)
