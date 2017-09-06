//
//  DFCalendarContentView.h
//  DFCalendarDemo
//
//  Created by 全程恺 on 2017/9/6.
//  Copyright © 2017年 全程恺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFCalendarTool.h"
#import "DFCalendarMonthView.h"

@interface DFCalendarContentView : UIScrollView <UIScrollViewDelegate> {
    
    NSMutableArray <DFCalendarMonthView *>* _monthViewArray;
}

@property (nonatomic, strong) NSDate *date;

- (void)loadPreviousPage;
- (void)loadNextPage;

@end
