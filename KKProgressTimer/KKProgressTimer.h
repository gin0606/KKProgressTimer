//
//  KKProgressTimer.h
//  KKProgressTimer
//
//  Created by gin0606 on 2013/09/04.
//  Copyright (c) 2013年 gin0606. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KKProgressTimerDelegate;

typedef CGFloat (^KKProgressBlock)();

@interface KKProgressTimer : UIView
@property(nonatomic, weak) id <KKProgressTimerDelegate> delegate;

- (void)startWithBlock:(KKProgressBlock)block;

- (void)stop;
@end

@protocol KKProgressTimerDelegate
@optional
- (void)willUpdateProgressTimer:(KKProgressTimer *)progressTimer percentage:(CGFloat)percentage;

- (void)didUpdateProgressTimer:(KKProgressTimer *)progressTimer percentage:(CGFloat)percentage;

- (void)didStopProgressTimer:(KKProgressTimer *)progressTimer percentage:(CGFloat)percentage;
@end
