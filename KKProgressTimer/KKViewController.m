//
//  KKViewController.m
//  KKProgressTimer
//
//  Created by gin0606 on 2013/09/04.
//  Copyright (c) 2013年 gin0606. All rights reserved.
//

#import "KKViewController.h"
#import "KKProgressTimer.h"

@interface KKViewController ()
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
