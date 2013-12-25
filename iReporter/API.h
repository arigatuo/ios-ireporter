//
//  API.h
//  iReporter
//
//  Created by lady8844 on 13-12-24.
//  Copyright (c) 2013年 Marin Todorov. All rights reserved.
//

#import "AFHTTPClient.h"
#import "AFNetworking.h"
typedef void(^JSONResponseBlock)(NSDictionary* json);

@interface API : AFHTTPClient
@property(strong, nonatomic) NSDictionary* user;
+(API*)sharedInstance;
-(BOOL)isAuthorized;
-(void)commandWithParams:(NSMutableDictionary*)params onCompletion:(JSONResponseBlock)completionBlock;
@end
