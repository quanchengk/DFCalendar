//
//  DFCalendarContentView.m
//  DFCalendarDemo
//
//  Created by 全程恺 on 2017/9/6.
//  Copyright © 2017年 全程恺. All rights reserved.
//

#import "DFCalendarContentView.h"

@implementation DFCalendarContentView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = HEXCOLOR(kColorGrayNormal);
        self.delegate = self;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES;
        
        _monthViewArray = [NSMutableArray array];
        
        for (int i = 0; i < 5; i++) {
            
            DFCalendarMonthView *monthView = [[DFCalendarMonthView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
            [_monthViewArray addObject:monthView];
            [self addSubview:monthView];
        }
    }
    
    return self;
}

- (void)loadPreviousPage {
    
    DFCalendarMonthView *monthView = [_monthViewArray lastObject];
    [_monthViewArray removeObject:monthView];
    
    [monthView setFromNowMonth:[_monthViewArray firstObject].monthFromNow - 1];
    [_monthViewArray insertObject:monthView atIndex:0];
}

- (void)loadNextPage {
    
    DFCalendarMonthView *monthView = [_monthViewArray firstObject];
    [_monthViewArray removeObject:monthView];
    
    [monthView setFromNowMonth:[_monthViewArray lastObject].monthFromNow + 1];
    [_monthViewArray addObject:monthView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
