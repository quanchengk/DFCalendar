//
//  DFCalendarContentViewH.m
//  DFCalendar
//
//  Created by 全程恺 on 17/3/3.
//  Copyright © 2017年 全程恺. All rights reserved.
//

#import "DFCalendarContentViewH.h"
#import "DFCalendarWeekView.h"

@interface DFCalendarContentViewH () <UIScrollViewDelegate>  {
    
    NSInteger _preCenterMonthIndex;
    NSInteger _centerMonthIndex;
    NSMutableArray <DFCalendarMonthView *>*_monthViewArray;
}

@end

@implementation DFCalendarContentViewH

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

- (void)setDate:(NSDate *)date {
    
    _date = date;
    
    _centerMonthIndex = _preCenterMonthIndex = [DFCalendarTool monthFromDate:date];
    
    [self resetData];
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

- (void)resetData {
    
    if (_preCenterMonthIndex == _centerMonthIndex) {
        
        __block NSInteger midIdx = _monthViewArray.count / 2;
        [_monthViewArray enumerateObjectsUsingBlock:^(DFCalendarMonthView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [obj setFromNowMonth:_centerMonthIndex - (midIdx - idx)];
        }];
    }
    else if (_preCenterMonthIndex < _centerMonthIndex) {
        
        //往大月份滑动
        DFCalendarMonthView *monthView = [_monthViewArray firstObject];
        [_monthViewArray removeObject:monthView];
        
        [monthView setFromNowMonth:[_monthViewArray lastObject].monthFromNow + 1];
        [_monthViewArray addObject:monthView];
    }
    else if (_preCenterMonthIndex > _centerMonthIndex) {
        
        //往小月份滑动
        DFCalendarMonthView *monthView = [_monthViewArray lastObject];
        [_monthViewArray removeObject:monthView];
        
        [monthView setFromNowMonth:[_monthViewArray firstObject].monthFromNow - 1];
        [_monthViewArray insertObject:monthView atIndex:0];
    }
    
    [self resetMonthViewsFrame];
}

- (DFCalendarMonthView *)addMonthFromNowOn:(NSInteger)fromNow {
    
    DFCalendarMonthView *collectionView = [[DFCalendarMonthView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    [collectionView setFromNowMonth:fromNow];
    
    return collectionView;
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
