//
//  AppDelegate.m
//  IndigoProject
//
//  Created by Felipe Sabino on 3/28/11.
//  Copyright 2011 I.ndigo. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeController_iPhone.h"
#import "HomeController_iPad.h"

//#define LOGDEVICEFONTS

@implementation AppDelegate

@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window =  [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    
    
    
#ifdef LOGDEVICEFONTS
	
	//	Logs al available fonts in system
	for (NSString *family in [UIFont familyNames]) {
		NSArray *fonts = [UIFont fontNamesForFamilyName:family];
		NSString *font;
		for (font in fonts) {
			//UIFont *ttf = [UIFont fontWithName:font size:10.0];
			//NSLog(@"family: %@; font: %@, ttf: %@", family, font, ttf);
            NSLog(@"font: %@", font);
            
		}
	}
	
#endif
    
#ifndef DISABLE_GOOGLE_ANALYTICS
    
    [[GANTracker sharedTracker] startTrackerWithAccountID:GOOGLE_ANALYTIC_KEY
                                           dispatchPeriod:10
                                                 delegate:nil];
	NSString *bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];

    
#endif
    

    NSError *error;

    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
	{
        
#ifndef DISABLE_GOOGLE_ANALYTICS
      
        if (![[GANTracker sharedTracker] setCustomVariableAtIndex:1
                                                             name:@"iPad"
                                                            value:bundleVersion
                                                        withError:&error]) {
            NSLog(@"error in google analytics setCustomVariableAtIndex");
        }
        
        
        if (![[GANTracker sharedTracker] trackEvent:@"Application iPad"
                                             action:@"Launch iPad"
                                              label:@"iPad App Launched"
                                              value:999
                                          withError:&error]) {
            NSLog(@"error in trackEvent");
        }
        
#endif
        
		HomeController_iPhone *homeController = [[HomeController_iPhone alloc] init];
		root = [[UINavigationController alloc] initWithRootViewController:homeController];
        [homeController release];
		[_window addSubview:root.view];
        
    } else {
        
#ifndef DISABLE_GOOGLE_ANALYTICS
        
        if (![[GANTracker sharedTracker] setCustomVariableAtIndex:1
                                                             name:@"iPhone"
                                                            value:bundleVersion
                                                        withError:&error]) {
            NSLog(@"error in google analytics setCustomVariableAtIndex");
        }
        
        if (![[GANTracker sharedTracker] trackEvent:@"Application iPhone"
                                             action:@"Launch iPhone"
                                              label:@"iPhone App Launched"
                                              value:999
                                          withError:&error]) {
            NSLog(@"error in trackEvent");
        }
        
#endif
        
        HomeController_iPad *homeController = [[HomeController_iPad alloc] init];
        root = [[UINavigationController alloc] initWithRootViewController:homeController];
        [homeController release];
        [_window addSubview:root.view];
    }

    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
