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

@end

@implementation GWRecordsController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSError *error;
    if (![[self recordsFetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void)dealloc
{
    self.recordsFetchedResultsController.delegate = nil;
    self.recordsFetchedResultsController = nil;
}

#pragma mark UITableViewDataSource protocol methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.recordsFetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"RecordCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    Record *record = [self.recordsFetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = record.title;
    
    NSInteger subRecordsCount = [[GWDataBaseController new] getSubRecordsForRecord:record].count;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", subRecordsCount];
}

#pragma mark NSFetchedResultsController methods

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
                [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath]
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

#pragma mark UIAlertView methods

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
        
        NSManagedObjectContext *managedObjectContext = ((GWAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
        Record *record = [NSEntityDescription insertNewObjectForEntityForName:@"Record"
                                                       inManagedObjectContext:managedObjectContext];
        record.title = [alertView textFieldAtIndex:0].text;
        record.creationDate = [NSDate date];
        
        NSError *error = nil;
        [managedObjectContext save:&error];
        if (error) {
            
            NSLog(@"Error at new record saving");
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[GWSubRecordsController class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Record *record = [self.recordsFetchedResultsController objectAtIndexPath:indexPath];
        [segue.destinationViewController setRecord:record];
    }
}

@end
