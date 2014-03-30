//
//  PRAAppDelegate.m
//  praqtic_ios
//
//  Created by Charles Forkish on 3/29/14.
//  Copyright (c) 2014 Praqtic. All rights reserved.
//

#import "PRAAppDelegate.h"
#import "PRAItemStore.h"
#import "PRAItemsViewController.h"
#import "PRAFactViewController.h"

@implementation PRAAppDelegate

- (BOOL)application:(UIApplication *)application
shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

- (BOOL)application:(UIApplication *)application
shouldRestoreApplicationState:(NSCoder *)coder
{
    return NO;
}

- (BOOL)application:(UIApplication *)application
willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // If state restoration did not occur,
    // set up the view controller hierarchy
    if (!self.window.rootViewController) {
        
        PRAItemsViewController *itemsViewController = [[PRAItemsViewController alloc] init];
        
        // Create an instance of a UINavigationController
        // Its stack contains only itemsViewController
        UINavigationController *navController = [[UINavigationController alloc]
                                                 initWithRootViewController:itemsViewController];
        
        // Give the navigation controller a restoration identifier that is
        // the same name as the class
        navController.restorationIdentifier = NSStringFromClass([navController class]);
        navController.tabBarItem.title = @"Items";
        
        
        PRAFactViewController *factVC = [[PRAFactViewController alloc] initWithItem:[[PRAItemStore sharedStore] nextItem]];
        
        UINavigationController *feedNavCon = [[UINavigationController alloc] initWithRootViewController:factVC];
        feedNavCon.restorationIdentifier = NSStringFromClass([feedNavCon class]);
        feedNavCon.tabBarItem.title = @"Feed";
        
        UITabBarController *tbc = [[UITabBarController alloc] init];
        tbc.viewControllers = @[feedNavCon, navController];
        tbc.restorationIdentifier = NSStringFromClass([tbc class]);
        
        
        // Place navigation controller's view in the window hierarchy
        self.window.rootViewController = tbc;
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    BOOL success = [[PRAItemStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"Saved all of the PRAItems");
    }
    else {
        NSLog(@"Could not save any of the PRAItems");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (UIViewController *)application:(UIApplication *)application
viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents
                            coder:(NSCoder *)coder
{
    // Create a new navigation controller
    UIViewController *vc = [[UINavigationController alloc] init];
    
    // The last object in the path array is the restoration
    // identifier for this view controller
    vc.restorationIdentifier = [identifierComponents lastObject];
    
    // If there is only 1 identifier component, then
    // this is the root view controller
    if ([identifierComponents count] == 1) {
        self.window.rootViewController = vc;
    }
    
    return vc;
}

@end
