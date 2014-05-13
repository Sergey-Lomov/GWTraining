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
#import "Record.h"
#import "SubRecord.h"


@implementation GWDataBaseController

- (Record *)addRecordWithTitle:(NSString *)title creationDate:(NSDate *)creationDate {
    
    NSManagedObjectContext *managedObjectContext = ((GWAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    Record *record = [NSEntityDescription insertNewObjectForEntityForName:@"Record"
                                                   inManagedObjectContext:managedObjectContext];
    record.title = title;
    record.creationDate = creationDate;
    
    NSError *error = nil;
    [managedObjectContext save:&error];
    if (error) {
        
        NSLog(@"Error at new record saving");
        return nil;
    }
    
    return record;
}

- (NSArray*)getSubRecordsForRecord:(Record *)record {
    
    NSManagedObjectContext *context = ((GWAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SubRecord"
                                              inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent = %@", record];
    
    NSFetchRequest *request = [NSFetchRequest new];
    request.entity = entity;
    request.predicate = predicate;
    
    NSError *error = nil;
    NSArray *subRecords = [context executeFetchRequest:request error:&error];
    
    if (error) {
        
        NSLog(@"DataBaseController error: error at subrecords request");
    }
    
    return subRecords;
}


- (BOOL)setTitle:(NSString *)title forRecrod:(Record *)record {
    
    record.title = title;
    
    NSManagedObjectContext *managedObjectContext = ((GWAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    NSError *error = nil;
    [managedObjectContext save:&error];
    
    if (error) {
        
        NSLog(@"Error at new record saving");
        return NO;
    }
    
    return YES;
}

- (BOOL)setTitle:(NSString *)title forSubRecrod:(SubRecord *)subRecord
{
    subRecord.title = title;
    
    NSManagedObjectContext *managedObjectContext = ((GWAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    NSError *error = nil;
    [managedObjectContext save:&error];
    
    if (error) {
        
        NSLog(@"Error at new record saving");
        return NO;
    }
    
    return YES;
}

@end
