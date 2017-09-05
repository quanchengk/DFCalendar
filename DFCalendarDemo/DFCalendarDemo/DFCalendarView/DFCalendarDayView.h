//
//  DFCalendarDayView.h
//  DFCalendar
//
//  Created by 全程恺 on 17/3/3.
//  Copyright © 2017年 全程恺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFCalendarTool.h"

@interface DFCalendarDayView : UIButton {
    
    BOOL _thirdClickCancelArea; //第三下选中是否取消起、终点
    UILabel *_dateLabel;
    UIColor *_defaultBackgroundColor;
    UIColor *_selectBackgroundColor;
    UIColor *_defaultTextColor;
    UIColor *_selectTextColor;
}

@property (strong, nonatomic) NSDate *date;
@property (assign, nonatomic) BOOL isCurrentMonth;
@property (assign, nonatomic) BOOL isCurrentDay;
@property (assign, nonatomic) BOOL isWorkDay;

//默认状态（有别于初始化状态）
- (void)setStatus;

//还原空白状态，外部重用时调用
- (void)emptyStatus;
@end
