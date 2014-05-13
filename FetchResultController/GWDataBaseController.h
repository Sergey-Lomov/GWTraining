//
//  GWDataBaseController.h
//  FetchResultController
//
//  Created by Sergii Lomov on 13/05/14.
//
//

#import <Foundation/Foundation.h>

@class  Record;

/**
 This class provide requests to data base. Uses context specified in GWAppDelegate.
 */
@interface GWDataBaseController : NSObject

- (NSArray*)getSubRecordsForRecord:(Record *)record;

@end
