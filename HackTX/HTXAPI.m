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
    
    [manager GET:@"https://hacktx.joseb.me/pass" parameters:@{@"email": email} progress:nil success:^(NSURLSessionTask *task, NSData *responseObject) {
        passData(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"%% %@", error);
    }];

}

- (void)fetchHacker:(NSString *)email
   withCompletion:(void(^)(NSDictionary *data))completion {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:@"https://hacktx.joseb.me/checkin" parameters:@{@"email": email} progress:nil success:^(NSURLSessionTask *task, NSData *responseObject) {
        completion(@{@"success": @YES, @"data": responseObject});
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        completion(@{@"success": @NO, @"error": error});
    }];
    
}

- (void)refreshAnnouncements:(void(^)(BOOL success))completion {
    [self sendRequest:nil toEndpoint:@"announcements" withType:@"GET" withCompletion:^(NSDictionary *response) {

        RLMRealm *realm = [RLMRealm defaultRealm];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd kk:mm:ss"];

        if ([response[@"success"] boolValue]) {
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
        } else {
            completion(NO);
        }
    }];
}

- (void)refreshSponsors:(void(^)(BOOL success))completion {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:@"https://hacktx.joseb.me/sponsors" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        for (id object in responseObject) {
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
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        completion(NO);
    }];
}

- (void)refreshEvents:(void(^)(BOOL success))completion {
    [self sendRequest:nil toEndpoint:@"schedule" withType:@"GET" withCompletion:^(NSDictionary *response) {

        RLMRealm *realm = [RLMRealm defaultRealm];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd kk:mm:ss"];
        
        if ([response[@"success"] boolValue]) {
            for (id object in response[@"data"]) {
                
                for (id eventObject in object[@"eventsList"]) {
                    Event *newEvent = [[Event alloc] init];
                    newEvent.serverID = [eventObject[@"id"] stringValue];
                    newEvent.name = eventObject[@"name"];
                    newEvent.desc = eventObject[@"description"];
                    newEvent.imageURL = eventObject[@"imageUrl"];
                    newEvent.startDate = [dateFormat dateFromString:eventObject[@"startDate"]];
                    newEvent.endDate = [dateFormat dateFromString:eventObject[@"endDate"]];
                    
                    Location *newLocation = [[Location alloc] init];
                    newLocation.building = eventObject[@"location"][@"building"];
                    newLocation.level = eventObject[@"location"][@"level"];
                    newLocation.room = eventObject[@"location"][@"room"];
                    
                    newEvent.location = newLocation;
                    
                    [realm beginWriteTransaction];
                    [Event createOrUpdateInRealm:realm withValue:newEvent];
                    [realm commitWriteTransaction];
                }
            }
            completion(YES);
        } else {
            completion(NO);
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
