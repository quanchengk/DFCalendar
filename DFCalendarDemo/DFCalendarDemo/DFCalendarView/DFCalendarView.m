//
//  DFCalendarView.m
//  DFCalendarDemo
//
//  Created by 全程恺 on 2017/9/6.
//  Copyright © 2017年 全程恺. All rights reserved.
//

#import "DFCalendarView.h"
#import "DFCalendarContentViewH.h"
#import "DFCalendarContentViewV.h"

@interface DFCalendarView () {
    
    DFCalendarContentViewH *_calendarViewH;
    DFCalendarContentViewV *_calendarViewV;
    id <DFCalendarDelegate> _delegate;
}

@end

@implementation DFCalendarView

- (instancetype)initWithFrame:(CGRect)frame type:(DFCalendarType)type delegate:(id<DFCalendarDelegate>)delegate {
    
    if (self = [super initWithFrame:frame]) {
        
        _delegate = delegate;
        
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
        
        UIView *line = [UIView new];
        line.backgroundColor = HEXCOLOR(kColorGrayLight);
        [weekTitleView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.bottom.equalTo(weekTitleView);
            make.height.mas_equalTo(.5);
        }];
        
        switch (type) {
            case DFCalendarHorizontal:
            {
                DFCalendarContentViewH *calendar = [[DFCalendarContentViewH alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(weekTitleView.frame), kScreenWidth, 0)];
                [self addSubview:calendar];
                _calendarViewH = calendar;
                _calendarViewH.date = [NSDate date];
            }
                break;
            case DFCalendarVertical:
            {
                DFCalendarContentViewV *calendar = [[DFCalendarContentViewV alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(weekTitleView.frame), kScreenWidth, kScreenHeight - CGRectGetMaxY(weekTitleView.frame))];
                [self addSubview:calendar];
                _calendarViewV = calendar;
                _calendarViewV.date = [NSDate date];
            }
                break;
            default:
                break;
        }
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
    
    if ([_delegate respondsToSelector:@selector(df_calendarDidSelectDaysFrom:to:)]) {
        
        NSUserDefaults *userDeafult = [NSUserDefaults standardUserDefaults];
        NSDate *from = [userDeafult objectForKey:kFromDateKey];
        NSDate *to = [userDeafult objectForKey:kToDateKey];
        
        [_delegate df_calendarDidSelectDaysFrom:from to:to];
    }
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
        
        [DFHelper removeObjectForDestKey:kFromDateKey];
        [DFHelper removeObjectForDestKey:kToDateKey];
        
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
