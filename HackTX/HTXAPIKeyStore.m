//
//  HTXAPIKeyStore.m
//  HackTX
//
//  Created by Jose Bethancourt on 10/12/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import "HTXAPIKeyStore.h"

@interface HTXAPIKeyStore()

@property (nonatomic, strong) NSDictionary *apiKeys;

@end

@implementation HTXAPIKeyStore

+ (instancetype)sharedHTXAPIKeyStore {
    static dispatch_once_t once;
    static HTXAPIKeyStore *_sharedInstance;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"APIKeys" ofType: @"plist"];
    self.apiKeys = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    return self;
}

- (NSString *)getGMSKey {
    return self.apiKeys[@"gms_key"];
}

@end
