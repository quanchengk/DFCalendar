//
//  CLIHelper.m
//  Created by psy on 16/10/9.
//  Copyright (c) 2015年 Danfort. All rights reserved.
//

#import "CLIHelper.h"

@implementation CLIHelper

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
