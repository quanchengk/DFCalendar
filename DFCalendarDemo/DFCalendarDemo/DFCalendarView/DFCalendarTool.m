//
//  DFCalendarTool.m
//  DFCalendar
//
//  Created by 全程恺 on 17/3/3.
//  Copyright © 2017年 全程恺. All rights reserved.
//

#import "DFCalendarTool.h"

@interface DFCalendarTool ()

@end

@implementation DFCalendarTool

singleton_implementation(DFCalendarTool)

- (instancetype)init {
    
    if (self = [super init]) {
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        calendar.timeZone = [NSTimeZone localTimeZone];
        self.calendar = calendar;
    }
    
    return self;
}

- (NSDateFormatter *)dateF {
    
    if (!_dateF) {
        
        _dateF = [NSDateFormatter new];
        _dateF.timeZone = [DFCalendarTool sharedDFCalendarTool].calendar.timeZone;
    }
    
    return _dateF;
}

//距离当前时间N个月的日期
+ (NSDate *)dateWithMonths:(NSInteger)months {
    
    NSCalendar *calendar = [DFCalendarTool sharedDFCalendarTool].calendar;
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    comps.month += months;
    comps.day=1;
    NSDate *date =  [calendar dateFromComponents:comps];
    return date;
}

+ (NSInteger)monthFromDate:(NSDate *)date {
    
    NSDateComponents *targetDate = [[self sharedDFCalendarTool].calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:date];
    NSDateComponents *nowDate = [[self sharedDFCalendarTool].calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:[NSDate date]];
    
    NSInteger month = (targetDate.year - nowDate.year) * 12 + (targetDate.month - nowDate.month);
    return month;
}

+ (NSInteger)totaldaysInMonth:(NSDate *)date {
    
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    
    return totaldaysInMonth.length;
}

//计算给定月份第一天是星期几
+ (NSInteger)firstWeekdayInMonth:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

//判断是不是工作时间
+ (BOOL)dayisWorkday:(NSDate *)date{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitWeekday ) fromDate:date];
    if (comp.weekday==1||comp.weekday==7) {
        
        return NO;
    }else{
        return YES;
    }
}

+ (NSInteger)day:(NSDate *)date {
    
    [[DFCalendarTool sharedDFCalendarTool].dateF setDateFormat:@"dd"];
    
    return [[[DFCalendarTool sharedDFCalendarTool].dateF stringFromDate:date] integerValue];
}

+ (NSInteger)month:(NSDate *)date {
    
    [[DFCalendarTool sharedDFCalendarTool].dateF setDateFormat:@"yyyyMM"];
    
    NSString *dateStr = [[DFCalendarTool sharedDFCalendarTool].dateF stringFromDate:date];
    return [dateStr integerValue];
}

+ (BOOL)isSameDayBetween:(NSDate *)firstDate and:(NSDate *)secondDate {
    
    NSCalendar *calendar = [DFCalendarTool sharedDFCalendarTool].calendar;
    NSDateComponents *comps1 = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:firstDate];
    NSDateComponents *comps2 = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:secondDate];
    
    NSDate *date1 =  [calendar dateFromComponents:comps1];
    NSDate *date2 =  [calendar dateFromComponents:comps2];
    
    BOOL res = [date1 isEqualToDate:date2];
    
    return res;
}

@end
