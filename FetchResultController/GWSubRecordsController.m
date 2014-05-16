//
//  GWSubRecordsController.m
//  FetchResultController
//
//  Created by Sergii Lomov on 12/05/14.
//
//

#import "GWAppDelegate.h"
#import "GWSubRecordsController.h"
#import "NSManagedObject+ActiveRecord.h"
#import "Record.h"
#import "SubRecord.h"

@interface GWSubRecordsController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation GWSubRecordsController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSManagedObjectContext *managedObjectContext = ((GWAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    self.fetchedResultsController = [SubRecord fetchedControllerSortBy:@"creationDate"
                                                             ascending:NO
                                                               grouped:nil
                                                             predicate:[NSPredicate predicateWithFormat:@"parent = %@", self.record]
                                                             inContext:managedObjectContext];
    self.fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:animated];
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

#pragma mark - UITableViewController methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

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
    cell.title = [subRecord.title stringValue];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    cell.detailsLabel.text = [dateFormatter stringFromDate:subRecord.creationDate];

    dispatch_async(dispatch_get_global_queue(0,0), ^
    {
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:@"http://lorempixel.com/47/47/"]];
        if ( data == nil )
        {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^
        {
            cell.photoImageView.image = [UIImage imageWithData: data];
        });
    });
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        SubRecord *subRecord = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [subRecord deleteSelf];
    }
}

#pragma mark - NSFetchedResultsController methods

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
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        NSManagedObjectContext *managedObjectContext = ((GWAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
        SubRecord *subRecord = [NSEntityDescription insertNewObjectForEntityForName:@"SubRecord"
                                                       inManagedObjectContext:managedObjectContext];
        subRecord.title = [NSNumber numberWithInt:[[alertView textFieldAtIndex:0].text intValue]];
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
        SubRecord *subRecord = [self.fetchedResultsController objectAtIndexPath:indexPath];
        subRecord.title = [NSNumber numberWithInt:[textField.text intValue]];
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
