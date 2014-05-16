//
//  GWFriendsTableViewCell.m
//  FetchResultController
//
//  Created by Sergii Lomov on 16/05/14.
//
//

#import <FacebookSDK/FacebookSDK.h>
#import "GWFriendsTableViewCell.h"

@implementation GWFriendsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    self.profilePictureView = nil;
}

- (void)awakeFromNib
{
//    self.profilePictureView = [FBProfilePictureView new];
//    [self.profilePictureView setFrame:CGRectMake(5, 5, 55, 55)];
//    [self addSubview:self.profilePictureView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
