 //
//  LoginScreen.m
//  iReporter
//
//  Created by Marin Todorov on 09/02/2012.
//  Copyright (c) 2012 Marin Todorov. All rights reserved.
//

#import "API.h"
#include <CommonCrypto/CommonDigest.h>
#define kSalt @"fdjasfoi12kljfdasoifjisfdo"

#import "LoginScreen.h"
#import "UIAlertView+error.h"

@implementation LoginScreen

#pragma mark - View lifecycle

- (void) viewDidLoad{
    [super viewDidLoad];
    [fldUsername becomeFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)btnLoginRegisterTapped:(UIButton*)sender
{
    if(fldUsername.text.length < 4 || fldPassword.text.length < 4){
        [UIAlertView error:@"enter username and password over 4 chars each"];
        return ;
    }
    
    NSString* saltedPassword = [NSString stringWithFormat:@"%@%@", fldPassword.text, kSalt];
    
    NSString* hashedPassword = nil;
    unsigned char hashedPasswordData[CC_SHA1_DIGEST_LENGTH];
    
    NSData *data = [saltedPassword dataUsingEncoding: NSUTF8StringEncoding];
    if(CC_SHA1([data bytes], [data length], hashedPasswordData)){
        hashedPassword = [[NSString alloc]initWithBytes:hashedPasswordData length:sizeof(hashedPasswordData) encoding:NSASCIIStringEncoding];
    }else{
        [UIAlertView error:@"password can't be sent"];
        return;
    }
    
    NSString* command = (sender.tag == 1) ? @"register" : @"login";
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   command, @"command",
                                   fldUsername.text, @"username",
                                   hashedPassword, @"password",
                                   nil];
    [[API sharedInstance] commandWithParams:params
                               onCompletion:^(NSDictionary *json){
                                   NSLog(@"%@", json);
                                   NSDictionary* res = [[json objectForKey:@"result"] objectAtIndex:0];
                                   if([json objectForKey:@"error"] == nil && [[res objectForKey:@"IdUser"] intValue] > 0){
                                       //success
                                       [[API sharedInstance] setUser:res];
                                       [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                                       [[[UIAlertView alloc] initWithTitle:@"Logged in"
                                                                  message:[NSString stringWithFormat:@"Welcome %@",
                                                                           [res objectForKey:@"username"]]
                                                                 delegate:nil
                                                        cancelButtonTitle:@"Close"
                                                         otherButtonTitles:nil] show];
                                   }else{
                                       //error
                                       [UIAlertView error:[json objectForKey:@"error"]];
                                   }
                               }];
    
}

@end
