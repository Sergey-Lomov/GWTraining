//
//  GWFriendsTableViewController.m
//  FetchResultController
//
//  Created by Sergii Lomov on 15/05/14.
//
//

#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>
#import "GWFriendsViewController.h"
#import "GWAppDelegate.h"
#import "GWFriendsTableViewCell.h"

@interface GWFriendsViewController ()

@property (nonatomic, strong) NSArray *friends;

@end

@implementation GWFriendsViewController

- (void)dealloc
{
    self.profilePictureView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.profilePictureView = [FBProfilePictureView new];
    self.profilePictureView.frame = CGRectMake(0.0, 0.0, 75.0, 75.0);
    [self.loginPlaceholder addSubview:self.profilePictureView];
    
    self.loginView = [[FBLoginView alloc] init];
    self.loginView.readPermissions = @[@"user_friends"];
    self.loginView.frame = CGRectOffset(self.loginView.frame, 90, 10);
    self.loginView.delegate = self;
    self.loginView.loginBehavior = FBSessionLoginBehaviorUseSystemAccountIfPresent;
    [self.loginPlaceholder addSubview:self.loginView];
    [self.loginView sizeToFit];
    
    [self reloadFriendsList];
    self.friendsTableView.delegate = self;
    self.friendsTableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated
{
}

- (void)reloadFriendsList
{
    if ([FBSession.activeSession isOpen])
    {
        [FBRequestConnection startWithGraphPath:@"me/taggable_friends"
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
         {
             self.friends = [result objectForKey:@"data"];
             NSLog(@"Found: %i friends", self.friends.count);
             for (NSDictionary<FBGraphUser>* friend in self.friends)
             {
                 NSLog(@"I have a friend named %@ with id %@", friend.name, friend.objectID);
             }
             [self.friendsTableView reloadData];
         }];
    }

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.friends count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"friendsListCell";
    GWFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.nameLabel.text = [[self.friends objectAtIndex:indexPath.row] name];
//    NSString *friendPhotoURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=small", [[self.friends objectAtIndex:indexPath.row] objectID]];
//    NSData *friendPhotoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:friendPhotoURL]];
//    cell.photo.image = [UIImage imageWithData:friendPhotoData];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Navigation


- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
     self.profilePictureView.profileID = nil;
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    self.profilePictureView.profileID = [user objectID];
}


- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    NSLog(@"FBLoginView encountered an error=%@", error);
}
@end
