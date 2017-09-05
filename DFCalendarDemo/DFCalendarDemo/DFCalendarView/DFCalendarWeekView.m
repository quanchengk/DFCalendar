//
//  DFCalendarWeekView.m
//  DFCalendar
//
//  Created by 全程恺 on 17/3/3.
//  Copyright © 2017年 全程恺. All rights reserved.
//

#import "DFCalendarWeekView.h"
#import "DFCalendarDayView.h"

@implementation DFCalendarWeekView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _daysView = [NSMutableArray array];
        _itemWidth = kScreenWidth / 7;
        
        for (int i = 0; i < 7; i ++) {
            
            //一周七天
            DFCalendarDayView *dayView = [DFCalendarDayView buttonWithType:UIButtonTypeCustom];
            dayView.frame = CGRectMake(i % 7 * _itemWidth, 0, _itemWidth, 35);
            [_daysView addObject:dayView];
            [self addSubview:dayView];
        }
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
