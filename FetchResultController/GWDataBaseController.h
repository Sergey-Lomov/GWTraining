//
//  GWDataBaseController.h
//  FetchResultController
//
//  Created by Sergii Lomov on 13/05/14.
//
//

#import <Foundation/Foundation.h>

@class Record;
@class SubRecord;

/**
 This class provide requests to data base. Uses context specified in GWAppDelegate.
 */
@interface GWDataBaseController : NSObject

/**
 Add record to data base.
 
 @param title Title for new record
 @param creationDate Creation date for new record
 
 @return New Record object. If error occure returns nil.
 */
- (Record *)addRecordWithTitle:(NSString *)title creationDate:(NSDate *)creationDate;

/**
 Get array with subrecords for specified record.
 
 @param record Parent record
 
 @return NSArray with subrecords related to specified record
 */
- (NSArray *)getSubRecordsForRecord:(Record *)record;

/**
 Change title for record.
 
 @param title New title
 @param record Record, whose title should be changed
 
 @return Return YES if title has been successfully changed. In other case return NO.
 */
- (BOOL)setTitle:(NSString *)title forRecrod:(Record *)record;

/**
 Change title for subrecord.
 
 @param title New title
 @param subRecord Subrecord, whose title should be changed
 
 @return Return YES if title has been successfully changed. In other case return NO.
 */
- (BOOL)setTitle:(NSNumber *)title forSubRecrod:(SubRecord *)subRecord;

@end
