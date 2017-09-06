//
//  ViewController.m
//  DFCalendarDemo
//
//  Created by 全程恺 on 2017/9/4.
//  Copyright © 2017年 全程恺. All rights reserved.
//

#import "ViewController.h"
#import "DFCalendarView.h"

@interface ViewController () <DFCalendarDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)showHorizontalCalendar:(UIButton *)sender {
    
    [self showCalendar:DFCalendarHorizontal fromSender:sender];
}

- (IBAction)showVerticalCalendar:(UIButton *)sender {
    
    [self showCalendar:DFCalendarVertical fromSender:sender];
}

- (void)showCalendar:(DFCalendarType)type fromSender:(UIButton *)sender {
    
    UIViewController *vc = [UIViewController new];
    vc.title = sender.titleLabel.text;
    vc.view.backgroundColor = HEXCOLOR(kColorWhite);
    
    DFCalendarView *calendar = [[DFCalendarView alloc] initWithFrame:vc.view.bounds type:type delegate:self];
    [vc.view addSubview:calendar];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - delegate
- (void)df_calendarDidSelectDaysFrom:(NSDate *)fromDate to:(NSDate *)toDate {
    
    NSDateFormatter *dateF = [NSDateFormatter new];
    dateF.dateFormat = @"yyyy.MM.dd";
    
    NSLog(@"开始日期：%@, 结束日期：%@", [dateF stringFromDate:fromDate], [dateF stringFromDate:toDate]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
