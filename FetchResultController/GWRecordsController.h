//
//  GWViewController.h
//  FetchResultController
//
//  Created by Sergii Lomov on 12/05/14.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "GWRecordTableViewCell.h"

@interface GWRecordsController : UITableViewController <NSFetchedResultsControllerDelegate, UIAlertViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *editRecordsButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addRecordButton;


- (IBAction)addNewRecord:(id)sender;
- (IBAction)editRecords:(id)sender;
- (IBAction)showGroupingPicker:(id)sender;

- (void)reloadData;

@end
