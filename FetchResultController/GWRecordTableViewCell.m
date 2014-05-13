//
//  GWRecordTableViewCell.m
//  FetchResultController
//
//  Created by Sergii Lomov on 13/05/14.
//
//

#import "GWRecordTableViewCell.h"

@implementation GWRecordTableViewCell

- (NSString *)title
{
    return self.titleTextField.text;
}

- (void)setTitle:(NSString *)title
{
    self.titleTextField.text = title;
}

@end
