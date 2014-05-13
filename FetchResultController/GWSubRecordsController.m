//
//  GWSubRecordsController.m
//  FetchResultController
//
//  Created by Sergii Lomov on 12/05/14.
//
//

#import "GWAppDelegate.h"
#import "GWSubRecordsController.h"
#import "GWDataBaseController.h"
#import "Record.h"
#import "SubRecord.h"

@interface GWSubRecordsController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation GWSubRecordsController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void)dealloc
{
    self.fetchedResultsController.delegate = nil;
    self.fetchedResultsController = nil;
}

- (void)setRecord:(Record *)record
{
    _record = record;
    self.title = record.title;
}

#pragma mark - UITableViewDataSource protocol methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"SubRecordCell";
    GWSubRecordTableViewCell *cell = (GWSubRecordTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(GWSubRecordTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    SubRecord *subRecord = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.title = subRecord.title;
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    cell.detailsLabel.text = [dateFormatter stringFromDate:subRecord.creationDate];
}

#pragma mark - NSFetchedResultsController methods

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSManagedObjectContext *managedObjectContext = ((GWAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SubRecord"
                                              inManagedObjectContext:managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent = %@", self.record];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
    NSArray *sortDescriptors = @[dateDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:managedObjectContext
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(GWSubRecordTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [self.tableView endUpdates];
}

#pragma mark - UIAlertView methods

- (IBAction)addNewSubRecord:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Add record"
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"OK", nil];
    [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        NSManagedObjectContext *managedObjectContext = ((GWAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
        SubRecord *subRecord = [NSEntityDescription insertNewObjectForEntityForName:@"SubRecord"
                                                       inManagedObjectContext:managedObjectContext];
        subRecord.title = [alertView textFieldAtIndex:0].text;
        subRecord.creationDate = [NSDate date];
        
        [self.record addChildsObject:subRecord];
        
        NSError *error = nil;
        [managedObjectContext save:&error];
        if (error) {
            
            NSLog(@"Error at new record saving");
        }
    }
}

#pragma mark - UITextFieldDelegate protocol methods

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UITableViewCell *cell = [self cellForTitleTextField:textField];
    if (cell != nil) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Record *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [[GWDataBaseController new] setTitle:textField.text
                                   forRecrod:record];
    }
}

- (GWSubRecordTableViewCell *)cellForTitleTextField:(UITextField *)textField
{
    UIView *currentView = textField;
    while (currentView != nil
           && ![currentView isKindOfClass:[GWSubRecordTableViewCell class]]) {
        
        currentView = currentView.superview;
    }
    
    return (GWSubRecordTableViewCell *)currentView;
}

@end
