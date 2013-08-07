//
//  DropBoxLinkViewController.m
//  Track My Kid
//
//  Created by Vijayant Palaiya on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Dropbox/Dropbox.h>

#import "DropBoxLinkViewController.h"
#import "KidHomeViewController.h"
#import "ParentHomeViewController.h"
#import "Utility.h"

@implementation DropBoxLinkViewController

@synthesize nameTextField;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Link to DropBox";
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	__weak DropBoxLinkViewController *slf = self;
	[self.accountManager addObserver:self block:^(DBAccount *account) {
		[slf setupTasks];
	}];
	
	[self setupTasks];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    
	[self.accountManager removeObserver:self];
    //	if (_store) {
    //		[_store removeObserver:self];
    //	}
    //	self.store = nil;
}

- (void)viewDidUnload
{
    [self setNameTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Actions
- (IBAction)nameTextFieldDoneEditing:(id)sender
{
    D2Log(@"In dP1:nameTextFieldDoneEditing");
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender
{
    [nameTextField resignFirstResponder];
}


- (IBAction)didPressDropBoxLink:(id)sender
{
    D2Log(@"In dP1: didPressDropBoxLink");
    
    // check if account is already linked
    DBAccount* account = [[DBAccountManager sharedManager] linkedAccount];
    if(account)
    {
        D2Log(@"App already linked");
        [self setupTasks];
        return;
    }
    
    //
    // Do validation of name string
    //
    NSString* nameStr = nameTextField.text;
    if([allTrim(nameStr) length] == 0)
    {
        UIAlertView *alertView1 = [[UIAlertView alloc]
                                   initWithTitle:@"Choose a Name"
                                   message:@"Please enter name to link to DropBox"
                                   delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
        [alertView1 show];
        return;
    }
    
    //
    // name string validated
    //
    // TODO move the check for linked account before the alert
    else
    {
        [[DBAccountManager sharedManager] linkFromController:self];
    }
    
    
}

#pragma mark - private methods

- (DBAccount *)account
{
	return [DBAccountManager sharedManager].linkedAccount;
}

- (DBAccountManager *)accountManager
{
	return [DBAccountManager sharedManager];
}

//- (DBDatastore *)store
//{
//	if (!_store) {
//		_store = [DBDatastore openDefaultStoreForAccount:self.account error:nil];
//	}
//	return _store;
//}
//

- (void)setupTasks
{
    D2Log(@"In setupTasks");
    
	if (self.account)
    {
        
        NSString* nameStr = nameTextField.text;
        
        [Utility sharedAppDelegate].persistentApplicationData.personName = nameStr;
        [[Utility sharedAppDelegate] setFirstViewController];
        
        
        //		__weak TasksController *slf = self;
        //		[self.store addObserver:self block:^ {
        //			if (slf.store.status & (DBDatastoreIncoming | DBDatastoreOutgoing)) {
        //				NSDictionary *changed = [slf.store sync:nil];
        //				[slf update:changed];
        //			}
        //		}];
        //		_tasks = [NSMutableArray arrayWithArray:[[self.store getTable:@"tasks"] query:nil error:nil]];
        
    }
    else
    {
        //		_store = nil;
        //		_tasks = nil;
	}
    //	[self.tableView reloadData];
}



@end
