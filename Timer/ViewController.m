//
//  ViewController.m
//  Timer
//
//  Created by 刘宇轩 on 25/04/2017.
//  Copyright © 2017 liuyuxuan. All rights reserved.
//

#import "ViewController.h"
#import "NormalTimerView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    CAShapeLayer* layer = [CAShapeLayer layer];
//    layer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))
//                                                radius:self.view.bounds.size.width / 2
//                                            startAngle:0
//                                              endAngle:M_PI
//                                             clockwise:YES].CGPath;
//    layer.fillColor = [UIColor clearColor].CGColor;
//    layer.strokeColor = [UIColor blackColor].CGColor;
//
//    [self.view.layer addSublayer:layer];
    
    NormalTimerView* aView = [[NormalTimerView alloc]initWithFrame:CGRectMake(100, 100,200,200)];
    [aView startTimerWithDuration:10];
    [self.view addSubview:aView];
    
  
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
