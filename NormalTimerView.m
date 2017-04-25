//
//  NormalTimerView.m
//  Timer
//
//  Created by 刘宇轩 on 25/04/2017.
//  Copyright © 2017 liuyuxuan. All rights reserved.
//

#import "NormalTimerView.h"
#import <QuartzCore/QuartzCore.h>


static NSString* timer_animation_key = @"timerKey";


@interface NormalTimerView()

@property (nonatomic) NSUInteger remainingTimeInSeconds;
@property (nonatomic) NSUInteger totalTimeInSeconds;
@property (nonatomic) NSUInteger currentUsedTimeInSeconds;

@property (nonatomic) CGFloat strokeWidth;
@property (nonatomic) NSTimer* viewTimer;

@property (nonatomic) UILabel* timerLabel;
@property (nonatomic) UIBezierPath* strokePath;
@property (nonatomic) CAShapeLayer* progressLayer;

@end




@implementation NormalTimerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init{
    return [self initWithFrame:CGRectMake(0, 0, 50, 50)];
}


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setup];
    }
    return self;
}



-(void) setup{
    // Set up here
    
    
    self.remainingTimeInSeconds = 0;
    self.totalTimeInSeconds  = 0;
    self.currentUsedTimeInSeconds = 0;
    
    self.backgroundColor = [UIColor clearColor];
    self.progressColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:51/255.0 alpha:1.0];
    self.progressStartColor = [UIColor colorWithRed:51/255.0 green:204/255.0 blue:51/255.0 alpha:1.0];
    self.progressNearFinishedColor = [UIColor colorWithRed:1.0 green:204/255.0 blue:51/255.0 alpha:1.0];
    self.progressAlmostFinishedColor = [UIColor redColor];
    self.progressFinishedColor = [UIColor darkGrayColor];
    
    [self createLabel];
    
    
    
    [self createLayer];
    [self createPath];
    
    
    
   
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    // Set it;
    self.progressLayer.frame = self.bounds;
}

-(void)setTimerWithDuration:(NSUInteger)durationInSeconds{
    self.remainingTimeInSeconds = durationInSeconds;
    self.totalTimeInSeconds = durationInSeconds;
    
    [self setProgress:1 animated:NO];
    [self updateLabelText];
    [self setNeedsDisplay];
    
   
}

-(void)setTimerWithoutDuration{
    
    self.remainingTimeInSeconds = 60;
    self.totalTimeInSeconds = 60;
    
    [self setProgress:1 animated:NO];
    [self updateLabelText];
    [self setNeedsDisplay];
    
}

-(void)startTimer{
    [self startTick];
    self.running = YES;
    self.finished = NO;
}

-(void)startTimerWithDuration:(NSUInteger)durationInSeconds{
    [self setTimerWithDuration:durationInSeconds];
    [self startTimer];
}
- (void)pauseTimer {
    [self invalidateTimer];
    
    self.running = NO;
}

-(void)stopTimer{
    self.remainingTimeInSeconds = 0;
    [self pauseTimer];
    self.progressColor = self.progressFinishedColor;
    
    [self updateLabelText];
    [self updateProgress];
    [self setNeedsDisplay];
}

- (void)resetTimer {
    self.remainingTimeInSeconds = self.totalTimeInSeconds;
    
    [self pauseTimer];
    
    [self updateLabelText];
    [self updateProgress];
    [self setNeedsDisplay];
}

- (void)restartTimer {
    [self resetTimer];
    
    [self startTimer];
}

-(void)startTimerWithoutDuration{
    
}


-(NSUInteger)remainingDurationInSeconds {
    return self.remainingTimeInSeconds;
}

-(NSUInteger)totalDurationInSeconds {
    return self.totalTimeInSeconds;
}

-(NSUInteger)currentDurationInSeconds{
    return self.currentUsedTimeInSeconds ;
}


-(void)startTick{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self invalidateTimer];
        [self.delegate timerWillStart:self];
        self.viewTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                        selector:@selector(tick:)
                                                        userInfo:nil
                                                         repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:self.viewTimer forMode:NSRunLoopCommonModes];
    });
}

-(void)tick:(id)sender{
    NSLog(@"tick");
    if(self.remainingTimeInSeconds <= 1){
        [self stopTimer];
        self.finished = YES;
        self.currentUsedTimeInSeconds ++;
        if(self.delegate){
            [self.delegate timerDidEnd:self];
        }
    }else{
        self.remainingTimeInSeconds --;
        self.currentUsedTimeInSeconds  ++;
        [self updateProgress];
    }
    
    [self updateLabelText];
    [self setNeedsDisplay];

}


-(void) invalidateTimer{
    if(self.viewTimer){
        [self.viewTimer invalidate];
        self.viewTimer = nil;
    }
}


-(void)createLabel{
    self.timerLabel =  [[UILabel alloc]init];
    self.timerLabel.text = @"0";
    self.timerLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.timerLabel];
    
    self.timerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint* centerXConstraint = [NSLayoutConstraint constraintWithItem:self.timerLabel
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1.0
                                                                          constant:0];
    
    NSLayoutConstraint* centerYConstraint = [NSLayoutConstraint constraintWithItem:self.timerLabel
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1.0
                                                                          constant:0];
    
    
    [self addConstraints:@[centerXConstraint,centerYConstraint]];

}

-(void)createPath{
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.progressLayer.path = [UIBezierPath bezierPathWithArcCenter:center
                                                             radius:self.bounds.size.width / 2 - 6
                                                         startAngle:-M_PI_2
                                                           endAngle:-M_PI_2 + 2 * M_PI
                                                          clockwise:YES].CGPath;

}

-(void)createLayer{
    self.strokeWidth = CGRectGetWidth(self.bounds) / 15;
    
    CAShapeLayer* progressLayer = [CAShapeLayer layer];
    //progressLayer.path = self.strokePath.CGPath;
    progressLayer.fillColor = [[UIColor clearColor]CGColor];
   // progressLayer.fillColor = [[UIColor redColor]CGColor];
    progressLayer.strokeColor = [self.progressStartColor CGColor];
    progressLayer.lineWidth = self.strokeWidth;
  
    progressLayer.strokeEnd = 0;
    progressLayer.strokeColor = [[UIColor blackColor]CGColor];
    
    self.progressLayer = progressLayer;
    [self.layer addSublayer:progressLayer];
    
}


-(CGFloat)sanitizeProgressValue:(CGFloat)progress{
    if(progress > 1){
        return 1;
    }else if(progress  < 0){
        return 0;
    }else{
        return progress;
    }
}

-(void)setProgress:(CGFloat)progress{
    progress = [self sanitizeProgressValue:progress];
    if(progress > 0){
        self.remainingTimeInSeconds = (NSUInteger)(self.totalTimeInSeconds * progress);
        [self.progressLayer removeAnimationForKey:timer_animation_key];
        [self setProgress:progress animated:NO];
    }else{
        [self stopTimer];
    }
}

-(void)setProgress:(CGFloat)progress animated:(BOOL)animated{
    
   
    progress = [self sanitizeProgressValue:progress];
    
    if(progress > 0.4){
        self.progressColor = self.progressStartColor;
    }else if(progress > 0.15 && self.remainingTimeInSeconds > 1){
        self.progressColor = self.progressNearFinishedColor;
    }else if(progress == 0){
        self.progressColor = self.progressFinishedColor;
    }else {
        self.progressColor = self.progressAlmostFinishedColor;
    }
    
    
    if(progress > 0){
        if(animated){

      
            CABasicAnimation* animation = [CABasicAnimation animation];
            animation.keyPath = @"strokeEnd";
            animation.fromValue = progress == 0 ? @0 : nil;
            animation.toValue = [NSNumber numberWithFloat:progress];
            animation.duration = 1;
            
            self.progressLayer.strokeEnd = progress;
            
            [self.progressLayer addAnimation:animation forKey:timer_animation_key];
        }else{
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            self.progressLayer.strokeEnd = progress;
            [CATransaction commit];
        }
    }else{
        self.progressLayer.strokeEnd = 0.0;
        //set it
        [self.progressLayer removeAnimationForKey:timer_animation_key];
    }
    _progress = progress;
    [self updateLabelText];
}


-(void)updateProgress{
    CGFloat progress = ((CGFloat)self.remainingTimeInSeconds) / self.totalTimeInSeconds;
    [self setProgress:progress animated:YES];
    
}

-(void)updateLabelText{
    NSUInteger numHours = self.currentUsedTimeInSeconds / 3600;
    NSUInteger numMinutes = (self.currentUsedTimeInSeconds % 3600) / 60;
    NSUInteger numSecond = self.currentUsedTimeInSeconds % 60;
 
    if(numHours > 9){
        self.timerLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",numHours,numMinutes,numSecond];
    }else if(numHours > 0){
        self.timerLabel.text = [NSString stringWithFormat:@"%01ld:%02ld:%02ld",numHours,numMinutes,numSecond];
    }else if(numMinutes > 0){
        self.timerLabel.text = [NSString stringWithFormat:@"%01ld:%02ld",numMinutes,numSecond];
    }else{
        self.timerLabel.text = [NSString stringWithFormat:@"%01ld",numSecond];
    }
}


-(void)setProgressColor:(UIColor *)progressColor{
    _progressColor = progressColor;
    self.progressLayer.strokeColor = progressColor.CGColor;
    [self setNeedsDisplay];
}

-(void)setLabelTextColor:(UIColor *)labelTextColor{
    _labelTextColor = labelTextColor;
    self.timerLabel.textColor = labelTextColor;
    [self setNeedsDisplay];
}


-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.progressColor.CGColor);
    CGContextSetLineWidth(context, self.strokeWidth / 4);
    CGContextSetStrokeColorWithColor(context, self.progressColor.CGColor);
    CGContextStrokeEllipseInRect(context, CGRectInset(self.bounds, 6, 6));
    
}





@end
