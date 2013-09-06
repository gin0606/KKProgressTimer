//
//  KKProgressTimer.m
//  KKProgressTimer
//
//  Created by gin0606 on 2013/09/04.
//
//  Copyright (c) 2013 gin0606(twitter@gin0606) All rights reserved.
//  https://github.com/gin0606
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


#import "KKProgressTimer.h"

#define UIColorMake(r, g, b, a) [UIColor colorWithRed:r / 255. green:g / 255. blue:b / 255. alpha:a]

@interface KKProgressTimer ()
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
    CGFloat radius = MIN(CGRectGetHeight(rect), CGRectGetWidth(rect)) * 0.5;
    CGFloat centerX = CGRectGetWidth(rect) * 0.5;
    CGFloat centerY = CGRectGetHeight(rect) * 0.5;

    [UIColorMake(155, 190, 225, 0.8) set];
    CGFloat fw = self.frameWidth + 1;
    CGRect frameRect = CGRectMake(
            centerX - radius + fw,
            centerY - radius + fw,
            (radius - fw) * 2,
            (radius - fw) * 2);
    UIBezierPath *insideFrame = [UIBezierPath bezierPathWithOvalInRect:frameRect];
    insideFrame.lineWidth = 2;
    [insideFrame stroke];
}

@end
