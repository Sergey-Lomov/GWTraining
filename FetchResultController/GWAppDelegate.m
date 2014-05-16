//
//  GWAppDelegate.m
//  FetchResultController
//
//  Created by Sergii Lomov on 12/05/14.
//
//

#import <CoreData/CoreData.h>
#import <FacebookSDK/FacebookSDK.h>
#import "GWAppDelegate.h"
#import "GWRecordsController.h"

@interface GWAppDelegate ()

@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation GWAppDelegate

@synthesize managedObjectModel=_managedObjectModel, managedObjectContext=_managedObjectContext, persistentStoreCoordinator=_persistentStoreCoordinator;

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FBProfilePictureView class];
    [FBFriendPickerViewController class];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    self.session = [[FBSession alloc] init];
    BOOL success = [FBAppCall handleOpenURL:url
                          sourceApplication:sourceApplication
                                withSession:self.session];
    if (success)
    {
        [FBSession setActiveSession:self.session];
    }
    
    return success;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self saveContext];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self saveContext];
}

- (void)saveContext
{
    NSError *error;
    if (_managedObjectContext != nil) {
        if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *) managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model"];

    NSFileManager *fileManager = [NSFileManager defaultManager];

    if (![fileManager fileExistsAtPath:[storeURL path]]) {
        NSURL *defaultStoreURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"CDBStore"];
        if (defaultStoreURL) {
            [fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:NULL];
        }
    }
    
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    
    NSError *error;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - FaceBook methods

//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation {
//    
//   // NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
//    
//    return [FBSession.activeSession handleOpenURL:url];
//}


#pragma mark - Other

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
