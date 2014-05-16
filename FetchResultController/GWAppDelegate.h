//
//  GWAppDelegate.h
//  FetchResultController
//
//  Created by Sergii Lomov on 12/05/14.
//
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface GWAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) FBSession *session;

@end
