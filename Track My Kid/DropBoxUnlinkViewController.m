//
//  DropBoxUnlinkViewController.m
//  Track My Kid
//
//  Created by Vijayant Palaiya on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Dropbox/Dropbox.h>

#import "DropBoxUnlinkViewController.h"
#import "FirstTimeWelcomeViewController.h"
#import "Utility.h"

@implementation DropBoxUnlinkViewController

#pragma mark - Actions

- (IBAction)didPressDropBoxUnlink:(id)sender
{
    NSLog(@"In dP1: didPressDropBoxUnlink");
    
    [[[DBAccountManager sharedManager] linkedAccount] unlink];
    (void)[[Utility sharedAppDelegate].persistentApplicationData init];
    
    [[Utility sharedAppDelegate] setFirstViewController];

    
    //        self.store = nil;
    //
    //        [self.tableView reloadData];
    
    //
    //    // If DropBox is linked, then unlink
    //    if ([[DBSession sharedSession] isLinked])
    //    {
    //        NSLog(@"In dP4: Already linked. Unlink it");
    //
    //        [[DBSession sharedSession] unlinkAll]; // TODO remove later
    //
    //        // If here, then DropBox is unlinked
    //        UIAlertView *alertViewSuccess = [[UIAlertView alloc]
    //                                         initWithTitle:@"Account unlinked!"
    //                                         message:@"Your dropbox account has been unlinked"
    //                                         delegate:nil
    //                                         cancelButtonTitle:@"OK"
    //                                         otherButtonTitles:nil];
    //        [alertViewSuccess show];
    //    }
    //    else
    //    {
    //        // If here, then DropBox is not linked. No need to unlink
    //        UIAlertView *alertViewSuccess = [[UIAlertView alloc]
    //                                         initWithTitle:@"Account not linked!"
    //                                         message:@"Your dropbox account has already been unlinked"
    //                                         delegate:nil
    //                                         cancelButtonTitle:@"OK"
    //                                         otherButtonTitles:nil];
    //        [alertViewSuccess show];
    //    }
    //
    //    FirstTimeWelcomeViewController * vc = [[FirstTimeWelcomeViewController alloc] init];
    //    NSArray *vcArr = [NSArray arrayWithObject:vc];
    //    [self.navigationController setViewControllers:vcArr];
    
}


@end
