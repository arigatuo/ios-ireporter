//
//  API.m
//  iReporter
//
//  Created by lady8844 on 13-12-24.
//  Copyright (c) 2013年 Marin Todorov. All rights reserved.
//

#import "API.h"
#define kAPIHost @"http://192.168.0.124/"
#define kAPIPath @"ios/iReporter/"

@implementation API

@synthesize user;
#pragma mark - Singleton methods
+(API*)sharedInstance
{
    static API *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:kAPIHost]];
    });
    return sharedInstance;
}

#pragma mark - init
-(API*)init
{
    self = [super init];
    
    if(self != nil){
        user = nil;
        
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    
    return self;
}

-(BOOL)isAuthorized
{
    return [[user objectForKey:@"IdUser"] intValue] > 0;
}

-(void)commandWithParams:(NSMutableDictionary*)params onCompletion:(JSONResponseBlock)completionBlock
{
    NSLog(@"%@", params);
    NSData* uploadFile = nil;
    if([params objectForKey:@"file"]){
        uploadFile = (NSData*)[params objectForKey:@"file"];
        [params removeObjectForKey:@"file"];
    }
    NSMutableURLRequest *apiRequest =
    [self multipartFormRequestWithMethod:@"POST"
                                    path:kAPIPath
                              parameters:params
               constructingBodyWithBlock:^(id <AFMultipartFormData>formData){
                   //todo attach file if needed
                   if(uploadFile){
                       [formData appendPartWithFileData:uploadFile
                                                   name:@"file"
                                               fileName:@"photo.jpg"
                                               mimeType:@"image/jpeg"];
                   }
               }];
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: apiRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    [operation start];
}

-(NSURL*)urlForImageWithId:(NSNumber*)IdPhoto isThumb:(BOOL)isThumb{
    NSString* urlString = [NSString stringWithFormat:@"%@/%@upload/%@%@.jpg",
                           kAPIHost,kAPIPath,IdPhoto,(isThumb) ? @"-thumb" : @""];
    return [NSURL URLWithString:urlString];
}

@end
