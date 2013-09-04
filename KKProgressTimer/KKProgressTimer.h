//
//  KKProgressTimer.h
//  KKProgressTimer
//
//  Created by gin0606 on 2013/09/04.
//  Copyright (c) 2013年 gin0606. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef CGFloat (^KKProgressBlock)();

@interface KKProgressTimer : UIView
- (void)startWithBlock:(KKProgressBlock)block;

- (void)stop;
@end
