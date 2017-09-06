//
//  DFCalendarView.h
//  DFCalendarDemo
//
//  Created by 全程恺 on 2017/9/6.
//  Copyright © 2017年 全程恺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFCalendarTool.h"

typedef NS_ENUM(NSInteger, DFCalendarType) {
    
    DFCalendarHorizontal,
    DFCalendarVertical
};

@interface DFCalendarView : UIView

- (instancetype)initWithFrame:(CGRect)frame type:(DFCalendarType)type delegate:(id<DFCalendarDelegate>)delegate;
- (void)reset;
@end
