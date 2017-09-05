//
//  DFCalendarWeekView.h
//  DFCalendar
//
//  Created by 全程恺 on 17/3/3.
//  Copyright © 2017年 全程恺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFCalendarWeekView : UIView {
    
    CGFloat _itemWidth;
}

@property (assign, nonatomic) NSInteger week;

@property (retain, nonatomic) NSMutableArray *daysView;
@property (assign, nonatomic, readonly) BOOL containSelectDay;

- (void)addSubviews;

@end
