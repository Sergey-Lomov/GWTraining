//
//  NSManagedObject+ActiveRecord.m
//  FetchResultController
//
//  Created by Sergii Lomov on 14/05/14.
//
//

#import "NSManagedObject+ActiveRecord.h"

@implementation NSManagedObject (ActiveRecord)

+ (NSManagedObject *)createInContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                         inManagedObjectContext:context];
}

+ (NSFetchedResultsController *)fetchedControllerSortBy:(NSString *)sortBy
                                              ascending:(BOOL)ascending
                                                grouped:(NSString *)groupedBy
                                              inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class])
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortBy ascending:ascending];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                               managedObjectContext:context
                                                                                                 sectionNameKeyPath:groupedBy
                                                                                                          cacheName:nil];
    
    return fetchedResultsController;
}

- (void)deleteSelf
{
    [self.managedObjectContext deleteObject:self];
}

@end
