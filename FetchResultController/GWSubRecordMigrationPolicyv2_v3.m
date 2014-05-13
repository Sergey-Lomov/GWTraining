//
//  GWSubRecordMigrationPolicyv2_v3.m
//  FetchResultController
//
//  Created by Sergii Lomov on 13/05/14.
//
//

#import "GWSubRecordMigrationPolicyv2_v3.h"

@implementation GWSubRecordMigrationPolicyv2_v3

- (BOOL)createDestinationInstancesForSourceInstance:(NSManagedObject *)sInstance entityMapping:(NSEntityMapping *)mapping manager:(NSMigrationManager *)manager error:(NSError **)error
{
    NSManagedObject *dInstance = [NSEntityDescription insertNewObjectForEntityForName:[mapping destinationEntityName]
                                                               inManagedObjectContext:[manager destinationContext]];
    
    [dInstance setValue:[sInstance valueForKey:@"creationDate"] forKey:@"creationDate"];
    [dInstance setValue:[sInstance valueForKey:@"parent"] forKey:@"parent"];
    NSInteger intTitle = [[sInstance valueForKey:@"title"] intValue];
    [dInstance setValue:[NSNumber numberWithInt:intTitle] forKey:@"parent"];
    
    [manager associateSourceInstance:sInstance withDestinationInstance:dInstance forEntityMapping:mapping];
    
    return YES;
}

@end
