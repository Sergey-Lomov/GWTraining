//
//  GWRecordTableViewCell.h
//  FetchResultController
//
//  Created by Sergii Lomov on 13/05/14.
//
//

#import <UIKit/UIKit.h>

@class GWRecordTableViewCell;

@protocol GWRecordTableViewCellDelegate <NSObject>

- (void)recordCell:(GWRecordTableViewCell *)cell didChageTitle:(NSString *)title;

@end



@interface GWRecordTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) NSString *title;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;

@property (weak, nonatomic) id<GWRecordTableViewCellDelegate> delegate;

- (IBAction)titleChanged:(id)sender;

@end
