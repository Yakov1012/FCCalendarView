//
//  FCCalendarView.h
//  FCCalendarDemo
//
//  Created by yitudev12 on 2017/7/12.
//  Copyright © 2017年 yitu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 日历视图
 */
@interface FCCalendarView : UIView

/// 已累计签到天数
@property (nonatomic, strong) NSString *signedCount;
/// 已签到数组
@property (nonatomic, strong) NSMutableArray *signedArr;
/// 点击上月或下月的回调
@property (nonatomic, copy) void(^lastOrNextMonthBlock)(NSDate *date);

/**
 显示
 */
- (void)show;

@end
