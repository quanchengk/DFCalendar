//
//  DFCalendarViewVertical.m
//  DFCalendarDemo
//
//  Created by 全程恺 on 2017/5/9.
//  Copyright © 2017年 全程恺. All rights reserved.
//

#import "DFCalendarContentViewV.h"
#import "DFCalendarTool.h"

@implementation DFCalendarContentViewV {
    
    NSMutableArray<DFCalendarMonthView *> *_monthViews;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        
        _monthViews = [NSMutableArray array];
        
        for (int i = 0; i < 5; i++) {
            
            DFCalendarMonthView *monthView = [[DFCalendarMonthView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
            [_monthViews addObject:monthView];
            [self addSubview:monthView];
        }
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [self viewDidScroll];
}

- (void)viewDidScroll {
    
    if(self.contentSize.height <= 0){
        return;
    }
    
    if(self.contentOffset.y < _monthViews[0].frame.size.height) {
        
        [self loadPreviousPage];
    }
    else if(self.contentOffset.y > (_monthViews[_monthViews.count / 2].frame.origin.y + _monthViews[_monthViews.count / 2].frame.size.height)){
        
        if (_monthViews.lastObject.monthFromNow == 0 && !self.showLaterTime) {
            
            return;
        }
        [self loadNextPage];
    }
}

- (void)loadPreviousPage {
    
    DFCalendarMonthView *tmpView = _monthViews.lastObject;
    [_monthViews insertObject:tmpView atIndex:0];
    [_monthViews removeLastObject];
    
    [tmpView setFromNowMonth:_monthViews[1].monthFromNow - 1];
    
    [self resetMonthViewsFrame];
    
    self.contentOffset = CGPointMake(0, self.contentOffset.y + tmpView.frame.size.height);
}

- (void)loadNextPage {
    
    DFCalendarMonthView *tmpView = _monthViews.firstObject;
    [_monthViews addObject:tmpView];
    [_monthViews removeObjectAtIndex:0];
    
    [tmpView setFromNowMonth:_monthViews[_monthViews.count - 2].monthFromNow + 1];
    
    [self resetMonthViewsFrame];
    
    self.contentOffset = CGPointMake(0, self.contentOffset.y - tmpView.frame.size.height);
}

- (void)resetMonthViewsFrame {
    
    __block CGFloat height = 0;
    [_monthViews enumerateObjectsUsingBlock:^(DFCalendarMonthView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGRect frame = obj.frame;
        if (idx == 0) {
            
            frame.origin.y = 0;
        }
        else
            frame.origin.y = _monthViews[idx - 1].frame.size.height + _monthViews[idx - 1].frame.origin.y;
        
        obj.frame = frame;
        height += obj.frame.size.height;
    }];
    self.contentSize = CGSizeMake(self.frame.size.width, height);
}

- (void)setDate:(NSDate *)date {
    
    _date = date;
    
    NSInteger monthSpace = [DFCalendarTool monthFromDate:date];
    
    __block NSInteger midIdx = self.showLaterTime ? (_monthViews.count / 2) : (_monthViews.count - 1);
    __block CGFloat defaultOffsetY = 0;
    [_monthViews enumerateObjectsUsingBlock:^(DFCalendarMonthView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [obj setFromNowMonth:monthSpace - (midIdx - idx)];
        
        if (idx <= midIdx) {
            
            defaultOffsetY += obj.frame.size.height;
        }
    }];
    
    [self resetMonthViewsFrame];
    self.contentOffset = CGPointMake(0, self.showLaterTime ? defaultOffsetY : (self.contentSize.height - self.frame.size.height));
}

@end
