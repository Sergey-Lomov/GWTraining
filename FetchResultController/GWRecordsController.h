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

@interface GWRecordsController : UITableViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UIAlertViewDelegate, UITextFieldDelegate>

- (IBAction)addNewRecord:(id)sender;

@end
