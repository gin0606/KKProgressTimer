//
//  KKProgressTimer.m
//  KKProgressTimer
//
//  Created by gin0606 on 2013/09/04.
//  Copyright (c) 2013年 gin0606. All rights reserved.
//

#import "KKProgressTimer.h"

@interface KKProgressTimer ()
@property(nonatomic, copy) KKProgressBlock block;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic) CGFloat progress;
@property(nonatomic) CGFloat lineWidth;
@property(nonatomic, strong) UIColor *circleBackgroundColor;
@property(nonatomic, strong) UIColor *circleProgressBackgroundColor;
@end

@implementation KKProgressTimer

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupParams];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupParams];
    }

    return self;
}

- (void)setupParams {
    self.backgroundColor = [UIColor clearColor];

    self.lineWidth = 5;
    self.circleBackgroundColor = [UIColor lightGrayColor];
    self.circleProgressBackgroundColor = [UIColor cyanColor];
}

- (void)startWithBlock:(KKProgressBlock)block {
    NSAssert(block, @"Can't start progress without progressBlock");
    self.block = block;
    if (!self.timer.isValid) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f / 30
                                                      target:self
                                                    selector:@selector(updateProgress)
                                                    userInfo:nil
                                                     repeats:YES];
        [self.timer fire];
    }
}

- (void)updateProgress {
    if ([self.delegate respondsToSelector:@selector(willUpdateProgressTimer:percentage:)]) {
        [self.delegate willUpdateProgressTimer:self percentage:self.progress];
    }
    self.progress = self.block();
    [self setNeedsDisplay];
    if ([self.delegate respondsToSelector:@selector(didUpdateProgressTimer:percentage:)]) {
        [self.delegate didUpdateProgressTimer:self percentage:self.progress];
    }
}

- (void)stop {
    [self.timer invalidate];
    if ([self.delegate respondsToSelector:@selector(didStopProgressTimer:percentage:)]) {
        [self.delegate didStopProgressTimer:self percentage:self.progress];
    }
    self.progress = 0;
    [self setNeedsDisplay];
}

#pragma mark draw progress
- (void)drawRect:(CGRect)rect {
    [self strokeCircleWithProgress:1.0 color:self.circleBackgroundColor lineWidth:self.lineWidth];
    [self strokeCircleWithProgress:self.progress color:self.circleProgressBackgroundColor lineWidth:self.lineWidth];
}

- (void)strokeCircleWithProgress:(CGFloat)progress color:(UIColor *)color lineWidth:(CGFloat)lineWidth {
    UIBezierPath *bezierPath = [self bezierPathWithProgress:progress];
    [color setStroke];
    bezierPath.lineWidth = lineWidth;
    [bezierPath stroke];
}

- (UIBezierPath *)bezierPathWithProgress:(CGFloat)progress {
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(width / 2, height / 2)
                                          radius:(MIN(width, height) - self.lineWidth) / 2
                                      startAngle:(CGFloat) -M_PI_2
                                        endAngle:(CGFloat) (-M_PI_2 + progress * 2 * M_PI) clockwise:YES];
}

@end
