//
//  AppDelegate.m
//  DataCollection
//
//  Created by Jeff Behrbaum on 10/5/15.
//  Copyright © 2015 Apio Systems. All rights reserved.
//

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#import "AppDelegate.h"
#import "CentralManager.h"

@interface AppDelegate ()
	@property(nonatomic) BOOL bAmBackgrounded;
	@property(nonatomic) UIBackgroundTaskIdentifier bgTask;
	@property (nonatomic, strong) NSOperationQueue* operationQueue;
@end

@implementation AppDelegate

@synthesize bgTask = _bgTask;
@synthesize operationQueue = _operationQueue;
@synthesize bAmBackgrounded = _bAmBackgrounded;

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[Fabric with:@[[Crashlytics class]]];
	//[Fabric with:@[[Crashlytics]]];

	
	[UIApplication sharedApplication].idleTimerDisabled = TRUE;

	return YES;
}

-(void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary
	//interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

-(void)applicationDidEnterBackground:(UIApplication *)application
{
	self.bAmBackgrounded = TRUE;

	_bgTask = [application beginBackgroundTaskWithExpirationHandler: ^{
		dispatch_async(dispatch_get_main_queue(), ^{
			// Wait until the pending operations finish
			[[NSOperationQueue mainQueue] waitUntilAllOperationsAreFinished];
			[application endBackgroundTask:_bgTask];
			_bgTask = UIBackgroundTaskInvalid;
		});
	}];
}

-(void)applicationWillEnterForeground:(UIApplication *)application
{
	self.bAmBackgrounded = FALSE;
}

-(void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

-(void)applicationWillTerminate:(UIApplication *)application
{
	//Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	@try
	{
		[[CentralManager theCentral] disconnectAllBTPeripherals];
	}
	@catch(NSException *exception)
	{}
}

@end
