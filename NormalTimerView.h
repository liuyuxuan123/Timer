//
//  NormalTimerView.h
//  Timer
//
//  Created by 刘宇轩 on 25/04/2017.
//  Copyright © 2017 liuyuxuan. All rights reserved.
//

#import <UIKit/UIKit.h>


@class NormalTimerView;

@protocol NormalTimerViewDelegate <NSObject>

-(void)timerWillStart:(NormalTimerView*)aView;
-(void)timerDidEnd:(NormalTimerView*)aView;

@end

@interface NormalTimerView : UIView

@property (nonatomic) CGFloat progress;
@property (nonatomic,getter=isRunning) BOOL running;
@property (nonatomic,getter=isFinished) BOOL finished;

@property (nonatomic)UIColor* labelTextColor;


@property (nonatomic)UIColor* progressColor;
@property (nonatomic)UIColor* progressStartColor;
@property (nonatomic)UIColor* progressNearFinishedColor;
@property (nonatomic)UIColor* progressAlmostFinishedColor;
@property (nonatomic)UIColor* progressFinishedColor;

@property (nonatomic,weak) id<NormalTimerViewDelegate> delegate;



-(void)setTimerWithDuration:(NSUInteger) durationInSeconds;
-(void)setTimerWithoutDuration;

-(void)startTimerWithDuration:(NSUInteger) durationInSeconds;
-(void)startTimerWithoutDuration; // Using Default Duration
-(BOOL)startTimerWithEndDate:(NSData*)endDate;

-(void)pauseTimer;
-(void)stopTimer;
-(void)resetTimer;
-(void)restartTimer;


-(NSUInteger)remainingDurationInSeconds;
-(NSUInteger)totalDurationInSeconds;
-(NSUInteger)currentDurationInSeconds;

@end
