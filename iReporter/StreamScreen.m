//
//  StreamScreen.m
//  iReporter
//
//  Created by Marin Todorov on 10/02/2012.
//  Copyright (c) 2012 Marin Todorov. All rights reserved.
//

#import "StreamScreen.h"

@implementation StreamScreen

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"iReporter stream";
    self.navigationItem.rightBarButtonItem = btnCompose;
    self.navigationItem.leftBarButtonItem = btnRefresh;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)btnRefreshTapped
{
    
}

@end
