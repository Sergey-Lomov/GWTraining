//
//  GWFriendsTableViewCell.h
//  FetchResultController
//
//  Created by Sergii Lomov on 16/05/14.
//
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
@interface GWFriendsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photo;

@property (nonatomic, strong) FBProfilePictureView *profilePictureView;

@end
