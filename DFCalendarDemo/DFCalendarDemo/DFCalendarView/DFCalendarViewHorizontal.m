//
//  DFCalendarViewHorizontal.m
//  DFCalendar
//
//  Created by 全程恺 on 17/3/3.
//  Copyright © 2017年 全程恺. All rights reserved.
//

#import "DFCalendarViewHorizontal.h"
#import "DFCalendarContentViewH.h"

@interface DFCalendarViewHorizontal () <UIScrollViewDelegate> {
    
    DFCalendarContentViewH *_calendarView;
}

@end

@implementation DFCalendarViewHorizontal

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectMonth:) name:kNotification_Change_Month object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectDays) name:kNotification_Select_Day object:nil];
        
        CGFloat width = kScreenWidth / 7;
        
        UIView *weekTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 26)];
        weekTitleView.backgroundColor= HEXCOLOR(kColorGrayNormal);
        NSArray *weekArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
        [self addSubview:weekTitleView];
        
        for (int i = 0; i < 7; i++)
        {
            UILabel * weekView= [[UILabel alloc]initWithFrame:CGRectMake(i * width, 0, width, weekTitleView.frame.size.height)];
            weekView.textAlignment = 1;
            weekView.text = weekArray[i];
            weekView.font = [UIFont systemFontOfSize:13];
            weekView.textColor = HEXCOLOR(kColorBlackLight);
            [weekTitleView addSubview:weekView];
        }
        
        DFCalendarContentViewH *calendar = [[DFCalendarContentViewH alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(weekTitleView.frame), kScreenWidth, 0)];
        [self addSubview:calendar];
        _calendarView = calendar;
        _calendarView.date = [NSDate date];
        
        [self selectDays];
    }
    
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)selectMonth:(NSNotification *)notification {
    
    NSString *monthStr = notification.object;
    NSString *year = [monthStr substringToIndex:4];
    NSString *month = [monthStr substringFromIndex:4];
    
    NSLog(@"%@-%@", year, month);
}

- (void)selectDays {
    
    NSUserDefaults *userDeafult = [NSUserDefaults standardUserDefaults];
    NSDate *from = [userDeafult objectForKey:kFromDateKey];
    NSDate *to = [userDeafult objectForKey:kToDateKey];
    
    NSDateFormatter *dateF = [NSDateFormatter new];
    dateF.dateFormat = @"yyyy.MM.dd";
    
    NSLog(@"%@ - %@", [dateF stringFromDate:from], [dateF stringFromDate:to]);
}

- (void)reset {
    
    NSUserDefaults *userDeafult = [NSUserDefaults standardUserDefaults];
    NSDate *from = [userDeafult objectForKey:kFromDateKey];
    NSDate *to = [userDeafult objectForKey:kToDateKey];
    
    if (from || to) {
        
        NSDateFormatter *sqlDateFormatter = [NSDateFormatter new];
        sqlDateFormatter.dateFormat = @"yyyy-MM-dd";
        
        do {
            
            NSString *name = [sqlDateFormatter stringFromDate:from];
            [[NSNotificationCenter defaultCenter] postNotificationName:name object:@(NO)];
            from = [from dateByAddingTimeInterval:24 * 60 * 60];
        } while ([from compare:to] != NSOrderedDescending);
        
        [userDeafult removeObjectForKey:kFromDateKey];
        [userDeafult removeObjectForKey:kToDateKey];
        [userDeafult synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_Select_Day object:nil];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
