//
//  KKViewController.m
//  KKProgressTimer
//
//  Created by gin0606 on 2013/09/04.
//  Copyright (c) 2013年 gin0606. All rights reserved.
//

#import "KKViewController.h"
#import "KKProgressTimer.h"

@interface KKViewController () <KKProgressTimerDelegate>
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;

@end

@implementation KKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    KKProgressTimer *timer1 = [[KKProgressTimer alloc] initWithFrame:self.view1.bounds];
    KKProgressTimer *timer2 = [[KKProgressTimer alloc] initWithFrame:self.view2.bounds];
    KKProgressTimer *timer3 = [[KKProgressTimer alloc] initWithFrame:self.view3.bounds];
    KKProgressTimer *timer4 = [[KKProgressTimer alloc] initWithFrame:self.view4.bounds];
    [self.view1 addSubview:timer1];
    [self.view2 addSubview:timer2];
    [self.view3 addSubview:timer3];
    [self.view4 addSubview:timer4];

    timer1.delegate = self;

    __block CGFloat i1 = 0;
    [timer1 startWithBlock:^CGFloat {
        return i1++ / 100;
    }];
    __block CGFloat i2 = 0;
    [timer2 startWithBlock:^CGFloat {
        return ((i2++ >= 100) ? (i2 = 0) : i2) / 100;
    }];
    __block CGFloat i3 = 0;
    [timer3 startWithBlock:^CGFloat {
        return ((i3++ >= 50) ? (i3 = 0) : i3) / 50;
    }];
    __block CGFloat i4 = 0;
    [timer4 startWithBlock:^CGFloat {
        return ((i4++ >= 10) ? (i4 = 0) : i4) / 10;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark KKProgressTimerDelegate Method
- (void)didUpdateProgressTimer:(KKProgressTimer *)progressTimer percentage:(CGFloat)percentage {
    if (percentage >= 1) {
        [progressTimer stop];
    }
}

- (void)didStopProgressTimer:(KKProgressTimer *)progressTimer percentage:(CGFloat)percentage {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
