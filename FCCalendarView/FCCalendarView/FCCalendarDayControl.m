//
//  FCCalendarDayControl.m
//  FCCalendarDemo
//
//  Created by yitudev12 on 2017/7/12.
//  Copyright © 2017年 yitu. All rights reserved.
//

#import "FCCalendarDayControl.h"

@interface FCCalendarDayControl ()

/// 背景
@property (nonatomic, strong) UIImageView *bgImgView;
/// 文字
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation FCCalendarDayControl

#pragma mark - LifyCycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 设置子视图
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews {
    [self addSubview:self.bgImgView];
    [self addSubview:self.textLabel];
}

#pragma mark - Set
- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    _timeInterval = timeInterval;
}

- (void)setIsCurrentMonthDay:(BOOL)isCurrentMonthDay {
    _isCurrentMonthDay = isCurrentMonthDay;
    
    if (_isCurrentMonthDay) {
        self.textLabel.textColor = YTColorByNumber(5);
    } else {
        self.textLabel.textColor = YTColorByNumber(8);
    }
}

- (void)setIsSign:(BOOL)isSign {
    _isSign = isSign;
    
    UIImage *bgImage = YTImage(@"Sign/Sign_History");
    if (_isSign) {
        self.bgImgView.frame = CGRectMake((self.width - bgImage.size.width)/2, (self.height - bgImage.size.height)/2, bgImage.size.width, bgImage.size.height);
        self.bgImgView.image = bgImage;
        self.textLabel.textColor = YTColorByNumber(19);
    }
}

- (void)setIsToday:(BOOL)isToday {
    _isToday = isToday;
    
    UIImage *bgImage = YTImage(@"Sign/Sign_Today");
    if (_isToday) {
        self.bgImgView.frame = CGRectMake((self.width - bgImage.size.width)/2, (self.height - bgImage.size.height)/2, bgImage.size.width, bgImage.size.height);
        self.bgImgView.image = bgImage;
        self.textLabel.textColor = YTColorByNumber(11);
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    _textLabel.text = _title;
}

#pragma mark - LazyLoad
- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [UIImageView new];
        _bgImgView.image = nil;
    }
    return _bgImgView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.width, self.height)];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = YTFont(2);
        _textLabel.textColor = YTColorByNumber(5);
    }
    return _textLabel;
}

#pragma mark - Public
/**
 回复成初始状态
 */
- (void)reSetSubViews {
    self.bgImgView.frame = CGRectZero;
    self.bgImgView.image = nil;
    self.textLabel.text = @"";
    self.textLabel.textColor = YTColorByNumber(5);
}

@end
