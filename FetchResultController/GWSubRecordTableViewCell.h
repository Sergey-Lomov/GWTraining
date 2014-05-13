//
//  GWSubRecordTableViewCell.h
//  FetchResultController
//
//  Created by Sergii Lomov on 13/05/14.
//
//

#import <UIKit/UIKit.h>

@interface GWSubRecordTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) NSString *title;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;

@end
