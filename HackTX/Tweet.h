//
//  Tweet.h
//  HackTX
//
//  Created by Ashwin Gupta on 9/30/17.
//  Copyright © 2017 HackTX. All rights reserved.
//

#ifndef Tweet_h
#define Tweet_h

#import <Realm/Realm.h>

@interface Tweet : RLMObject

@property NSString *serverID;
// add image
@property NSString *tweeterName;
@property NSString *tweetDesc;
@property NSString *imageURL;
// Swith this to NSDate
@property NSDate *tweetTime;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Event>
RLM_ARRAY_TYPE(Tweet)


#endif /* Tweet_h */
