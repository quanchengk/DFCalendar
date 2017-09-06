//
//  DFCalendarViewVertical.m
//  DFCalendarDemo
//
//  Created by 全程恺 on 2017/5/9.
//  Copyright © 2017年 全程恺. All rights reserved.
//

#import "DFCalendarContentViewV.h"

@implementation DFCalendarContentViewV

- (void)layoutSubviews {
    
    [self resetData];
}

- (void)resetData {
    
    if(self.contentSize.height <= 0){
        
        return;
    }
    
    if(self.contentOffset.y < _monthViewArray[0].frame.size.height) {
        
        [self loadPreviousPage];
        
        [self resetMonthViewsFrame];
        
        self.contentOffset = CGPointMake(0, self.contentOffset.y + [_monthViewArray firstObject].frame.size.height);
    }
    else if(self.contentOffset.y > (_monthViewArray[_monthViewArray.count / 2].frame.origin.y + _monthViewArray[_monthViewArray.count / 2].frame.size.height)){
        
        if (_monthViewArray.lastObject.monthFromNow == 0 && !self.showLaterTime) {
            
            return;
        }
        [self loadNextPage];
        
        [self resetMonthViewsFrame];
        
        self.contentOffset = CGPointMake(0, self.contentOffset.y - [_monthViewArray lastObject].frame.size.height);
    }
}

- (void)resetMonthViewsFrame {
    
    __block CGFloat height = 0;
    [_monthViewArray enumerateObjectsUsingBlock:^(DFCalendarMonthView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGRect frame = obj.frame;
        if (idx == 0) {
            
            frame.origin.y = 0;
        }
        else
            frame.origin.y = _monthViewArray[idx - 1].frame.size.height + _monthViewArray[idx - 1].frame.origin.y;
        
        obj.frame = frame;
        height += obj.frame.size.height;
    }];
    self.contentSize = CGSizeMake(self.frame.size.width, height);
}

- (void)setDate:(NSDate *)date {
    
    [super setDate:date];
    
    NSInteger monthSpace = [DFCalendarTool monthFromDate:date];
    
    __block NSInteger midIdx = self.showLaterTime ? (_monthViewArray.count / 2) : (_monthViewArray.count - 1);
    __block CGFloat defaultOffsetY = 0;
    [_monthViewArray enumerateObjectsUsingBlock:^(DFCalendarMonthView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [obj setFromNowMonth:monthSpace - (midIdx - idx)];
        
        if (idx <= midIdx) {
            
            defaultOffsetY += obj.frame.size.height;
        }
    }];
    
    [self resetMonthViewsFrame];
    self.contentOffset = CGPointMake(0, self.showLaterTime ? defaultOffsetY : (self.contentSize.height - self.frame.size.height));
}

@end
