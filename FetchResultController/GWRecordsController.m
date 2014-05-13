//
//  GWViewController.m
//  FetchResultController
//
//  Created by Sergii Lomov on 12/05/14.
//
//

#import "GWAppDelegate.h"
#import "GWRecordsController.h"
#import "GWSubRecordsController.h"
#import "GWDataBaseController.h"
#import "Record.h"

@interface GWRecordsController ()

@property (nonatomic, strong) NSFetchedResultsController *recordsFetchedResultsController;

@property (nonatomic, strong) NSMutableArray *cells;

@end

@implementation GWRecordsController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSError *error;
    if (![[self recordsFetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    self.cells = [NSMutableArray new];
}

- (void)dealloc
{
    self.recordsFetchedResultsController.delegate = nil;
    self.recordsFetchedResultsController = nil;
    self.cells = nil;
}

#pragma mark - UITableViewDataSource protocol methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.recordsFetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"RecordCell";
    GWRecordTableViewCell *cell = (GWRecordTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(GWRecordTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    Record *record = [self.recordsFetchedResultsController objectAtIndexPath:indexPath];
    cell.titleTextField.text = record.title;
    
    NSInteger subRecordsCount = [[GWDataBaseController new] getSubRecordsForRecord:record].count;
    cell.detailsLabel.text = [NSString stringWithFormat:@"%d", subRecordsCount];
    
    if (indexPath.row < [[self.recordsFetchedResultsController.sections objectAtIndex:0] numberOfObjects] - 1) {
        
        cell.titleTextField.returnKeyType = UIReturnKeyNext;
    }
    else {
        
        cell.titleTextField.returnKeyType = UIReturnKeyDone;
    }
}

#pragma mark - UITableViewDelegate protocol methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableView])
    {
        GWRecordTableViewCell *recordCell = (GWRecordTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [recordCell.titleTextField endEditing:YES];
    }
}

#pragma mark - NSFetchedResultsController methods

- (NSFetchedResultsController *)recordsFetchedResultsController {
    
    if (_recordsFetchedResultsController != nil) {
        return _recordsFetchedResultsController;
    }
    
    
    NSManagedObjectContext *managedObjectContext = ((GWAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Record"
                                              inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
    NSArray *sortDescriptors = @[dateDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    _recordsFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:managedObjectContext
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:nil];
    _recordsFetchedResultsController.delegate = self;
    
    return _recordsFetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    if ([controller isEqual: self.recordsFetchedResultsController])
    {
        switch(type) {
                
            case NSFetchedResultsChangeInsert:
                [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
                
            case NSFetchedResultsChangeUpdate:
                [self configureCell:(GWRecordTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath]
                        atIndexPath:indexPath];
                break;
                
            case NSFetchedResultsChangeMove:
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [self.tableView endUpdates];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    UITableViewCell *cell = [self cellForTitleTextField:textField];
    if (cell != nil) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        if (indexPath.row < self.recordsFetchedResultsController.fetchedObjects.count - 1) {
            
            NSIndexPath *nextIndex = [NSIndexPath indexPathForRow:indexPath.row +1
                                                       inSection:indexPath.section];
            GWRecordTableViewCell *nextCell = (GWRecordTableViewCell *)[self.tableView cellForRowAtIndexPath:nextIndex];
            [nextCell.titleTextField becomeFirstResponder];
        }
        else
        {
            [textField resignFirstResponder];
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UITableViewCell *cell = [self cellForTitleTextField:textField];
    if (cell != nil) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Record *record = [self.recordsFetchedResultsController objectAtIndexPath:indexPath];
        [[GWDataBaseController new] setTitle:textField.text
                                   forRecrod:record];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UITableViewCell *cell = [self cellForTitleTextField:textField];
    if (cell != nil) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Record *record = [self.recordsFetchedResultsController objectAtIndexPath:indexPath];
        record.title = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }
    
    return YES;
}

#pragma mark - UIAlertView methods

- (IBAction)addNewRecord:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Add record"
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        [[GWDataBaseController new] addRecordWithTitle:[alertView textFieldAtIndex:0].text
                                          creationDate:[NSDate date]];
 
    }
}

#pragma mark - Other

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[GWSubRecordsController class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Record *record = [self.recordsFetchedResultsController objectAtIndexPath:indexPath];
        [segue.destinationViewController setRecord:record];
    }
}

- (GWRecordTableViewCell *)cellForTitleTextField:(UITextField *)textField
{
    UIView *currentView = textField;
    while (currentView != nil
           && ![currentView isKindOfClass:[GWRecordTableViewCell class]]) {
        
        currentView = currentView.superview;
    }
    
    return (GWRecordTableViewCell *)currentView;
}

@end
