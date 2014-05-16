//
//  GWFriendsTableViewController.h
//  FetchResultController
//
//  Created by Sergii Lomov on 15/05/14.
//
//

#import <UIKit/UIKit.h>

@interface GWFriendsViewController : UIViewController <FBLoginViewDelegate, UITableViewDataSource, UITableViewDelegate, FBFriendPickerDelegate>

@property (weak, nonatomic) IBOutlet UIView *loginPlaceholder;

@property (strong, nonatomic) FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) FBLoginView *loginView;
@property (weak, nonatomic) IBOutlet UITableView *friendsTableView;

@end
