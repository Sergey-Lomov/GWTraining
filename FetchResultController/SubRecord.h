//
//  SubRecord.h
//  FetchResultController
//
//  Created by Sergii Lomov on 12/05/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Record;

@interface SubRecord : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) Record *parent;

@end
