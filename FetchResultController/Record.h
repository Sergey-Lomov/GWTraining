//
//  Record.h
//  FetchResultController
//
//  Created by Sergii Lomov on 12/05/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SubRecord;

@interface Record : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSSet *childs;
@end

@interface Record (CoreDataGeneratedAccessors)

- (void)addChildsObject:(SubRecord *)value;
- (void)removeChildsObject:(SubRecord *)value;
- (void)addChilds:(NSSet *)values;
- (void)removeChilds:(NSSet *)values;

@end
