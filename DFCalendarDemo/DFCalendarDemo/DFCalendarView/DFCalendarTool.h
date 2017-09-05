//
//  DFCalendarTool.h
//  DFCalendar
//
//  Created by 全程恺 on 17/3/3.
//  Copyright © 2017年 全程恺. All rights reserved.
//

#define singleton_interface(className) \
+ (className *)shared##className;


// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)shared##className \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}

#define kNotification_Change_Month  @"kNotification_Change_Month"
#define kNotification_Select_Day    @"kNotification_Select_Day"

#define kFromDateKey @"fromDate"
#define kToDateKey  @"toDate"

//屏幕高度
#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)
//屏幕宽度
#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)
//导航栏高度
#define kNavBarHeight 64.0

#import <Foundation/Foundation.h>
#import "CLIHelper.h"
#import <Masonry.h>
#import <ReactiveCocoa.h>

typedef NS_ENUM(NSInteger, CalendarVersion) {
    
    CalendarVersion1,   //1.3以前的版本
    CalendarVersion2,
};

@protocol DFCalendarDelegate <NSObject>

- (void)calendarDidSelectDaysFrom:(NSDate *)fromDate to:(NSDate *)toDate;
- (void)calendarDidCancel;

@end

@interface DFCalendarTool : NSObject

singleton_interface(DFCalendarTool)

@property (retain, nonatomic) NSCalendar *calendar;
@property (retain, nonatomic) NSDateFormatter *dateF;

//输入date 输出星期
+ (NSString *)weekdayStringFromDate:(NSDate*)inputDate;

//计算日期提前或延后
+ (NSDate *)dateWithDays:(NSInteger)days;
+ (NSDate *)dateWithDays:(NSInteger)days from:(NSDate *)targetDate;

//距离当前时间N个月的日期
+ (NSDate *)dateWithMonths:(NSInteger)months;
//日期距离当前时间N个月
+ (NSInteger)monthFromDate:(NSDate *)date;
//日期距离当前时间N年
+ (NSInteger)yearFromDate:(NSDate *)date;

//计算给定月份天数
+ (NSInteger)totaldaysInLastMonth:(NSDate *)date;
+ (NSInteger)totaldaysInMonth:(NSDate *)date;
+ (NSInteger)totaldaysInNextMonth:(NSDate *)date;
//计算着三个月的每个月天数 返回数组
+(NSArray *)daycountWithMonths:(NSDate *)date;
//返回周几
+ (NSString *)dayisWeekDay:(NSDate *)date;
//计算给定月份第一天周几
+ (NSInteger)firstWeekdayInMonth:(NSDate *)date;
+ (BOOL)dayisWorkday:(NSDate *)date;

+ (NSInteger)day:(NSDate *)date;

+ (NSInteger)month:(NSDate *)date;
+ (BOOL)isSameDayBetween:(NSDate *)firstDate and:(NSDate *)secondDate;

//传入日期，返回完整日期格式
+ (NSString *)stringWithDate:(NSDate *)date;
//传入日期，只返回日期对应的年月日
+ (NSString *)dayWithDate:(NSDate *)date;
//传入日期，只返回日期对应的时间
+ (NSString *)timeWithDate:(NSDate *)date;
//传入日期，只返回月跟日的时间
+ (NSString *)timeWithMonth:(NSDate *)date;

//传入日期格式的字符串，返回完整日期
+ (NSDate *)dateWithString:(NSString *)string;
//传入年月日的字符串，返回完整日期
+ (NSDate *)dateWithDay:(NSString *)day;
//传入时间字符串，返回完整日期
+ (NSDate *)dateWithTime:(NSString *)time inDay:(NSDate *)day;
//传入年月，返回date
+ (NSDate *)dateWithMonthStr:(NSString *)string;


//计算当前月开始和结束时间
+ (NSString *)strWithFirstDayInMonth:(NSDate *)date;
+ (NSString *)strWithLastDayInMonth:(NSDate *)date;

//计算当天开始和结束时间綴
+ (NSString *)strWithDayBegin:(NSDate *)date;
+ (NSString *)strWithDayEnd:(NSDate *)date;

//给定时间返回指定格式 mm月dd日 weekday
+ (NSString *)stringWitdDayWeekDay:(NSDate *)date;

//给定时间字符串返回天数
+ (NSInteger)dayWithString:(NSString *)dateStr;

@end
