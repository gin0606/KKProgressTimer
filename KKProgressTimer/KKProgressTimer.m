//
//  KKProgressTimer.m
//  KKProgressTimer
//
//  Created by gin0606 on 2013/09/04.
//  Copyright (c) 2013年 gin0606. All rights reserved.
//

#import "KKProgressTimer.h"

#define UIColorMake(r, g, b, a) [UIColor colorWithRed:r / 255. green:g / 255. blue:b / 255. alpha:a]

@interface KKProgressTimer ()
@property(nonatomic) CGFloat frameWidth;
@property(nonatomic, strong) UIColor *progressColor;
@property(nonatomic, strong) UIColor *progressBackgroundColor;
@property(nonatomic, strong) UIColor *circleBackgroundColor;

@property(nonatomic) CGFloat progress;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, copy) KKProgressBlock block;
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

    self.frameWidth = 3;
    self.progressColor = UIColorMake(44, 103, 175, 1);
    self.progressBackgroundColor = UIColorMake(190, 223, 244, 1);
    self.circleBackgroundColor = [UIColor whiteColor];
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
    [self drawFillPie:rect margin:0 color:self.circleBackgroundColor percentage:1];
    [self drawFramePie:rect];
    [self drawFillPie:rect margin:self.frameWidth color:self.progressBackgroundColor percentage:1];
    [self drawFillPie:rect margin:self.frameWidth color:self.progressColor percentage:self.progress];
}

- (void)drawFillPie:(CGRect)rect margin:(CGFloat)margin color:(UIColor *)color percentage:(CGFloat)percentage {
    CGFloat radius = MIN(CGRectGetHeight(rect), CGRectGetWidth(rect)) * 0.5 - margin;
    CGFloat centerX = CGRectGetWidth(rect) * 0.5;
    CGFloat centerY = CGRectGetHeight(rect) * 0.5;

    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(cgContext, [color CGColor]);
    CGContextMoveToPoint(cgContext, centerX, centerY);
    CGContextAddArc(cgContext, centerX, centerY, radius, (CGFloat) -M_PI_2, (CGFloat) (-M_PI_2 + M_PI * 2 * percentage), 0);
    CGContextClosePath(cgContext);
    CGContextFillPath(cgContext);
}

- (void)drawFramePie:(CGRect)rect {
    [UIColorMake(155, 190, 225, 0.8) set];
    CGFloat fw = self.frameWidth + 1;
    CGRect frameRect = CGRectMake(
            rect.origin.x + fw,
            rect.origin.y + fw,
            rect.size.width - fw * 2,
            rect.size.height - fw * 2);
    UIBezierPath *insideFrame = [UIBezierPath bezierPathWithOvalInRect:frameRect];
    insideFrame.lineWidth = 2;
    [insideFrame stroke];
}

@end
