//
//  NSManagedObject+ActiveRecord.h
//  FetchResultController
//
//  Created by Sergii Lomov on 14/05/14.
//
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (ActiveRecord)

+ (NSManagedObject *)createInContext:(NSManagedObjectContext *)context;
+ (NSFetchedResultsController *)fetchedControllerSortBy:(NSString *)sortBy
                                              ascending:(BOOL)ascending
                                                grouped:(NSString *)groupedBy
                                              inContext:(NSManagedObjectContext *)context;

- (void)deleteSelf;

@end
