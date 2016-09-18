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
#import "Sponsor.h"
#import "Event.h"


@implementation HTXAPI

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (void)refreshEvents:(void(^)(NSDictionary *response))completion {
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

- (void)refreshSponsors:(void(^)(BOOL success))completion {
    [self sendRequest:nil toEndpoint:@"sponsors" withType:@"GET" withCompletion:^(NSDictionary *response) {
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        NSData *data = [@"[{\"name\":\"ForeverCard\", \"logoImage\": \"https://forevercard.co\", \"website\": \"https://forevercard.co\", \"level\": 1},{\"name\":\"Google\", \"logoImage\": \"https://forevercard.co\", \"website\": \"https://google.com\", \"level\": 2}]" dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        
        for (id object in json) {
            Sponsor *newSponsor = [[Sponsor alloc] init];
            newSponsor.id = [object[@"website"] MD5];
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

- (void)refreshEvents:(void(^)(NSDictionary *response))completion {
    [self sendRequest:nil toEndpoint:@"events.php" withType:@"GET" withCompletion:^(NSDictionary *response) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        NSData *data = [@"{\"id\": 1, \"name\": \"Jose\", \"desc\": \"swag bucks\", \"imageURL\": \"https://gogole.com\", \"startDate\": \"today\", \"endDate\": \"tomorrow\", \"location\":{\"building\": \"RLM\", \"level\": \"3\", \"room\": \"3.124\"}, \"speakers\":[{\"id\":32131, \"name\":\"Jason\",\"organization\":\"entefy\",\"desc\": \"10-year old\", \"imageURL\": \"https://facebook.com\"}]}" dataUsingEncoding: NSUTF8StringEncoding];
        
        [realm transactionWithBlock:^{
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            [Event createOrUpdateInRealm:realm withValue:json];
        }];
//        if (response[@"success"]) {
//            for (id object in response[@"data"]) {
//                
//                //            Event *newEvent = [[Event alloc] init];
//                //            newEvent.id = object[@"id"];
//                //            newEvent.name = object[@"name"];
//                //            newEvent.desc = object[@"desc"];
//                //            newEvent.imageURL = object[@"imageURL"];
//                //            newEvent.startDate = [NSDate dateWithTimeIntervalSince1970:object[@"startDate"]];
//                //            newEvent.endDate = [NSDate dateWithTimeIntervalSince1970:object[@"endDate"]];
//                //
//                //            Location *newLocation = [[Location alloc] init];
//                //            newLocation.building = object[@"location"][@"building"];
//                //            newLocation.level = object[@"location"][@"level"];
//                //            newLocation.room = object[@"location"][@"room"];
//                //
//                //            newEvent.location = newLocation;
//                //
//                
//                [realm beginWriteTransaction];
//                [Event createOrUpdateInRealm:realm withValue:object];
//                [realm commitWriteTransaction];
//            }
//        }
//        completion(response);
    }];
}

- (void)sendRequest:(NSDictionary *)request
         toEndpoint:(NSString *)endpoint
           withType:(NSString *)type
     withCompletion:(void(^)(NSDictionary *response))completion {
    
    NSString *requestURL = [NSString stringWithFormat:KHTXBaseURL, endpoint];
    
    if ([type isEqualToString:@"GET"]) {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [manager GET:requestURL parameters:request progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"%@", responseObject);
            completion(@{@"success": @YES, @"data": responseObject});
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"%@", error);
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
