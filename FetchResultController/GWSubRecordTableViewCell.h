//
//  GWSubRecordTableViewCell.h
//  FetchResultController
//
//  Created by Sergii Lomov on 13/05/14.
//
//

#import <UIKit/UIKit.h>

@class GWSubRecordTableViewCell;

@protocol GWSubRecordTableViewCellDelegate <NSObject>

- (void)subRecordCell:(GWSubRecordTableViewCell *)cell didChageTitle:(NSString *)title;

@end



@interface GWSubRecordTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) NSString *title;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;

@property (weak, nonatomic) id<GWSubRecordTableViewCellDelegate> delegate;

- (IBAction)titleChanged:(id)sender;

@end
