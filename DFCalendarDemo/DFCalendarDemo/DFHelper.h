//
//  DFHelperHelper.h
//  Created by 全程恺 on 16/10/9.
//  Copyright (c) 2016年 Danfort. All rights reserved.
//  工具类

#define kColorBlackLight  0x666666   //浅黑
#define kColorGrayNormal  0xf3f4f6   //正常灰
#define kColorGrayLight   0xe2e2e2   //浅灰（线的颜色）
#define kColorWhite       0xffffff    //白色
#define kColorBlue        0x0366c1    //蓝色

// 十六进制颜色设置
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kStyleCellPaddingLeft 14
#define kStyleButtonCornerRadius 4

#import <UIKit/UIKit.h>

@interface DFHelper : UIControl <UIAlertViewDelegate>


/**
 *  获取最底层的某个类
 *
 *  @param className 要获取的类名
 *  @param obj       从obj往父视图便利
 *
 *  @return 检测到要获取的实例，就把这个实例返回
 */
+ (id)getTargetClass:(Class)className fromObject:(id)obj;

// 添加
+ (void)setObject:(id)destObj forDestKey:(NSString *)destKey;
// 读取
+ (id)objectForDestKey:(NSString *)destkey;
// 删除
+ (void)removeObjectForDestKey:(NSString *)destkey;

@end
