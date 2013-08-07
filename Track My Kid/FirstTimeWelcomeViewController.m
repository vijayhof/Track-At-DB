//
//  FirstTimeWelcomeViewController.m
//  Track My Kid
//
//  Created by Vijayant Palaiya on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstTimeWelcomeViewController.h"
#import "Constants.h"
#import "Utility.h"


@implementation FirstTimeWelcomeViewController


#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Welcome";
}

#pragma mark - Actions
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"linkParent"])
    {
        [Utility sharedAppDelegate].persistentApplicationData.kidOrParent = kParentKeyValue;
        [Utility sharedAppDelegate].persistentApplicationData.personName = nil;
	}
	else if ([segue.identifier isEqualToString:@"linkKid"])
    {
        [Utility sharedAppDelegate].persistentApplicationData.kidOrParent = kKidKeyValue;
        [Utility sharedAppDelegate].persistentApplicationData.personName = nil;
	}
	else if ([segue.identifier isEqualToString:@"MorePage"])
    {
	}
}


@end
