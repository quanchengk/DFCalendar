//
//  DFCalendarViewVertical.h
//  DFCalendarDemo
//
//  Created by 全程恺 on 2017/5/9.
//  Copyright © 2017年 全程恺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFCalendarMonthView.h"

@class DFCalendarContentViewV;

@interface DFCalendarContentViewV : UIScrollView

@property (assign, nonatomic) BOOL showLaterTime;
@property (nonatomic, strong) NSDate *date;

@end
