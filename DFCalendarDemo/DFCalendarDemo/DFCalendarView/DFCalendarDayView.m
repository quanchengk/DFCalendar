//
//  DFCalendarDayView.m
//  DFCalendar
//
//  Created by 全程恺 on 17/3/3.
//  Copyright © 2017年 全程恺. All rights reserved.
//

#import "DFCalendarDayView.h"
#import "DFCalendarViewVertical.h"
#import "DFCalendarViewHorizontal.h"

typedef NS_OPTIONS(NSUInteger, DFCalendarDayType) {
    
    DFCalendarDayTypeNone,
    DFCalendarDayTypePeakStart,  //起始顶点，向右扩展
    DFCalendarDayTypePeakEnd,   //终点顶点，向左扩展
    DFCalendarDayTypePeakOnly,  //唯一的顶点，左右都不需要扩展
    DFCalendarDayTypeArea,  //区间
};

@interface DFCalendarDayView ()

@property (assign, nonatomic) DFCalendarDayType drawType;
@property (retain, nonatomic) NSDateFormatter *sqlDateFormatter;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation DFCalendarDayView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        CGFloat width = kScreenWidth / 7;
        
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 35)];
        _dateLabel.textAlignment = 1;
        _dateLabel.userInteractionEnabled = NO;
        _dateLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_dateLabel];
        
        [self addTarget:self action:@selector(select) forControlEvents:UIControlEventTouchUpInside];
        
        _thirdClickCancelArea = YES;
    }
    
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    
    if (self.isCurrentMonth) {
        
        _dateLabel.text = [@([[self.dateFormatter stringFromDate:date] integerValue]) stringValue];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadState:) name:[self.sqlDateFormatter stringFromDate:date] object:nil];
        
        self.userInteractionEnabled = YES;
    }
}

- (void)setDrawType:(DFCalendarDayType)drawType {
    
    if (_drawType != drawType) {
        
        _drawType = drawType;
        
        [self setNeedsDisplay];
    }
}

- (NSDateFormatter *)sqlDateFormatter {
    
    if (!_sqlDateFormatter) {
        
        _sqlDateFormatter = [DFCalendarTool sharedDFCalendarTool].dateF;
    }
    _sqlDateFormatter.dateFormat = @"yyyy-MM-dd";
    
    return _sqlDateFormatter;
}

- (NSDateFormatter *)dateFormatter {
    
    if (!_dateFormatter) {
        
        NSDateFormatter *dateFormatter = [DFCalendarTool sharedDFCalendarTool].dateF;
        _dateFormatter = dateFormatter;
    }
    
    [_dateFormatter setDateFormat:@"dd"];
    
    return _dateFormatter;
}

- (void)reloadState:(NSNotification *)notification {
    
    BOOL show = [notification.object boolValue];
    
    if (show) {
        [self setStatus];
    }
    else
        [self initStatus];
}

- (void)setStatus {
    
    NSDate *from = [CLIHelper objectForDestKey:kFromDateKey];
    NSDate *to = [CLIHelper objectForDestKey:kToDateKey];
    
    if ([self.date isEqualToDate:from] || [self.date isEqualToDate:to]) {
        
        if ([from compare:to] == NSOrderedSame) {
            
            self.drawType = DFCalendarDayTypePeakOnly;
        }
        else if ([self.date isEqualToDate:from]) {
            
            self.drawType = DFCalendarDayTypePeakStart;
        }
        else if ([self.date isEqualToDate:to]) {
            
            self.drawType = DFCalendarDayTypePeakEnd;
        }
        
        _dateLabel.textColor = HEXCOLOR(kColorWhite);
    }
    else if ([self.date compare:from] == NSOrderedDescending && [self.date compare:to] == NSOrderedAscending) {
        
        self.drawType = DFCalendarDayTypeArea;
        _dateLabel.textColor = HEXCOLOR(kColorWhite);
    }
    else {
        
        [self initStatus];
    }
}

- (void)initStatus {
    
    self.drawType = DFCalendarDayTypeNone;
    
    if (self.isCurrentMonth) {
        
        _dateLabel.textColor = HEXCOLOR(kColorBlue);
    }
    else {
        
        _dateLabel.textColor = HEXCOLOR(kColorBlackLight);
    }
    
    if ([self.date compare:[NSDate date]] == NSOrderedDescending) {
        
        _dateLabel.textColor = [HEXCOLOR(kColorBlue) colorWithAlphaComponent:.3];
    }
}

- (void)select {
    
    NSDate *from = [CLIHelper objectForDestKey:kFromDateKey];
    NSDate *to = [CLIHelper objectForDestKey:kToDateKey];
    
    //点第三个内容时，根据属性判断是否要移除之前选择的内容
    if (_thirdClickCancelArea && from && to && ![from isEqualToDate:to]) {
        
        id superView = [CLIHelper getTargetClass:[DFCalendarViewVertical class] fromObject:self];
        if (!superView) superView = [CLIHelper getTargetClass:[DFCalendarViewHorizontal class] fromObject:self];
        
        if ([superView respondsToSelector:@selector(reset)]) {
            
            [superView performSelector:@selector(reset)];
            
            from = nil;
            to = nil;
        }
    }
    
    if (!from && !to) {
        
        from = self.date;
        to = self.date;
    }
    else {
        
        [self sendNotification:NO];
        //如果当前时间和选中时间重叠，表示双击，隐藏当前选中
        if ([from compare:self.date] == NSOrderedSame) {
            
            if ([to compare:self.date] == NSOrderedSame) {
                
                //开始、结束日期为同一天，并且再次选中这一天，则左右选择都取消
                
                [CLIHelper removeObjectForDestKey:kFromDateKey];
                [CLIHelper removeObjectForDestKey:kToDateKey];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_Select_Day object:nil];
                return;
            }
            else
                from = to;
        }
        else if ([to compare:self.date] == NSOrderedSame) {
            
            to = from;
        }
        //判断当前时间早/晚于之前的选中
        else if ([from compare:self.date] == NSOrderedDescending) {
            
            //当前时间早于起点时间，则当前时间设置为起点
            from = self.date;
        }
        else if ([to compare:self.date] == NSOrderedAscending) {
            
            //当前时间晚于终点时间，则当前时间设置为终点
            to = self.date;
        }
        else if ([from compare:self.date] == NSOrderedAscending && [to compare:self.date] == NSOrderedDescending) {
            
            //选中的日期被夹在中间，则选择就近时间靠拢
            NSInteger startToNow = ABS([from timeIntervalSinceDate:self.date]);
            NSInteger endToNow = ABS([to timeIntervalSinceDate:self.date]);
            if (startToNow > endToNow) {
                
                to = self.date;
            }
            else
                from = self.date;
        }
    }
    
    if ([from compare:[NSDate date]] == NSOrderedDescending ||
        [to compare:[NSDate date]] == NSOrderedDescending) {
        
        NSDateComponents *comp = [[DFCalendarTool sharedDFCalendarTool].calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
        NSDate *date =  [[DFCalendarTool sharedDFCalendarTool].calendar dateFromComponents:comp];
        
        if ([from compare:[NSDate date]] == NSOrderedDescending) {
            
            from = date;
        }
        
        if ([to compare:[NSDate date]] == NSOrderedDescending) {
            
            to = date;
        }
        
        NSLog(@"所选日期超出当前时间，已为您自动选择到今天");
    }
    
    [CLIHelper setObject:from forDestKey:kFromDateKey];
    [CLIHelper setObject:to forDestKey:kToDateKey];
    
    [self sendNotification:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_Select_Day object:nil];
}

- (void)sendNotification:(BOOL)showHightLight {
    
    NSDate *from = [CLIHelper objectForDestKey:kFromDateKey];
    NSDate *to = [CLIHelper objectForDestKey:kToDateKey];
    
    do {
        
        NSString *name = [self.sqlDateFormatter stringFromDate:from];
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:@(showHightLight)];
        from = [from dateByAddingTimeInterval:24 * 60 * 60];
    } while ([from compare:to] != NSOrderedDescending);
}

- (void)emptyStatus {
    
    _dateLabel.text = @"";
    
    self.drawType = DFCalendarDayTypeNone;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.userInteractionEnabled = NO;
}

- (void)drawRect:(CGRect)rect {
    
    if (!self.isCurrentMonth) {
        
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat space = (self.frame.size.height - 31) / 2.0;
    CGContextSetLineWidth(context, .0);
    [HEXCOLOR(kColorBlue) set];
    switch (self.drawType) {
        case DFCalendarDayTypePeakStart:
        case DFCalendarDayTypePeakEnd:
        case DFCalendarDayTypePeakOnly: {
            
            if (self.drawType == DFCalendarDayTypePeakStart) {
                
                CGContextAddRect(context, UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(space, self.frame.size.width / 2, space, 0)));
                CGContextDrawPath(context, kCGPathFillStroke);
            }
            else if (self.drawType == DFCalendarDayTypePeakEnd) {
                
                CGContextAddRect(context, UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(space, 0, space, self.frame.size.width / 2)));
                CGContextDrawPath(context, kCGPathFillStroke);
            }
            
            //画圈
//            [HEXCOLOR(kColorBlue) set];
            CGContextAddArc(context, self.frame.size.width / 2, self.frame.size.height / 2, self.frame.size.height / 2 - space, 0, M_PI * 2, 0);
            CGContextDrawPath(context, kCGPathFill);
        }
            break;
            
        case DFCalendarDayTypeArea: {
            
            CGContextAddRect(context, UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(space, 0, space, 0)));
            CGContextDrawPath(context, kCGPathFillStroke);
        }
            break;
        default:
            
            break;
    }
}

@end
