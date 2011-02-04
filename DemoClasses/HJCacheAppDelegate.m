//
//  HJCacheAppDelegate.m
//  HJCache
//
//  Created by Mark Johnson on 1/15/11.
//  Copyright 2011 na. All rights reserved.
//

#import "HJCacheAppDelegate.h"
#import "RootViewController.h"
#import "FlickrSearchTVC.h"
#import "HJCircularBuffer.h"
#import "HJWeakMutableArray.h"
#import "ImgTVC.h"


@implementation HJCacheAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	
	//[HJCircularBuffer test];
	//[HJWeakMutableArray test];
	
	//*************************************************************
	// uncomment one of the view controllers below to demo HJManObj
	
	// this simple demo shows managed images being used to load, cache, and show images from Flickr
	//FlickrSearchTVC* flickrTVC = [[[FlickrSearchTVC alloc] initWithNibName:@"FlickrSearchTVC"
	//																bundle:nil] autorelease];

	RootViewController* rootVC = [[[RootViewController alloc] init] autorelease];
	rootVC.title = @"Demo Menu";
	
	navigationController = [[UINavigationController alloc] initWithRootViewController:rootVC];
	
	// this simple demo shows how managed images can be shared and reused in the same table
	//ImgTVC* imgTVC = [[[ImgTVC alloc] initWithNibName:@"ImgTVC" bundle:nil] autorelease];
	//navigationController = [[UINavigationController alloc] initWithRootViewController:imgTVC];
	
	//*************************************************************
	
	[window addSubview:navigationController.view];
    [window makeKeyAndVisible];
	
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

