
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#import "CAppDelegate.h"
#import "CentralManager.h"

@interface CAppDelegate()
    @property(nonatomic) BOOL bAmBackgrounded;
    @property(nonatomic) UIBackgroundTaskIdentifier bgTask;

@end

@implementation CAppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[Fabric with:@[[Crashlytics class]]];
	[UIApplication sharedApplication].idleTimerDisabled = YES;

	// Override point for customization after application launch.
	return YES;
}

-(void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
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
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	[UIApplication sharedApplication].idleTimerDisabled = YES;
}

-(void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive.
	//If the application was previously in the background, optionally refresh the user interface.
}

-(void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate.
	//See also applicationDidEnterBackground:.
	
	@try
	{
		[[CentralManager theCentral] disconnectAllBTPeripherals];
	}
	@catch(NSException *exception)
	{}
	@finally
	{}
}

@end
