//
//  GWSubRecordsController.h
//  FetchResultController
//
//  Created by Sergii Lomov on 12/05/14.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class Record;

@interface GWSubRecordsController : UITableViewController <UITableViewDataSource, NSFetchedResultsControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) Record *record;

- (IBAction)addNewSubRecord:(id)sender;

@end
