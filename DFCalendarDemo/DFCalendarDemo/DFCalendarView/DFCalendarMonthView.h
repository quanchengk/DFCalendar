//
//  DFCalendarMonthView.h
//  DFCalendar
//
//  Created by 全程恺 on 17/3/3.
//  Copyright © 2017年 全程恺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFCalendarDayView.h"
#import "DFCalendarWeekView.h"

@interface DFCalendarMonthView : UIView {

    CGFloat _width;
    UILabel *_monthLB;
}

@property (retain, nonatomic, readonly) NSMutableArray *currentMonthView;
@property (assign, nonatomic, readonly) NSInteger monthFromNow;

- (void)setFromNowMonth:(NSInteger)fromNow;

@end
