//
//  Record.h
//  FetchResultController
//
//  Created by Sergii Lomov on 12/05/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Record : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * creationDate;

@end
