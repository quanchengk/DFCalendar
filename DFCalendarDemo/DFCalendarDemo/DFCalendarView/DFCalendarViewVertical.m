//
//  DFCalendarViewVertical.m
//  DFCalendarDemo
//
//  Created by 全程恺 on 2017/5/9.
//  Copyright © 2017年 全程恺. All rights reserved.
//

#import "DFCalendarViewVertical.h"
#import "DFCalendarContentViewV.h"
#import "DFCalendarTool.h"

@interface DFCalendarViewVertical () 

@property (retain, nonatomic) DFCalendarContentViewV *calendarView;

@end

@implementation DFCalendarViewVertical

- (DFCalendarContentViewV *)calendarView {
    
    if (!_calendarView) {
        
        DFCalendarContentViewV *view = [[DFCalendarContentViewV alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavBarHeight)];
        view.showLaterTime = YES;
        _calendarView = view;
    }
    
    return _calendarView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectDays) name:kNotification_Select_Day object:nil];
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 35)];
        headerView.backgroundColor = HEXCOLOR(kColorGrayNormal);
        
        [self addSubview:headerView];
        
        CGFloat width = kScreenWidth / 7;
        
        NSArray *weekArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
        
        for (int i = 0; i < 7; i++)
        {
            UILabel * weekView= [[UILabel alloc]initWithFrame:CGRectMake(i * width, 0, width, 35)];
            weekView.textAlignment = NSTextAlignmentCenter;
            weekView.text = weekArray[i];
            weekView.font = [UIFont systemFontOfSize:13];
            weekView.textColor = [HEXCOLOR(kColorBlue) colorWithAlphaComponent:.5];
            [headerView addSubview:weekView];
        }
        
        UIView *line = [UIView new];
        line.backgroundColor = HEXCOLOR(kColorGrayLight);
        [headerView addSubview:line];
        
        [self addSubview:self.calendarView];
        
        _calendarView.frame = CGRectMake(0, CGRectGetMaxY(headerView.frame), kScreenWidth, kScreenHeight - CGRectGetMaxY(headerView.frame));
        _calendarView.date = [NSDate date];
    }
    
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)selectDays {
    
    NSUserDefaults *userDeafult = [NSUserDefaults standardUserDefaults];
    NSDate *from = [userDeafult objectForKey:kFromDateKey];
    NSDate *to = [userDeafult objectForKey:kToDateKey];
    
    NSDateFormatter *dateF = [NSDateFormatter new];
    dateF.dateFormat = @"yyyy.MM.dd";
        
    NSLog(@"开始日期：%@, 结束日期：%@", [dateF stringFromDate:from], [dateF stringFromDate:to]);
}

- (void)reset {
    
    NSUserDefaults *userDeafult = [NSUserDefaults standardUserDefaults];
    NSDate *from = [userDeafult objectForKey:kFromDateKey];
    NSDate *to = [userDeafult objectForKey:kToDateKey];
    
    if (from || to) {
        
        NSDateFormatter *sqlDateFormatter = [DFCalendarTool sharedDFCalendarTool].dateF;
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
    
    [DFHelper removeObjectForDestKey:kFromDateKey];
    [DFHelper removeObjectForDestKey:kToDateKey];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
