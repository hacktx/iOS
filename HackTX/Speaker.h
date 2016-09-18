//
//  Speaker.h
//  HackTX
//
//  Created by Jose Bethancourt on 9/17/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import <Realm/Realm.h>

@interface Speaker : RLMObject

@property NSInteger id;
@property NSString *name;
@property NSString *organization;
@property NSString *desc;
@property NSString *imageURL;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Speaker>
RLM_ARRAY_TYPE(Speaker)
