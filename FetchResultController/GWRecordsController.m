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
#import "Record.h"
#import "Record+Grouping.h"
#import "NSManagedObject+ActiveRecord.h"

@interface GWRecordsController ()

@property (nonatomic, strong) NSFetchedResultsController *recordsFetchedResultsController;

@property (nonatomic, strong) UIActionSheet *groupingSettingActionSheet;
@property (nonatomic, assign) NSInteger selectedGrouping;
@property (nonatomic, strong) NSArray *groupingTitles;
@property (nonatomic, strong) NSDictionary *groupingValues;

@end

@implementation GWRecordsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSManagedObjectContext *managedObjectContext = ((GWAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    self.recordsFetchedResultsController = [Record fetchedControllerSortBy:@"creationDate"
                                                                 ascending:NO
                                                                   grouped:@"sectionTitle"
                                                                 inContext:managedObjectContext];
    self.recordsFetchedResultsController.delegate = self;
    
    [self reloadRecordsFetchResultController];
    
    self.groupingTitles = [[NSArray alloc] initWithObjects: @"1 hour", @"2 hours", @"3 hours", @"4 hours", @"6 hours", @"12 hours", nil];
    self.groupingValues = [[NSDictionary alloc] initWithObjects:@[@1, @2, @3, @4, @6, @12]
                                                        forKeys:self.groupingTitles];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)dealloc
{
    self.recordsFetchedResultsController.delegate = nil;
    self.recordsFetchedResultsController = nil;
    self.addRecordButton = nil;
    self.editRecordsButton = nil;
    self.groupingSettingActionSheet = nil;
}

#pragma mark - UITableViewController methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.recordsFetchedResultsController sections] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.recordsFetchedResultsController.sections objectAtIndex:section] name];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.recordsFetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"RecordCell";
    GWRecordTableViewCell *cell = (GWRecordTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(GWRecordTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Record *record = [self.recordsFetchedResultsController objectAtIndexPath:indexPath];
    cell.titleTextField.text = record.title;
    
    cell.detailsLabel.text = [NSString stringWithFormat:@"%d", record.childs.count];
    
    if (indexPath.row < [[self.recordsFetchedResultsController.sections objectAtIndex:0] numberOfObjects] - 1)
    {
        cell.titleTextField.returnKeyType = UIReturnKeyNext;
    }
    else
    {
        cell.titleTextField.returnKeyType = UIReturnKeyDone;
    }
    
    NSDateFormatter *dateFromater = [NSDateFormatter new];
    [dateFromater setDateFormat:@"YY-MM-dd hh:mm:ss"];
    cell.dateLabel.text = [dateFromater stringFromDate:record.creationDate];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableView])
    {
        GWRecordTableViewCell *recordCell = (GWRecordTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [recordCell.titleTextField endEditing:YES];
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Record *record = [self.recordsFetchedResultsController objectAtIndexPath:indexPath];
        [record deleteSelf];
    }
}

#pragma mark - NSFetchedResultsController methods

- (void)reloadRecordsFetchResultController
{
    NSError *error = nil;
    if (![[self recordsFetchedResultsController] performFetch:&error])
    {
        NSLog(@"Unresolved error at fetch %@, %@", error, [error userInfo]);
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    if ([controller isEqual: self.recordsFetchedResultsController])
    {
        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                if ([self.tableView numberOfSections] != [self.recordsFetchedResultsController.sections count])
                {
                    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                                  withRowAnimation:UITableViewRowAnimationNone];
                }
                [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
                
            case NSFetchedResultsChangeDelete:
                if ([self.tableView numberOfSections] != [self.recordsFetchedResultsController.sections count])
                {
                    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
                }
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITableViewCell *cell = [self cellForTitleTextField:textField];
    if (cell != nil)
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        if (indexPath.row < self.recordsFetchedResultsController.fetchedObjects.count - 1)
        {
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
    if (cell != nil)
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Record *record = [self.recordsFetchedResultsController objectAtIndexPath:indexPath];
        record.title = textField.text;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UITableViewCell *cell = [self cellForTitleTextField:textField];
    if (cell != nil)
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Record *record = [self.recordsFetchedResultsController objectAtIndexPath:indexPath];
        record.title = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return self.editing;
}

#pragma mark - UI methods

- (IBAction)addNewRecord:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Add record"
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (IBAction)editRecords:(id)sender
{
    [self setEditing:YES animated:YES];
    self.navigationItem.leftBarButtonItem = nil;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(doneEditing)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)doneEditing
{
    [self setEditing:NO animated:YES];
    self.navigationItem.leftBarButtonItem = self.editRecordsButton;
    self.navigationItem.rightBarButtonItem = self.addRecordButton;
    
    for (NSInteger j = 0; j < [self.tableView numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:j]; ++i)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:j];
            GWSubRecordTableViewCell *cell = (GWSubRecordTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell.titleTextField resignFirstResponder];
        }
    }
}

- (IBAction)showGroupingPicker:(id)sender
{
    if (self.groupingSettingActionSheet == nil)
    {
        self.groupingSettingActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                      delegate:nil
                                                             cancelButtonTitle:nil
                                                        destructiveButtonTitle:nil
                                                             otherButtonTitles:nil];
        self.groupingSettingActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        
        UISegmentedControl * cancelButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:NSLocalizedString(@"Cancel", @"")]];
        cancelButton.momentary = YES;
        cancelButton.frame = CGRectMake(self.view.bounds.size.width - 90.0, 7.0f, 80.0f, 30.0f);
        cancelButton.tintColor = [UIColor blackColor];
        [cancelButton addTarget:self action:@selector(declineGrouping) forControlEvents:UIControlEventValueChanged];
        [self.groupingSettingActionSheet addSubview:cancelButton];
        
        UISegmentedControl *okButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:NSLocalizedString(@"OK", @"")]];
        okButton.momentary = YES;
        okButton.frame = CGRectMake(10, 7.0f, 50.0f, 30.0f);
        okButton.tintColor = [UIColor blackColor];
        [okButton addTarget:self action:@selector(acceptGrouping) forControlEvents:UIControlEventValueChanged];
        [self.groupingSettingActionSheet addSubview:okButton];
        
        
        UIPickerView *groupingPicker = [[UIPickerView alloc] init];
        groupingPicker .frame = CGRectMake(0, 40, self.view.bounds.size.width, 216);
        groupingPicker .dataSource = self;
        groupingPicker .delegate = self;
        groupingPicker .showsSelectionIndicator = YES;
        [self.groupingSettingActionSheet addSubview:groupingPicker ];
    }
    
    [self.groupingSettingActionSheet showInView:self.view.superview];
    [self.groupingSettingActionSheet setBounds:CGRectMake(0, 0, self.view.bounds.size.width, 485)];
}

- (void)acceptGrouping
{
    [Record setHourRounding:self.selectedGrouping];
    
    [self.groupingSettingActionSheet dismissWithClickedButtonIndex:0 animated:YES];
    [self reloadData];
}

- (void)declineGrouping
{
    [self.groupingSettingActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}


#pragma mark - UIAlertView methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSManagedObjectContext *context = ((GWAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
        Record *record = (Record *)[Record createInContext:context];
        record.title = [alertView textFieldAtIndex:0].text;
        record.creationDate = [NSDate date];
    }
}

#pragma mark - UIPickerView deleagte and data source methods


- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.groupingTitles count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [self.groupingTitles objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger groupingIndex = [pickerView selectedRowInComponent:0];
    NSString *gropuingTitle = [self.groupingTitles objectAtIndex:groupingIndex];
    self.selectedGrouping = [[self.groupingValues objectForKey:gropuingTitle] intValue];
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
           && ![currentView isKindOfClass:[GWRecordTableViewCell class]])
    {
        currentView = currentView.superview;
    }
    
    return (GWRecordTableViewCell *)currentView;
}

- (void)reloadData
{
    [self reloadRecordsFetchResultController];
    [self.tableView reloadData];
}

@end
