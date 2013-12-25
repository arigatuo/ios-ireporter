//
//  PhotoScreen.m
//  iReporter
//
//  Created by Marin Todorov on 09/02/2012.
//  Copyright (c) 2012 Marin Todorov. All rights reserved.
//

#import "PhotoScreen.h"
#import "API.h"

@implementation PhotoScreen

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Custom initialization
    self.navigationItem.rightBarButtonItem = btnAction;
    self.navigationItem.title = @"Post photo";
    
    if(![[API sharedInstance] isAuthorized]){
        [self performSegueWithIdentifier:@"ShowLogin" sender:nil];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - menu

-(IBAction)btnActionTapped:(id)sender
{

}

@end
