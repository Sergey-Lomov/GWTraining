//
//  GWSubRecordTableViewCell.m
//  FetchResultController
//
//  Created by Sergii Lomov on 13/05/14.
//
//

#import "GWSubRecordTableViewCell.h"

@implementation GWSubRecordTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleTextField.delegate = self;
    }
    return self;
}

- (NSString *)title
{
    return self.titleTextField.text;
}

- (void)setTitle:(NSString *)title
{
    self.titleTextField.text = title;
}

@end
