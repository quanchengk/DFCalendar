//
//  DFCalendarContentViewH.m
//  DFCalendar
//
//  Created by 全程恺 on 17/3/3.
//  Copyright © 2017年 全程恺. All rights reserved.
//

#import "DFCalendarContentViewH.h"
#import "DFCalendarWeekView.h"

@interface DFCalendarContentViewH ()   {
    
    NSInteger _preCenterMonthIndex;
    NSInteger _centerMonthIndex;
}

@end

@implementation DFCalendarContentViewH

- (void)setDate:(NSDate *)date {
    
    [super setDate:date];
    
    _centerMonthIndex = _preCenterMonthIndex = [DFCalendarTool monthFromDate:date];
    
    [self resetData];
}

- (void)resetData {
    
    if (_preCenterMonthIndex == _centerMonthIndex) {
        
        __block NSInteger midIdx = _monthViewArray.count / 2;
        [_monthViewArray enumerateObjectsUsingBlock:^(DFCalendarMonthView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [obj setFromNowMonth:_centerMonthIndex - (midIdx - idx)];
        }];
    }
    else if (_preCenterMonthIndex < _centerMonthIndex) {
        
        //往大月份滑动
        [self loadNextPage];
    }
    else if (_preCenterMonthIndex > _centerMonthIndex) {
        
        //往小月份滑动
        [self loadPreviousPage];
    }
    
    [self resetMonthViewsFrame];
}

- (void)resetMonthViewsFrame {
    
    for (int i = 0; i < _monthViewArray.count; i++) {
        
        DFCalendarMonthView *monthView = _monthViewArray[i];
        monthView.frame = CGRectMake((i - 1) * kScreenWidth, 0, kScreenWidth, CGRectGetHeight(monthView.frame));
    }
    
    NSInteger index = _monthViewArray.count / 2;
    DFCalendarMonthView *middleView = _monthViewArray[index];
    CGFloat contentHeight = CGRectGetHeight(middleView.frame);
    self.contentSize = CGSizeMake(3 * kScreenWidth, contentHeight);
    self.contentOffset = CGPointMake(kScreenWidth, 0);
    self.userInteractionEnabled = YES;
    [UIView animateWithDuration:.2 animations:^{
        
        CGRect frame = self.frame;
        frame.size.height = contentHeight;
        self.frame = frame;
        
        middleView.alpha = 1;
    }];
    
    NSDate *targetDate = [DFCalendarTool dateWithMonths:_centerMonthIndex];
    
    NSInteger month = [DFCalendarTool month:targetDate];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_Change_Month object:[@(month) stringValue]];
    
    _preCenterMonthIndex = _centerMonthIndex;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat centerX = CGRectGetMidX(scrollView.frame);
    
    [_monthViewArray enumerateObjectsUsingBlock:^(DFCalendarMonthView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat viewCenterX = [self convertPoint:obj.center toView:self.superview].x;
        CGFloat alpha = 1 - fabs(viewCenterX - centerX) / centerX;
        obj.alpha = MAX(alpha, .2);
    }];
    
    scrollView.userInteractionEnabled = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x / scrollView.frame.size.width < 1) {
        
        _centerMonthIndex--;
    }
    else if (scrollView.contentOffset.x / scrollView.frame.size.width >= 2) {
        
        _centerMonthIndex++;
    }
    
    if (_preCenterMonthIndex != _centerMonthIndex) {
        
        [self resetData];
    }
    
    scrollView.userInteractionEnabled = YES;
}

@end
