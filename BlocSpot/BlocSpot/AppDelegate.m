//
//  AppDelegate.m
//  BlocSpot
//
//  Created by MELANIE MCGANNEY on 9/16/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "AppDelegate.h"
#import "Category.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Seed Categories so user knows what to do from that entry point
    [self seedCategories];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)seedCategories {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    if (![ud boolForKey:@"TSPUserDefaultsSeedItems"]) {
        // Load Seed Items
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"seed" ofType:@"plist"];
        NSLog(@"filepath %@", filePath);
        NSArray *seedCategories = [NSArray arrayWithContentsOfFile:filePath];
        
        // Items
        NSMutableArray *categories = [NSMutableArray array];
        
        // Create List of Items
        for (int i = 0; i < [seedCategories count]; i++) {
            NSDictionary *seedCategory = [seedCategories objectAtIndex:i];
            
            // Create Item
            Category *category = [Category createCategoryWithName:[seedCategory objectForKey:@"categoryName"]];
            
            // Add Item to Items
            [categories addObject:category];
        }
        
        // Items Path
        NSString *categoriesPath = [[self documentsDirectory] stringByAppendingPathComponent:@"items.plist"];
        
        // Write to File
        if ([NSKeyedArchiver archiveRootObject:categories toFile:categoriesPath]) {
            [ud setBool:YES forKey:@"TSPUserDefaultsSeedItems"];
        }
    }
}

- (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths lastObject];
}



@end
