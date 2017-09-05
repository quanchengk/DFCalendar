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

//输入日期date 输出星期
+ (NSString *)weekdayStringFromDate:(NSDate*)inputDate{
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"日", @"一", @"二", @"三", @"四", @"五", @"六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}

//距离当前时间 N天的日期
+ (NSDate *)dateWithDays:(NSInteger)days
{
    NSDate *newdate = [DFCalendarTool dateWithDays:days from:[NSDate date]];
    
    return newdate;
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

+ (NSInteger)yearFromDate:(NSDate *)date {
    
    NSInteger month = [self monthFromDate:date];
    double year = month / 12.0;
    return ceil(year);
}

+(NSArray *)daycountWithMonths:(NSDate *)date{
    NSMutableArray *monthArray=[[NSMutableArray alloc]initWithCapacity:10];
    [monthArray addObject:@([DFCalendarTool totaldaysInLastMonth:date])];
    [monthArray addObject:@([DFCalendarTool totaldaysInMonth:date])];
    [monthArray addObject:@([DFCalendarTool totaldaysInNextMonth:date])];
    return [monthArray copy];
}

//距离给定日期 N天后的日期
+(NSDate*)dateWithDays:(NSInteger)days from:(NSDate*)targetDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    
    [adcomps setDay:days];
    
    NSDate *dateA =  [calendar dateByAddingComponents:adcomps toDate:targetDate options:0];
    
    return dateA ;
}

//计算给定月份天数

+ (NSInteger)totaldaysInLastMonth:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    
    comp.month -= 1;
    if (comp.month == 0) {
        
        comp.month = 12;
        comp.year -= 1;
    }
    
    NSDate *newDate = [calendar dateFromComponents:comp];
    
    return [DFCalendarTool totaldaysInMonth:newDate];
}

+ (NSInteger)totaldaysInMonth:(NSDate *)date {
    
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    
    return totaldaysInMonth.length;
}

+ (NSInteger)totaldaysInNextMonth:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    
    comp.month+= 1;
    if (comp.month == 13) {
        
        comp.month = 1;
        comp.year += 1;
    }
    
    NSDate *newDate = [calendar dateFromComponents:comp];
    
    return [DFCalendarTool totaldaysInMonth:newDate];
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

//计算当前月开始的的时间
+ (NSString *)strWithFirstDayInMonth:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    [DFCalendarTool sharedDFCalendarTool].dateF.dateFormat = @"yyyyMMdd";
    NSString *str = [[DFCalendarTool sharedDFCalendarTool].dateF stringFromDate:firstDayOfMonthDate];
    return str;
}

//计算当前月结速的的时间綴
+ (NSString *)strWithLastDayInMonth:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    [comp setDay:totaldaysInMonth.length];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSString *str=[NSString stringWithFormat:@"%ld",(long)[firstDayOfMonthDate timeIntervalSince1970]];
    return str;
}

//计算当天的开始时间綴
+ (NSString *)strWithDayBegin:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
    [comp setHour:0];
    [comp setMinute:0];
    [comp setSecond:0];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSString *str=[NSString stringWithFormat:@"%ld",(long)[firstDayOfMonthDate timeIntervalSince1970]];
    return str;
    
}

//计算当天的结束时间綴
+ (NSString *)strWithDayEnd:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
    [comp setHour:23];
    [comp setMinute:59];
    [comp setSecond:59];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSString *str=[NSString stringWithFormat:@"%ld",(long)[firstDayOfMonthDate timeIntervalSince1970]];
    return str;
}

//给定时间返回指定格式 mm月dd日 weekday
+ (NSString *)stringWitdDayWeekDay:(NSDate *)date{
    
    if (date == nil) {
        return @"";
    }
    
    NSString *day = [self timeWithMonth:date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitWeekday ) fromDate:date];
    NSString *str;
    
    switch (comp.weekday) {
        case 1:
            str=@"周日";
            break;
        case 2:
            str=@"周一";
            break;
        case 3:
            str=@"周二";
            break;
        case 4:
            str=@"周三";
            break;
        case 5:
            str=@"周四";
            break;
        case 6:
            str=@"周五";
            break;
        default:
            str=@"周六";
            break;
    }
    
    NSString *time=[NSString stringWithFormat:@"%@ %@", day,str];
    return time;
    
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

+ (NSInteger)dayWithString:(NSString *)dateStr{
    NSDate *date = [self dateWithDay:dateStr];
    NSInteger dd = [self day:date];
    return dd-1;
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

+ (NSString *)stringWithDate:(NSDate *)date{
    
    [[DFCalendarTool sharedDFCalendarTool].dateF setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [[DFCalendarTool sharedDFCalendarTool].dateF stringFromDate:date];
    return strDate;
}

+ (NSString *)dayWithDate:(NSDate *)date {
    
    [[DFCalendarTool sharedDFCalendarTool].dateF setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [[DFCalendarTool sharedDFCalendarTool].dateF stringFromDate:date];
    return strDate;
}

+ (NSString *)timeWithDate:(NSDate *)date {
    
    [[DFCalendarTool sharedDFCalendarTool].dateF setDateFormat:@"HH:mm"];
    NSString *strDate = [[DFCalendarTool sharedDFCalendarTool].dateF stringFromDate:date];
    return strDate;
}

+ (NSString *)timeWithMonth:(NSDate *)date {
    
    [[DFCalendarTool sharedDFCalendarTool].dateF setDateFormat:@"MM-dd"];
    NSString *strDate = [[DFCalendarTool sharedDFCalendarTool].dateF stringFromDate:date];
    return strDate;
}

+ (NSDate *)dateWithString:(NSString *)string {
    
    [[DFCalendarTool sharedDFCalendarTool].dateF setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [[DFCalendarTool sharedDFCalendarTool].dateF dateFromString:string];
}

+ (NSDate *)dateWithDay:(NSString *)day {
    
    [[DFCalendarTool sharedDFCalendarTool].dateF setDateFormat:@"yyyy-MM-dd"];
    return [[DFCalendarTool sharedDFCalendarTool].dateF dateFromString:day];
}

+ (NSDate *)dateWithMonthStr:(NSString *)string {
    
    [[DFCalendarTool sharedDFCalendarTool].dateF setDateFormat:@"yyyyMM"];
    return [[DFCalendarTool sharedDFCalendarTool].dateF dateFromString:string];
}

+ (NSDate *)dateWithTime:(NSString *)time inDay:(NSDate *)day {
    
    NSArray *times = [time componentsSeparatedByString:@":"];
    NSDateComponents *comp = [[DFCalendarTool sharedDFCalendarTool].calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:day];
    [comp setHour:[times[0] integerValue]];
    [comp setMinute:[times[1] integerValue]];
    
    NSDate *startDate = [[DFCalendarTool sharedDFCalendarTool].calendar dateFromComponents:comp];
    
    return startDate;
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

//返回周几
+ (NSString *)dayisWeekDay:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitWeekday ) fromDate:date];
    NSString *str;
    
    switch (comp.weekday) {
        case 1:
            str=@"周天";
            break;
        case 2:
            str=@"周一";
            break;
        case 3:
            str=@"周二";
            break;
        case 4:
            str=@"周三";
            break;
        case 5:
            str=@"周四";
            break;
        case 6:
            str=@"周五";
            break;
        case 7:
            str = @"周六";
            break;
        default:
            str = @"";
            break;
    }
    
    NSString *time=[NSString stringWithFormat:@"%@ %@",[DFCalendarTool dayWithDate:date],str];
    
    return time;
}

@end
