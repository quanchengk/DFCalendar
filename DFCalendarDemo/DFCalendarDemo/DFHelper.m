//
//  DFHelper.m
//  Created by 全程恺 on 16/10/9.
//  Copyright (c) 2015年 Danfort. All rights reserved.
//

#import "DFHelper.h"

@implementation DFHelper

+ (id)getTargetClass:(Class)className fromObject:(id)obj
{
    UIResponder *next = [obj nextResponder];
    do {
        if ([next isKindOfClass:[className class]]) {
            
            return next;
        }
        next =[next nextResponder];
    }
    while (next != nil);
    
    return nil;
}

#pragma mark - NSUserDefaults

+ (void)setObject:(id)destObj forDestKey:(NSString *)destKey
{
    [[NSUserDefaults standardUserDefaults] setObject:destObj forKey:destKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)objectForDestKey:(NSString *)destkey
{
    id object = nil;
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    object = [[NSUserDefaults standardUserDefaults] objectForKey:destkey];
    return object;
}

+ (void)removeObjectForDestKey:(NSString *)destkey
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:destkey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
