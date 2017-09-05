//
//  DFCalendarMonthView.m
//  DFCalendar
//
//  Created by 全程恺 on 17/3/3.
//  Copyright © 2017年 全程恺. All rights reserved.
//

#import "DFCalendarMonthView.h"
#import "DFCalendarTool.h"

@interface DFCalendarMonthView () {
    
    NSDateFormatter *_monthDateF;
}

@property (strong, nonatomic)UIView *errorView;

@end

@implementation DFCalendarMonthView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _currentMonthView = [NSMutableArray array];
        
        _monthLB = [[UILabel alloc] initWithFrame:CGRectMake(kStyleCellPaddingLeft, 22, kScreenWidth - 30, 47)];
        _monthLB.textColor = HEXCOLOR(kColorBlackLight);
        [self addSubview:_monthLB];
        
        
        NSDateFormatter *dateF = [NSDateFormatter new];
        dateF.dateFormat = @"yyyy年MM月";
        _monthDateF = dateF;
        
        for (int i = 0; i < 6; i++) {
            
            //最多一个月只有6排
            DFCalendarWeekView *weekView = [[DFCalendarWeekView alloc] initWithFrame:CGRectMake(0, i * (30 + 10) + _monthLB.frame.origin.y + _monthLB.frame.size.height + 10, kScreenWidth, 38)];
            weekView.week = i;
            [_currentMonthView addObject:weekView];
            [self addSubview:weekView];
        }
    }
    
    return self;
}

- (void)setFromNowMonth:(NSInteger)fromNow {
    
    NSDate *targetDate = [DFCalendarTool dateWithMonths:fromNow];
    
    _monthLB.text = [_monthDateF stringFromDate:targetDate];
    
    NSInteger month = [DFCalendarTool month:targetDate];
    
    NSInteger currentDay = [DFCalendarTool day:targetDate];
    NSInteger days = [DFCalendarTool totaldaysInMonth:targetDate];
    NSInteger week = [DFCalendarTool firstWeekdayInMonth:targetDate];
    
    NSInteger weeks;
    NSCalendar *calendar = [DFCalendarTool sharedDFCalendarTool].calendar;
    if ((days + week) % 7 > 0)
    {
        weeks = (days + week)/7 + 1;
    }
    else
    {
        weeks = (days + week)/7;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDateComponents *dayComponent = [NSDateComponents new];
        
        NSMutableArray *daysArray = [NSMutableArray array];
        for (int i = 1; i <= weeks * 7; i ++)
        {
            dayComponent.day = i - currentDay - week;
            
            NSDate *date = [calendar dateByAddingComponents:dayComponent toDate:targetDate options:0];
            [daysArray addObject:date];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            DFCalendarWeekView *weekView;
            for (int i = 0; i < 7 * 6; i++) {
                
                weekView = _currentMonthView[i / 7];
                DFCalendarDayView *dayView = weekView.daysView[i % 7];
                
                if (i < daysArray.count) {
                    
                    BOOL isCurrentMonth = month == [DFCalendarTool month:daysArray[i]];
                    
                    if (isCurrentMonth) {
                        
                        dayView.isCurrentMonth = isCurrentMonth;
                        dayView.date = daysArray[i];
                        dayView.isWorkDay =[DFCalendarTool dayisWorkday:dayView.date];
                        dayView.isCurrentDay = [DFCalendarTool isSameDayBetween:dayView.date and:[NSDate date]];
                        [dayView setStatus];
                        
                        continue;
                    }
                }
                //还原初始状态
                [dayView emptyStatus];
            }
        });
    });
    
    DFCalendarWeekView *lastWeekView = _currentMonthView[weeks - 1];
    CGRect frame = self.frame;
    frame.size.height = CGRectGetMaxY(lastWeekView.frame) + 2;
    self.frame = frame;
    _monthFromNow = fromNow;
}

@end
