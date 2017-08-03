//
//  FCCalendarView.m
//  FCCalendarDemo
//
//  Created by yitudev12 on 2017/7/12.
//  Copyright © 2017年 yitu. All rights reserved.
//

#import "FCCalendarView.h"

#import "FCCalendarTool.h"
#import "FCCalendarDayControl.h"
#import "YYLabel.h"
#import "NSAttributedString+YYText.h"
#import "UIButton+ExpandResponse.h"

@interface FCCalendarView ()

/// 背景视图
@property (nonatomic, strong) UIImageView *bgImgView;
/// 累计签到天数
@property (nonatomic, strong) YYLabel *totalSignCountLabel;
/// 年月背景
@property (nonatomic, strong) UIView *yearMonthbgImgView;
/// 上月
@property (nonatomic, strong) UIButton *lastMonthButton;
/// 年月
@property (nonatomic, strong) UILabel *yearMonthLabel;
/// 下月
@property (nonatomic, strong) UIButton *nextMonthButton;
/// 周
@property (nonatomic, strong) UIView *weekbgImgView;
/// 日历背景
@property (nonatomic, strong) UIView *calendarbgImgView;


/// 日期
@property (nonatomic, strong) NSDate *date;
/// 日期按钮数组
@property (nonatomic, strong) NSMutableArray *calendarBtnArr;

@end

@implementation FCCalendarView

#pragma mark - LifyCycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    if (self) {
        // 加单击
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
        [self addGestureRecognizer:tap];
        
        // 隐藏
        self.hidden = YES;
        // 添加子视图
        [self setUpSubViews];
    }
    return self;
}

/**
 添加子视图
 */
- (void)setUpSubViews {
    [self addSubview:self.bgImgView];
    [self.bgImgView addSubview:self.totalSignCountLabel];
    [self.bgImgView addSubview:self.yearMonthbgImgView];
    [self.yearMonthbgImgView addSubview:self.lastMonthButton];
    [self.yearMonthbgImgView addSubview:self.yearMonthLabel];
    [self.yearMonthbgImgView addSubview:self.nextMonthButton];
    [self.bgImgView addSubview:self.weekbgImgView];
    [self.bgImgView addSubview:self.calendarbgImgView];
    
    [self refreshUI];
}

#pragma mark - Set
- (void)setSignedCount:(NSString *)signedCount {
    _signedCount = signedCount;
    
    [self refreshUI];
}

- (void)setSignedArr:(NSMutableArray *)signedArr {
    _signedArr = signedArr;
    
    [self refreshUI];
}

#pragma mark - Lazy Load
- (UIView *)bgImgView {
    if (!_bgImgView) {
        CGFloat bgWidth = self.frame.size.width - 2 * 25.0;
        CGFloat itemWidth = (bgWidth - 2 * 30.0) / 7;
        CGFloat bgImgViewHeight = 40.0 + 20.0 + 20.0 + 30.0 + 10.0 + 20.0 + 10.0 + itemWidth * 6 + 35.0;
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(36.0, (self.frame.size.height - bgImgViewHeight)/2, self.frame.size.width - 2 * 36.0, bgImgViewHeight)];
        _bgImgView.userInteractionEnabled = YES;
        _bgImgView.image = YTImageResizable(@"Sign/Sign_Bg");
    }
    return _bgImgView;
}

- (YYLabel *)totalSignCountLabel {
    if (!_totalSignCountLabel) {
        _totalSignCountLabel = [[YYLabel alloc] initWithFrame:CGRectMake(0.0, 40.0, self.bgImgView.width, 20.0)];
        
        _totalSignCountLabel.textColor = YTColorByNumber(2);
        _totalSignCountLabel.font = YTFont(7);
        _totalSignCountLabel.textAlignment = NSTextAlignmentCenter;
        
        [self refreshTotalSignCountLabel];
    }
    return _totalSignCountLabel;
}

- (UIView *)yearMonthbgImgView {
    if (!_yearMonthbgImgView) {
        _yearMonthbgImgView = [[UIView alloc] initWithFrame:CGRectMake(30.0, self.totalSignCountLabel.bottom + 20.0, self.bgImgView.width - 2 * 30.0, 30.0)];
    }
    return _yearMonthbgImgView;
}

- (UIButton *)lastMonthButton {
    if (!_lastMonthButton) {
        UIImage *lastImage = YTImage(@"Sign/Sign_Last");
        _lastMonthButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
        [_lastMonthButton setImage:lastImage forState:UIControlStateNormal];
        [_lastMonthButton setEnlargeEdge:20.0];
        [_lastMonthButton addTarget:self action:@selector(lastMonthButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lastMonthButton;
}

- (UILabel *)yearMonthLabel {
    if (!_yearMonthLabel) {
        _yearMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.yearMonthbgImgView.width - 100.0)/2, 0.0, 100.0, 30.0)];
        _yearMonthLabel.textAlignment = NSTextAlignmentCenter;
        _yearMonthLabel.textColor = YTColorByNumber(4);
        _yearMonthLabel.font = YTFont(5);
    }
    return _yearMonthLabel;
}

- (UIButton *)nextMonthButton {
    if (!_nextMonthButton) {
        UIImage *nextImage = YTImage(@"Sign/Sign_Next");
        _nextMonthButton = [[UIButton alloc] initWithFrame:CGRectMake(self.yearMonthbgImgView.width - 30.0, 0.0, 30.0, 30.0)];
        [_nextMonthButton setImage:nextImage forState:UIControlStateNormal];
        [_nextMonthButton setEnlargeEdge:20.0];
        [_nextMonthButton addTarget:self action:@selector(nextMonthButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextMonthButton;
}

- (UIView *)weekbgImgView {
    if (!_weekbgImgView) {
        _weekbgImgView = [[UIView alloc] initWithFrame:CGRectMake(30.0, self.yearMonthbgImgView.bottom + 10.0, self.bgImgView.width - 2 * 30.0, 20.0)];
        
        // 周日 ~ 周六
        CGFloat itemWidth = (self.bgImgView.frame.size.width - 2 * 30.0) / 7;
        CGFloat itemHeight = 20.0;
        NSArray *array = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
        for (int i = 0; i < 7; i++) {
            UILabel *weekItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * itemWidth, 0.0, itemWidth, itemHeight)];
            weekItemLabel.text = array[i];
            weekItemLabel.textColor = YTColorByNumber(5);
            weekItemLabel.font = YTBoldFont(2);
            weekItemLabel.textAlignment = NSTextAlignmentCenter;
            weekItemLabel.backgroundColor = [UIColor clearColor];
            [_weekbgImgView addSubview:weekItemLabel];
        }
    }
    return _weekbgImgView;
}


- (UIView *)calendarbgImgView {
    if (!_calendarbgImgView) {
        // 创建42个按钮
        CGFloat itemWidth = (self.bgImgView.frame.size.width - 2 * 30.0) / 7;
        
        _calendarbgImgView = [[UIButton alloc] initWithFrame:CGRectMake(30.0, self.weekbgImgView.bottom + 10.0, self.bgImgView.frame.size.width - 2 * 30.0, itemWidth * 6)];
        _calendarbgImgView.backgroundColor = [UIColor whiteColor];
        
        for (NSInteger i = 0; i < 42; i ++) {
            FCCalendarDayControl *calendarDayControl = [[FCCalendarDayControl alloc] initWithFrame:CGRectMake((i % 7) * itemWidth, i / 7 * itemWidth, itemWidth, itemWidth)];
            [_calendarbgImgView addSubview:calendarDayControl];
            [self.calendarBtnArr addObject:calendarDayControl];
        }
    }
    return _calendarbgImgView;
}

- (NSDate *)date {
    if (!_date) {
        _date = [NSDate date];
    }
    return _date;
}

- (NSMutableArray *)calendarBtnArr {
    if (!_calendarBtnArr) {
        _calendarBtnArr = @[].mutableCopy;
    }
    return _calendarBtnArr;
}

#pragma mark - Action
- (void)singleTapGesture:(UITapGestureRecognizer *)tap {
    UIView *subView = self.bgImgView;
    if (!CGRectContainsPoint(subView.frame, [tap locationInView:self])) {
        [self customHidden];
    }
}

- (void)customHidden {
    [UIView animateWithDuration:0.25f
                     animations:^{
                         self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             self.date = [NSDate date];
                             [self.signedArr removeAllObjects];
                             self.hidden = YES;
                             [self removeFromSuperview];
                         }
                     }];
}
- (void)lastMonthButtonClick {
    self.date = [FCCalendarTool lastMonth:self.date];
    [self.signedArr removeAllObjects];
    [self refreshUI];

    !self.lastOrNextMonthBlock ?: self.lastOrNextMonthBlock(self.date);
}

- (void)nextMonthButtonClick {
    self.date = [FCCalendarTool nextMonth:self.date];
    [self.signedArr removeAllObjects];
    [self refreshUI];
    
    !self.lastOrNextMonthBlock ?: self.lastOrNextMonthBlock(self.date);
}

#pragma mark - Public
- (void)show {
    if (!self.hidden) {
        return;
    }
    self.hidden = NO;
    [UIView animateWithDuration:0.25f
                     animations:^{
                         self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
                         [[[UIApplication sharedApplication] keyWindow] addSubview:self];
                         [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:self];
                     }];
}

#pragma mark - RefreshUI
- (void)refreshUI {
    NSString *yearMonthText = [NSString stringWithFormat:@"%@年%@月", @([FCCalendarTool year:self.date]), @([FCCalendarTool month:self.date])];
    self.yearMonthLabel.text = yearMonthText;
    // 刷新日期按钮
    [self refreshDayButton];
    // 刷新累计签到天数
    [self refreshTotalSignCountLabel];
}

- (void)refreshDayButton {
    // 上个月天数
    NSInteger daysInLastMonth = [FCCalendarTool totaldaysInMonth:[FCCalendarTool lastMonth:self.date]];
    // 这个月天数
    NSInteger daysInThisMonth = [FCCalendarTool totaldaysInMonth:self.date];
    // 这个月开始
    NSInteger firstWeekday    = [FCCalendarTool firstWeekdayInThisMonth:self.date];
    // 需要显示的行数
    NSInteger showRow = (daysInThisMonth + firstWeekday - 1) / 7 + 1;
    
    // 刷新高度
    self.bgImgView.height -= self.calendarbgImgView.height;
    CGFloat itemWidth = (self.bgImgView.frame.size.width - 2 * 30.0) / 7;
    self.calendarbgImgView.height = showRow * itemWidth;
    self.bgImgView.height += self.calendarbgImgView.height;
    
    
    for (NSInteger i = 0; i < 42; i ++) {
        // 行数
        NSInteger currentRow = i / 7;
        
        // 日期按钮
        FCCalendarDayControl *calendarDayControl = self.calendarBtnArr[i];
        [calendarDayControl reSetSubViews];
        
        // 算出日期
        NSInteger day = 0;
        if (i < firstWeekday) {
            calendarDayControl.hidden = NO;
            calendarDayControl.isCurrentMonthDay = NO;
            day = daysInLastMonth - firstWeekday + i + 1;
            calendarDayControl.title = [NSString stringWithFormat:@"%@", @(day)];
        } else if (i > firstWeekday + daysInThisMonth - 1) {
            if (currentRow < showRow) {
                calendarDayControl.hidden = NO;
                calendarDayControl.isCurrentMonthDay = NO;
                day = i + 1 - firstWeekday - daysInThisMonth;
                calendarDayControl.title = [NSString stringWithFormat:@"%@", @(day)];
            } else {
                calendarDayControl.hidden = YES;
                calendarDayControl.title = @"";
            }
        } else {
            calendarDayControl.hidden = NO;
            
            day = i - firstWeekday + 1;
            calendarDayControl.isCurrentMonthDay = YES;
            calendarDayControl.title = [NSString stringWithFormat:@"%@", @(day)];
            
            // 已签到
            [self.signedArr enumerateObjectsUsingBlock:^(NSNumber *timeInterval , NSUInteger idx, BOOL * _Nonnull stop) {
                NSDate *tempDate = [NSDate dateWithTimeIntervalSince1970:[timeInterval doubleValue]/1000];
                NSTimeZone *zone = [NSTimeZone systemTimeZone];
                NSInteger interval = [zone secondsFromGMTForDate:tempDate];
                NSDate *localeDate = [tempDate  dateByAddingTimeInterval: interval];
                if ([FCCalendarTool day:localeDate ] == day) {
                    calendarDayControl.isSign = YES;
                }
            }];
            
            // 今天
            NSInteger todayIndex = -1;
            if ([FCCalendarTool year:self.date] == [FCCalendarTool year:[NSDate date]] && [FCCalendarTool month:self.date] == [FCCalendarTool month:[NSDate date]]) {
                todayIndex = [FCCalendarTool day:self.date] + firstWeekday - 1;
                if (todayIndex == i) {
                    calendarDayControl.isToday = YES;
                }
            }
        }
    }
}

- (void)refreshTotalSignCountLabel {
    // 1. 创建一个属性文本
    NSString *content = [NSString stringWithFormat:@"已累计签到 %@ 天", self.signedCount ?: @""];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:content];
    // 2. 为文本设置属性
    attributedText.color = YTColorByNumber(2);
    attributedText.font = YTFont(7);
    attributedText.lineSpacing = 2.0;
    
    // 3. 创建一个"高亮"属性，当用户点击了高亮区域的文本时，"高亮"属性会替换掉原本的属性
    YYTextBorder *highlightBorder = [YYTextBorder borderWithFillColor:nil cornerRadius:3];
    YYTextHighlight *highlight = [YYTextHighlight new];
    [highlight setColor:[UIColor whiteColor]];
    [highlight setBackgroundBorder:highlightBorder];
    highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        NSLog(@"tap text range:...");
        // 你也可以把事件回调放到 YYLabel 和 YYTextView 来处理。
    };
    
    // 5. 把"高亮"属性设置到某个文本范围
    NSRange highlightRange = [content rangeOfString:[NSString stringWithFormat:@"%@", self.signedCount ?: @""]];
    [attributedText setTextHighlight:highlight range:highlightRange];
    [attributedText setColor:YTColorByNumber(2) range:highlightRange];
    [attributedText setFont:YTBoldFont(5) range:highlightRange];
    
    _totalSignCountLabel.attributedText = attributedText;
    _totalSignCountLabel.textAlignment = NSTextAlignmentCenter;
}

@end
