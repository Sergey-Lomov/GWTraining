//
//  GWRecordTableViewCell.h
//  FetchResultController
//
//  Created by Sergii Lomov on 13/05/14.
//
//

#import <UIKit/UIKit.h>


@interface GWRecordTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) NSString *title;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@end
