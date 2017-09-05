//
//  ViewController.m
//  DFCalendarDemo
//
//  Created by 全程恺 on 2017/9/4.
//  Copyright © 2017年 全程恺. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)showHorizontalCalendar:(UIButton *)sender {
    
    [self showClass:@"DFCalendarViewHorizontal" fromSender:sender];
}

- (IBAction)showVerticalCalendar:(UIButton *)sender {
    
    [self showClass:@"DFCalendarViewVertical" fromSender:sender];
}

- (void)showClass:(NSString *)className fromSender:(UIButton *)sender {
    
    UIViewController *vc = [UIViewController new];
    vc.title = sender.titleLabel.text;
    vc.view.backgroundColor = [UIColor whiteColor];
    
    id calendar = [[NSClassFromString(className) alloc] initWithFrame:vc.view.bounds];
    [vc.view addSubview:calendar];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
