//
//  AppDelegate.m
//  Track My Kid
//
//  Created by Vijayant Palaiya on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "FirstTimeWelcomeViewController.h"
#import "KidHomeViewController.h"
#import "ParentHomeViewController.h"
#import "PersistentApplicationData.h"
#import "SingleAppDataObject.h"
#import "Utility.h"

#import <Dropbox/Dropbox.h>

@interface AppDelegate ()

@property (strong,nonatomic)UIStoryboard* storyboard;

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize storyboard;
@synthesize navController;
@synthesize dropBoxUserId;
@synthesize persistentApplicationData;
@synthesize theAppDataObject;

- (id) init;
{
	self.theAppDataObject = [[SingleAppDataObject alloc] init];
	return [super init];
}

#pragma mark -
#pragma mark Application lifecycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Set these variables before launching the app
    NSString* appKey = @"c8wujfmsu21fd47";
	NSString* appSecret = @"g3lcg4ack6ehzux";
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
    
    DBAccountManager *mgr =
    [[DBAccountManager alloc] initWithAppKey:appKey secret:appSecret];
    [DBAccountManager setSharedManager:mgr];
    
    storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    UINavigationController *root = [storyboard instantiateInitialViewController];
    self.window.rootViewController = root;
    
    //
    // get data from persistent layer
    //
    persistentApplicationData = [Utility readFromArchive];
    [self setFirstViewController];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

//
// set first view controller for the root view controller (which is nav controller)
//
- (void) setFirstViewController
{
    UINavigationController *root = (UINavigationController*)self.window.rootViewController;
    if(persistentApplicationData == nil)
    {
        D2Log(@"cAD is null");
        persistentApplicationData = [[PersistentApplicationData alloc] init];
    }
    else
    {
        D2Log(@"cAD is not null");
        D2Log(@"cAD: %d %d %@", persistentApplicationData.version, persistentApplicationData.kidOrParent, persistentApplicationData.personName);
    }
    
    if([DBAccountManager sharedManager].linkedAccount == nil)
    {
        // If custom application data doesn't have valid value for kid or parent, then show first time welcome page
        FirstTimeWelcomeViewController *first = [storyboard instantiateViewControllerWithIdentifier:@"FirstTimeWelcomeViewController"];
        root.viewControllers = [NSArray arrayWithObjects:first, nil];
        return;
    }
    
    if (persistentApplicationData.kidOrParent == kKidKeyValue)
    {
        // If custom application data has kid value, then show kid home page
        KidHomeViewController *kidHome = [storyboard instantiateViewControllerWithIdentifier:@"KidHomeViewController"];
        root.viewControllers = [NSArray arrayWithObjects:kidHome, nil];
        return;
    }
    else if (persistentApplicationData.kidOrParent == kParentKeyValue)
    {
        // If custom application data has parent value, then show parent home page
        ParentHomeViewController *parentHome = [storyboard instantiateViewControllerWithIdentifier:@"ParentHomeViewController"];
        root.viewControllers = [NSArray arrayWithObjects:parentHome, nil];
        return;
    }
    else
    {
        // If custom application data doesn't have valid value for kid or parent, then show first time welcome page
        FirstTimeWelcomeViewController *first = [storyboard instantiateViewControllerWithIdentifier:@"FirstTimeWelcomeViewController"];
        root.viewControllers = [NSArray arrayWithObjects:first, nil];
        return;
    }
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    DBAccount* account = [[DBAccountManager sharedManager] handleOpenURL:url];
    if(account)
    {
        D2Log(@"App linked successfully");
        return YES;
    }
    
    return NO;
}

//- (BOOL)application:(UIApplication *)application xxxdidFinishLaunchingWithOptions:(NSDictionary *)launchOptions
//{
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//
//    // Override point for customization after application launch.
//
//    /*
//     * Initialize DropBox session
//     */
//
//    // Set these variables before launching the app
//    NSString* appKey = @"c8wujfmsu21fd47";
//	NSString* appSecret = @"g3lcg4ack6ehzux";
//	NSString *root = kDBRootAppFolder; // Should be set to either kDBRootAppFolder or kDBRootDropbox
//
//	DBSession* dbSession = [[DBSession alloc] initWithAppKey:appKey appSecret:appSecret root:root];
//	dbSession.delegate = self; // DBSessionDelegate methods allow you to handle re-authenticating
//	[DBSession setSharedSession:dbSession];
//	//[dbSession release];
//
//    BOOL isLinked = [[DBSession sharedSession] isLinked];
//
//    self.navController = [[UINavigationController alloc]init];
//
//    // If drop box is not linked, then show first time welcome page
//    if(!isLinked)
//    {
//        D2Log(@"first time");
//        FirstTimeWelcomeViewController *first = [[FirstTimeWelcomeViewController alloc] init];
//        //        self.navController = [[UINavigationController alloc] initWithRootViewController:first];
//        [self.navController pushViewController:first animated:YES];
//    }
//    else
//    {
//        persistentApplicationData = [Utility readFromArchive];
//        if(persistentApplicationData == nil)
//        {
//            D2Log(@"cAD is null");
//            persistentApplicationData = [[PersistentApplicationData alloc] init];
//
//            // If no custom application data is found, then show first time welcome page
//            FirstTimeWelcomeViewController *first = [[FirstTimeWelcomeViewController alloc] init];
//            //            self.navController = [[UINavigationController alloc] initWithRootViewController:first];
//            [self.navController pushViewController:first animated:YES];
//        }
//        else
//        {
//            D2Log(@"cAD is not null");
//            D2Log(@"cAD: %d %d %@", persistentApplicationData.version, persistentApplicationData.kidOrParent, persistentApplicationData.personName);
//
//            if (persistentApplicationData.kidOrParent == kKidKeyValue)
//            {
//                // If custom application data has kid value, then show kid home page
//                KidHomeViewController *kidHome = [[KidHomeViewController alloc] init];
//                //                self.navController = [[UINavigationController alloc] initWithRootViewController:kidHome];
//                [self.navController pushViewController:kidHome animated:YES];
//            }
//            else if (persistentApplicationData.kidOrParent == kParentKeyValue)
//            {
//                // If custom application data has parent value, then show parent home page
//                ParentHomeViewController *parentHome = [[ParentHomeViewController alloc] init];
//                //                self.navController = [[UINavigationController alloc] initWithRootViewController:parentHome];
//                [self.navController pushViewController:parentHome animated:YES];
//            }
//            else
//            {
//                // If custom application data doesn't have valid value for kid or parent, then show first time welcome page
//                FirstTimeWelcomeViewController *first = [[FirstTimeWelcomeViewController alloc] init];
//                //                self.navController = [[UINavigationController alloc] initWithRootViewController:first];
//                [self.navController pushViewController:first animated:YES];
//            }
//        }
//    }
//
//    [self.window addSubview:navController.view];
//
//    self.window.backgroundColor = [UIColor lightGrayColor];
//    [self.window makeKeyAndVisible];
//    return YES;
//}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    D2Log(@"will resign active");
    [Utility storeIntoArchive:persistentApplicationData];
    
}

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//	NSLog(@"In handleOpenURL");
//
//    if ([[DBSession sharedSession] handleOpenURL:url]) {
//        if ([[DBSession sharedSession] isLinked]) {
//            NSLog(@"App linked successfully!");
//            // At this point you can start making API calls
//        }
//        return YES;
//    }
//    // Add whatever other url handling code your app requires here
//    return NO;
//}
//
//#pragma mark -
//#pragma mark DBSessionDelegate methods
//
//- (void)sessionDidReceiveAuthorizationFailure:(DBSession*)session userId:(NSString *)userId
//{
//	NSLog(@"In sessionDidReceiveAuthorizationFailure!");
//
//	dropBoxUserId = userId;
//
//	UIAlertView *alertView = [[UIAlertView alloc]
//                              initWithTitle:@"Dropbox Session Ended"
//                              message:@"Do you want to relink?"
//                              delegate:self
//                              cancelButtonTitle:@"Cancel"
//                              otherButtonTitles:@"Relink", nil];
//    [alertView show];
//}
//
//
//#pragma mark -
//#pragma mark UIAlertViewDelegate methods
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index
//{
//	NSLog(@"In clickedButtonAtIndex!");
//
//    //[self.navController popToViewController:<#(UIViewController *)#> animated:YES];
//
//	if (index != alertView.cancelButtonIndex)
//    {
//        // TODO		[[DBSession sharedSession] linkUserId:dropBoxUserId];
//	}
//}
//

@end
