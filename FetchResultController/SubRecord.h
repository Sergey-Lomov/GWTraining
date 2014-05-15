//
//  SubRecord.h
//  FetchResultController
//
//  Created by Sergii Lomov on 13/05/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Record;

@interface SubRecord : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * title;
@property (nonatomic, retain) Record *parent;

@property (nonatomic, strong) UIImage *temporayImage;

@end
