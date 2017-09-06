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
#import "DFHelper.h"
#import <Masonry.h>

typedef NS_ENUM(NSInteger, CalendarVersion) {
    
    CalendarVersion1,   //1.3以前的版本
    CalendarVersion2,
};

@protocol DFCalendarDelegate <NSObject>

- (void)df_calendarDidSelectDaysFrom:(NSDate *)fromDate to:(NSDate *)toDate;

@end

@interface DFCalendarTool : NSObject

singleton_interface(DFCalendarTool)

@property (retain, nonatomic) NSCalendar *calendar;
@property (retain, nonatomic) NSDateFormatter *dateF;

//距离当前时间N个月的日期
+ (NSDate *)dateWithMonths:(NSInteger)months;
//日期距离当前时间N个月
+ (NSInteger)monthFromDate:(NSDate *)date;

//计算给定月份天数
+ (NSInteger)totaldaysInMonth:(NSDate *)date;
//计算给定月份第一天周几
+ (NSInteger)firstWeekdayInMonth:(NSDate *)date;
+ (BOOL)dayisWorkday:(NSDate *)date;

+ (NSInteger)day:(NSDate *)date;

+ (NSInteger)month:(NSDate *)date;
+ (BOOL)isSameDayBetween:(NSDate *)firstDate and:(NSDate *)secondDate;

@end
