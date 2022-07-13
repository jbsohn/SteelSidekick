//
//  AppDelegate.m
//  SteelSidekick
//
//  Created by John Sohn on 1/31/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#import "AppDelegate.h"
#import "Appirater.h"
#import "SGuitar.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Appirater appLaunched:YES];
    [Appirater setAppId:@"802758051"];

    [self setupLastGuitar];
    [self setupGuitarDirectories];
    return YES;
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    if ([url.pathExtension isEqualToString:@"sguitar"]) {
        [self importGuitarFromPath:url.path];
    }
    return NO;
}
- (void)importGuitarFromPath:(NSString *)path {
    NSString *name = [[[path pathComponents] lastObject] stringByDeletingPathExtension];
    NSString *title = [NSString stringWithFormat:@"Importing %@", name];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:@"Enter the guitar name to import as." preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = name;
        textField.placeholder = name;
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *name = [alertController.textFields firstObject].text;
        if (![[SGuitar sharedInstance] addCustomGuitarFromPath:path name:name]) {
            [self showImportErrorAlertForPath:path];
        }
    }];
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancelAction];
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)showImportErrorAlertForPath:(NSString *)path {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"An error occurred while trying to import the guitar. Please ensure you are not using the name of an existing custom guitar." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self importGuitarFromPath:path];
    }];
    [alertController addAction:okAction];
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}

// set the last guitar selected
- (void)setupLastGuitar {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    SGuitar* sguitar = [SGuitar sharedInstance];
    SGGuitarOptions *guitarOptions = [sguitar getGuitarOptions];
    
    NSString *guitarType = [defaults stringForKey:@"guitarType"];
    NSString *guitarName = [defaults stringForKey:@"guitarName"];
    
    if (guitarType && guitarName && [guitarType length] > 0 && [guitarName length] > 0) {
        guitarOptions.guitarType = guitarType;
        guitarOptions.guitarName = guitarName;
        [sguitar setGuitarOptions:guitarOptions];
        [sguitar reloadGuitar];
    }
}

- (void)setupGuitarDirectories {
    NSString *dataPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Custom Guitars"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
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
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
