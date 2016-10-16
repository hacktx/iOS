//
//  HTXAPI.m
//  HackTX
//
//  Created by Jose Bethancourt on 9/17/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import "HTXAPI.h"
#import "HTXConstants.h"
#import "AFNetworking.h"
#import "NSString+MD5.h"
#import "Announcement.h"
#import "Sponsor.h"
#import "Event.h"


@implementation HTXAPI

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (void)fetchPass:(NSString *)email withPassData:(void(^)(NSData *data))passData {
    return [[[HTXAPI alloc] init] fetchPass:email withPassData:passData];
}

+ (void)fetchHacker:(NSString *)email withCompletion:(void(^)(NSDictionary *data))completion {
    return [[[HTXAPI alloc] init] fetchHacker:email withCompletion:completion];
}

+ (void)refreshAnnouncements:(void(^)(BOOL success))completion {
    return [[[HTXAPI alloc] init] refreshAnnouncements:completion];
}

+ (void)refreshEvents:(void(^)(BOOL success))completion {
    return [[[HTXAPI alloc] init] refreshEvents:completion];
}

+ (void)refreshSponsors:(void(^)(BOOL success))completion {
    return [[[HTXAPI alloc] init] refreshSponsors:completion];
}

+ (void)sendRequest:(NSDictionary *)request
         toEndpoint:(NSString *)endpoint
           withType:(NSString *)type
     withCompletion:(void(^)(NSDictionary *response))completion {
    return [[[HTXAPI alloc] init] sendRequest:request toEndpoint:endpoint withType:type withCompletion:completion];
}

- (void)fetchPass:(NSString *)email
     withPassData:(void(^)(NSData *data))passData {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:@"https://joseb.me/hacktx/gen_pass.php" parameters:@{@"email": email} progress:nil success:^(NSURLSessionTask *task, NSData *responseObject) {
        passData(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"%% %@", error);
    }];

}

- (void)fetchHacker:(NSString *)email
   withCompletion:(void(^)(NSDictionary *data))completion {
    [self sendRequest:@{@"email": email} toEndpoint:@"pass.php" withType:@"GET" withCompletion:^(NSDictionary *response) {
        completion(response);
    }];
}

- (void)refreshAnnouncements:(void(^)(BOOL success))completion {
    [self sendRequest:nil toEndpoint:@"announcements.php" withType:@"GET" withCompletion:^(NSDictionary *response) {
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd kk:mm:ss"];

        if (response[@"success"]) {
            for (id object in response[@"data"]) {
                Announcement *newAnnouncement = [[Announcement alloc] init];
                
                newAnnouncement.serverID = [NSString stringWithFormat:@"%@%@", [object[@"text"] MD5], [object[@"ts"] MD5]];
                newAnnouncement.text = object[@"text"];
                newAnnouncement.timestamp = [dateFormat dateFromString:object[@"ts"]];
                
                [realm beginWriteTransaction];
                [realm addOrUpdateObject:newAnnouncement];
                [realm commitWriteTransaction];
            }
            completion(YES);
        }
    }];
}

- (void)refreshSponsors:(void(^)(BOOL success))completion {
    [self sendRequest:nil toEndpoint:@"partners" withType:@"GET" withCompletion:^(NSDictionary *response) {
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"partners" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];

        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        
        for (id object in json) {
            Sponsor *newSponsor = [[Sponsor alloc] init];
            
            newSponsor.serverID = [NSString stringWithFormat:@"%@%@", [object[@"website"] MD5], [object[@"name"] MD5]];
            newSponsor.name = object[@"name"];
            newSponsor.logoImage = object[@"logoImage"];
            newSponsor.website = object[@"website"];
            newSponsor.level = [object[@"level"] integerValue];
            
            [realm beginWriteTransaction];
            [realm addOrUpdateObject:newSponsor];
            [realm commitWriteTransaction];
        }
        
        completion(YES);
    }];
}

- (void)refreshEvents:(void(^)(BOOL success))completion {
    [self sendRequest:nil toEndpoint:@"events.php" withType:@"GET" withCompletion:^(NSDictionary *response) {

        RLMRealm *realm = [RLMRealm defaultRealm];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd kk:mm:ss"];
        
        if (response[@"success"]) {
            for (id object in response[@"data"][@"data"]) {
                Event *newEvent = [[Event alloc] init];
                newEvent.serverID = [object[@"eventsList"][0][@"id"] stringValue];
                newEvent.name = object[@"eventsList"][0][@"name"];
                newEvent.desc = object[@"eventsList"][0][@"description"];
                newEvent.imageURL = object[@"eventsList"][0][@"imageUrl"];
                newEvent.startDate = [dateFormat dateFromString:object[@"eventsList"][0][@"startDate"]];
                newEvent.endDate = [dateFormat dateFromString:object[@"eventsList"][0][@"endDate"]];
    
                Location *newLocation = [[Location alloc] init];
                newLocation.building = object[@"eventsList"][0][@"location"][@"building"];
                newLocation.level = object[@"eventsList"][0][@"location"][@"level"];
                newLocation.room = object[@"eventsList"][0][@"location"][@"room"];
    
                newEvent.location = newLocation;
                              
                [realm beginWriteTransaction];
                [Event createOrUpdateInRealm:realm withValue:newEvent];
                [realm commitWriteTransaction];
            }
            completion(YES);
        }
        
    }];
}

- (void)sendRequest:(NSDictionary *)request
         toEndpoint:(NSString *)endpoint
           withType:(NSString *)type
     withCompletion:(void(^)(NSDictionary *response))completion {

    NSString *requestURL = [kHTXBaseURL stringByAppendingString:endpoint];

    if ([type isEqualToString:@"GET"]) {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [manager GET:requestURL parameters:request progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            completion(@{@"success": @YES, @"data": responseObject});
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            completion(@{@"success": @NO, @"error": error});
        }];
        
    } else if ([type isEqualToString:@"POST"]) {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [manager POST:requestURL parameters:request progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            completion(@{@"success": @YES, @"data": responseObject});
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            completion(@{@"success": @NO, @"error": error});
        }];
        
    }
    
}

@end
