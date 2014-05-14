//
//  Record+Grouping.m
//  FetchResultController
//
//  Created by Sergii Lomov on 14/05/14.
//
//

#import "Record+Grouping.h"

static NSInteger hourRounding = 1;

@implementation Record (Grouping)

+ (void)setHourRounding:(NSInteger)newHourRounding
{
    if (newHourRounding > 0
        && newHourRounding < 24) {
        hourRounding = newHourRounding;
    }
}

- (NSString *)sectionTitle
{
    NSDateComponents *time = [[NSCalendar currentCalendar]
                              components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit
                              fromDate:self.creationDate];
    NSInteger hour = [time hour];
    float roundedHour = (hour / hourRounding) * hourRounding;
    [time setHour: roundedHour];
    NSDate *roundedDate = [[NSCalendar currentCalendar] dateFromComponents:time];
    
    NSDateFormatter *dateFormater = [NSDateFormatter new];
    [dateFormater setDateFormat:@"YYYY-MM-dd hh at"];
    
    return [dateFormater stringFromDate:roundedDate];
}

@end
