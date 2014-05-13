//
//  GWDataBaseController.m
//  FetchResultController
//
//  Created by Sergii Lomov on 13/05/14.
//
//

#import <CoreData/CoreData.h>
#import "GWDataBaseController.h"
#import "GWAppDelegate.h"


@implementation GWDataBaseController

- (NSArray*)getSubRecordsForRecord:(Record *)record
{
    NSManagedObjectContext *context = ((GWAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SubRecord"
                                              inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent = %@", record];
    
    NSFetchRequest *request = [NSFetchRequest new];
    request.entity = entity;
    request.predicate = predicate;
    
    NSError *error = nil;
    NSArray *subRecords = [context executeFetchRequest:request error:&error];
    
    if (error)
    {
        NSLog(@"DataBaseController error: error at subrecords request");
    }
    
    return subRecords;
}

@end
