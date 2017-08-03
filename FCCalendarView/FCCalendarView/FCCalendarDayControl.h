//
//  FCCalendarDayControl.h
//  FCCalendarDemo
//
//  Created by yitudev12 on 2017/7/12.
//  Copyright © 2017年 yitu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 日期按钮
 */
@interface FCCalendarDayControl : UIControl

/// 时间戳
@property (nonatomic, assign) NSTimeInterval timeInterval;
/// 是否是当月
@property (nonatomic, assign) BOOL isCurrentMonthDay;
/// 是否是今天
@property (nonatomic, assign) BOOL isToday;
/// 是否已签到
@property (nonatomic, assign) BOOL isSign;
/// 文本
@property (nonatomic, strong) NSString *title;

/**
 回复成初始状态
 */
- (void)reSetSubViews;

@end
